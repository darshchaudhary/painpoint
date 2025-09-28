import 'package:flutter/material.dart';

class PastReportsPage extends StatelessWidget {
  final List<Map<String, dynamic>> pastReports = [
    {
      "date": DateTime.now().subtract(const Duration(days: 1)),
      "summary": "Pain in right arm and shoulder. Possible strain or tendonitis.",
      "recommendations": [
        "Apply ice for 15–20 minutes.",
        "Avoid heavy lifting for 48 hours.",
        "Consider gentle stretching.",
        "Consult a physiotherapist if pain persists."
      ]
    },
    {
      "date": DateTime.now().subtract(const Duration(days: 3)),
      "summary": "Eye pain reported. Possible eye strain or dryness.",
      "recommendations": [
        "Follow the 20-20-20 rule.",
        "Use lubricating eye drops.",
        "Schedule an eye exam if symptoms persist."
      ]
    },
    {
      "date": DateTime.now().subtract(const Duration(days: 5)),
      "summary": "Lower back discomfort after prolonged sitting.",
      "recommendations": [
        "Practice ergonomic sitting posture.",
        "Take standing breaks every 30 minutes.",
        "Apply a warm compress to relax muscles.",
        "Strengthen core muscles with light exercises."
      ]
    },
    {
      "date": DateTime.now().subtract(const Duration(days: 7)),
      "summary": "Knee pain during running. Possible overuse injury.",
      "recommendations": [
        "Rest and reduce high-impact activity.",
        "Use supportive footwear.",
        "Apply ice after exercise.",
        "Gradually reintroduce activity with low-impact cardio."
      ]
    },
    {
      "date": DateTime.now().subtract(const Duration(days: 10)),
      "summary": "Neck stiffness and tension headaches.",
      "recommendations": [
        "Perform gentle neck stretches.",
        "Adjust workstation ergonomics.",
        "Stay hydrated throughout the day.",
        "Consider massage or relaxation techniques."
      ]
    },
    {
      "date": DateTime.now().subtract(const Duration(days: 14)),
      "summary": "Ankle swelling after minor twist.",
      "recommendations": [
        "Follow the R.I.C.E. method (Rest, Ice, Compression, Elevation).",
        "Avoid weight-bearing until swelling reduces.",
        "Wear supportive footwear.",
        "Seek medical evaluation if swelling persists."
      ]
    },
  ];


  PastReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Past Reports"),
        backgroundColor: Colors.teal.shade600,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pastReports.length,
        itemBuilder: (context, index) {
          final report = pastReports[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(
                report["summary"],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _formatDate(report["date"]),
                style: TextStyle(color: Colors.grey.shade600),
              ),
              children: [
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Recommendations:",
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      ...report["recommendations"].map<Widget>((rec) => ListTile(
                        leading: const Icon(Icons.check_circle, color: Colors.teal),
                        title: Text(rec),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.month}/${date.day}/${date.year}";
  }
}
