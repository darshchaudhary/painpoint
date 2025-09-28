import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DiagnosisPage extends StatefulWidget {
  const DiagnosisPage({super.key});

  @override
  State<DiagnosisPage> createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> {
  List<String> selectedParts = [];
  String? diagnosisSummary;
  List<String> recommendations = [];
  bool loading = false;

  Future<void> _pickAndProcessFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        final contents = await file.readAsString();

        // Parse plain text: one body part per line
        final parts = contents
            .split(RegExp(r'[\r\n]+'))
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();

        setState(() {
          selectedParts = parts;
          loading = true;
        });

        // Call API with parsed parts
        await _fetchDiagnosis(parts);
      }
    } catch (e) {
      debugPrint("Error reading file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to read file: $e")),
      );
    }
  }

  Future<void> _fetchDiagnosis(List<String> parts) async {
    try {
      final apiKey = dotenv.env['OPENAI_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception("API key not found in .env");
      }

      final response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",
          "messages": [
            {
              "role": "system",
              "content": "You are a digital health assistant. "
                  "The patient has entered body areas where they are experiencing pain. "
                  "Generate a structured report with three sections:"
                  "1. Summary of Pain Areas"
                  "2. Possible internal Conditions/Causes that give rise to the pain"
                  "3. Recommendations (3–5 general next steps)"
                  "4. Don't bold any text when giving the output\n"
                  "Keep the tone professional, supportive, and clear. "
                  "Do not provide emergency medical advice."
            },
            {
              "role": "user",
              "content": "The patient reports pain in: ${parts.join(', ')}"
            }
          ],
        }),
      );

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;

        // --- Parse sections ---
        String? summary;
        List<String> conditions = [];
        List<String> recs = [];

        // Summary of Pain Areas
        final summaryMatch = RegExp(
          r"(?:1\.\s*)?Summary of Pain Areas[:\s]*([\s\S]+?)(?=\n\d+\.|$)",
          caseSensitive: false,
        ).firstMatch(content);
        if (summaryMatch != null) {
          summary = summaryMatch.group(1)?.trim();
        }

        // Conditions / Causes
        final conditionsMatch = RegExp(
          r"(?:2\.\s*)?(?:Possible.*?(?:Conditions|Causes))[:\s]*([\s\S]+?)(?=\n\d+\.|$)",
          caseSensitive: false,
        ).firstMatch(content);
        if (conditionsMatch != null) {
          conditions = conditionsMatch
              .group(1)!
              .split(RegExp(r'\n\d+\.'))
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toList();
        }

        // Recommendations
        final recsMatch = RegExp(
          r"(?:3\.\s*)?Recommendations[:\s]*([\s\S]+)",
          caseSensitive: false,
        ).firstMatch(content);
        if (recsMatch != null) {
          recs = recsMatch
              .group(1)!
              .split(RegExp(r'\n\d+\.'))
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toList();
        }

        setState(() {
          diagnosisSummary = summary ?? "No summary extracted.";
          recommendations = [
            if (conditions.isNotEmpty) ...conditions,
            if (recs.isNotEmpty) ...recs,
          ];
          loading = false;
        });
      } else {
        throw Exception("API error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching diagnosis: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diagnosis Report"),
        backgroundColor: Colors.teal.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                onPressed: _pickAndProcessFile,
                icon: const Icon(Icons.upload_file),
                label: const Text("Import Unity File"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              if (selectedParts.isNotEmpty) ...[
                Text("Selected Body Parts:",
                    style: Theme.of(context).textTheme.titleLarge),
                Wrap(
                  spacing: 8,
                  children: selectedParts
                      .map((part) => Chip(
                    label: Text(part),
                    backgroundColor: Colors.teal.shade50,
                    labelStyle:
                    const TextStyle(color: Colors.teal),
                  ))
                      .toList(),
                ),
              ],
              if (diagnosisSummary != null) ...[
                const SizedBox(height: 20),
                Text("Diagnosis:",
                    style: Theme.of(context).textTheme.titleLarge),
                Text(diagnosisSummary!,
                    style: const TextStyle(fontSize: 16, height: 1.4)),
              ],
              if (recommendations.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text("Recommendations:",
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Card(
                  color: Colors.teal.shade50,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < recommendations.length; i++)
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.check_circle,
                                    color: Colors.teal.shade600,
                                    size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "${i + 1}. ${recommendations[i]}",
                                    style: const TextStyle(
                                        fontSize: 16, height: 1.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
