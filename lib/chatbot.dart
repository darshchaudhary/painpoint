import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = []; // {role: "user"/"assistant", content: "..."}

  bool _isLoading = false;

  static const redAccent = Color(0xFFE53935);
  static const darkBackground = Color(0xFF121212);
  static const cardBackground = Color(0xFF1E1E1E);

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "content": text});
      _isLoading = true;
    });

    _controller.clear();

    try {
      final apiKey = dotenv.env['OPENAI_API_KEY'];
      final url = Uri.parse("https://api.openai.com/v1/chat/completions");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",
          "messages": [
            {"role": "system", "content": "You are a helpful in-app assistant. Your name is Dr.House. Help users navigate the app and answer their queries in a supportive, concise way."},
            ..._messages.map((m) => {"role": m["role"], "content": m["content"]}),
          ],
          "max_tokens": 200,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'];

        setState(() {
          _messages.add({"role": "assistant", "content": reply});
        });
      } else {
        setState(() {
          _messages.add({"role": "assistant", "content": "Oops, something went wrong: ${response.body}"});
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({"role": "assistant", "content": "Error: $e"});
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);},
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white,)),
        title: Text("Helper Assistant",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
        backgroundColor: redAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg["role"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(
                      color: isUser ? redAccent : cardBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg["content"] ?? "",
                      style: GoogleFonts.poppins(
                        color: isUser ? Colors.white : Colors.grey.shade200,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(color: Colors.white),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: cardBackground,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Ask me anything...",
                      hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500),
                      border: InputBorder.none,
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: redAccent),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
          Container(
            height: 16,
            color: cardBackground,
          )
        ],
      ),
    );
  }
}
