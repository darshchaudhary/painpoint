import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SearchPage extends StatefulWidget {
  final String searchText;
  const SearchPage({required this.searchText});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const redAccent = Color(0xFFE53935);
  static const lightBackground = Color(0xFFF9F9F9);
  String? answer;
  bool isLoading = false;
  String? newSearchText;

  Future<String> fetchAnswerFromOpenAI(String query) async {
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "gpt-4o-mini", // lightweight, fast model
        "messages": [
          {"role": "system", "content": "You are a friendly, knowledgeable health information assistant; help users understand possible explanations for symptoms; provide clear, easy-to-understand educational information; suggest safe next steps such as consulting a licensed healthcare professional; always remind users you are not a doctor and cannot provide a diagnosis or treatment; keep your tone supportive, approachable, and non-alarming; offer practical self-care tips when appropriate while emphasizing professional evaluation for persistent or severe symptoms. Politely refuse to answer any questions besides general greetings that are not related to medical symptoms and conditions. Do not bold any words in your answers"},
          {"role": "user", "content": query}
        ],
        "max_tokens": 200,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception("Failed to fetch answer: ${response.body}");
    }
  }

  Future<void> _getAnswer(String searchtext) async {
    setState(() => isLoading = true);
    try {
      final result = await fetchAnswerFromOpenAI(searchtext);
      setState(() => answer = result);
    } catch (e) {
      setState(() => answer = "Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _getAnswer(widget.searchText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 50),
            padding: EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded),
              color: Colors.black,
              alignment: Alignment.topLeft,
            ),
          ),
          Hero(
            tag: "searchBar",
            child: Material(
              color: Colors.transparent,
              child: Container(
                height: 75,
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) {
                    newSearchText = value;
                  },
                  decoration: InputDecoration(
                    hintText: widget.searchText,
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey.shade500,
                      fontSize: 15,
                    ),
                    icon: IconButton(
                        onPressed: () {
                          _getAnswer(newSearchText.toString());
                        },
                        icon: Icon(
                          Icons.search,
                          color: Colors.black,
                        )),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                          answer ?? "No answer yet",
                        ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
