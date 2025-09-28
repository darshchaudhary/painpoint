import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LocatePage extends StatefulWidget {
  const LocatePage({super.key});

  static const redAccent = Color(0xFFE53935);
  static const lightBackground = Color(0xFFF9F9F9);

  @override
  State<LocatePage> createState() => _LocatePageState();
}

class _LocatePageState extends State<LocatePage> {
  @override
  Widget build(BuildContext context) {
    final doctors = [
      {
        "name": "Physician Care Centers - Atlanta Midtown",
        "address": "550 Peachtree St NE #1700, Atlanta, GA 30308",
        "rating": 3.6,
        "open": "Closed ⋅ Opens 7:30 AM Mon"
      },
      {
        "name": "Atlanta Medical Clinic",
        "address": "197 14th St NW #300, Atlanta, GA 30318",
        "rating": 4.7,
        "open": "Closed ⋅ Opens 8:30 AM Mon"
      },
      {
        "name": "Highland Urgent Care & Family Medicine",
        "address": "920 Ponce De Leon Ave NE, Atlanta, GA 30306",
        "rating": 4.0,
        "open": "Closed ⋅ Opens 9 AM Mon"
      },
      {
        "name": "Jeffrey Haller, MD",
        "address": "1080 Peachtree St NE Suite 12, Atlanta, GA 30309",
        "rating": 4.8,
        "open": "Closed ⋅ Opens 7:30 AM Mon"
      },
      {
        "name": "Piedmont Physicians at Atlantic Station",
        "address": "232 19th St NW Suite 7220, Atlanta, GA 30363",
        "rating": 3.6,
        "open": "Closed ⋅ Opens 8:30 AM Mon"
      },
      {
        "name": "Laureate Medical Group",
        "address": "1110 W Peachtree St NW Ste 1100, Atlanta, GA 30309",
        "rating": 3.0,
        "open": "Closed ⋅ Opens 8 AM Mon"
      },
      {
        "name": "Village Podiatry Midtown",
        "address": "550 Peachtree St NE #1960, Atlanta, GA 30308",
        "rating": 4.7,
        "open": "Closed ⋅ Opens 8 AM Mon"
      },
      {
        "name": "AllCare Primary & Immediate Care",
        "address": "1000 Northside Dr NW Suite 1300, Atlanta, GA 30318",
        "rating": 4.7,
        "open": "Closed ⋅ Opens 9 AM Sun"
      },
    ];

    return Scaffold(
      backgroundColor: LocatePage.lightBackground,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {Navigator.pop(context);},
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white)
        ),
        title: Text("Nearby Doctors",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
        backgroundColor: LocatePage.redAccent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doc = doctors[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doc["name"]!.toString(),
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(doc["address"]!.toString(),
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: Colors.grey.shade600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber.shade600, size: 18),
                    const SizedBox(width: 4),
                    Text("${doc["rating"]}",
                        style: GoogleFonts.poppins(
                            fontSize: 13, fontWeight: FontWeight.w500)),
                    const Spacer(),
                    Text(doc["open"]!.toString(),
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.grey.shade700)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
