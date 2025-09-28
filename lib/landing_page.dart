import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'search_page.dart';


class LandingPage extends StatefulWidget {
   LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  static const redAccent = Color(0xFFE53935);
  static const lightBackground = Color(0xFFF9F9F9);
  String? searchText;

  final formatted = DateFormat.yMMMMd().format(DateTime.now());

  final _auth = FirebaseAuth.instance;
  User? loggedInUser;
  String? firstName;
  String? lastName;
  String? dob;

  @override
  void initState() {
    super.initState();
    getCurrentUser();

  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser?.email);
      }
      final uid = _auth.currentUser!.uid;
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        setState(() {
          firstName = doc['firstName'];
          lastName = doc['lastName'];
          dob = doc['dob'];
        });
        print("First name: $firstName");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              // Greeting header
              Container(
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                padding: const EdgeInsets.all(15),
                height: 100,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello,',
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          firstName.toString(),
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: redAccent,
                      child: IconButton(
                          onPressed: () {
                            _auth.signOut();
                            Navigator.pushNamed(context, 'welcome');
                          },
                          icon:  Icon(Icons.logout_rounded, color: Colors.white)
                      ),
                    ),
                  ],
                ),
              ),

              // Profile card
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: redAccent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person, color: redAccent),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${firstName} ${lastName}',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '21 years old',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Icon(Icons.navigate_next,
                            size: 40, color: Colors.white),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Divider(color: Colors.white54, thickness: 0.5),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          '${formatted}',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Search bar
              Hero(
                tag: "searchBar",
                child: Material(
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
                        setState(() {
                          searchText = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search for Specific Symptoms',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey.shade500,
                          fontSize: 15,
                        ),
                        icon: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchPage(searchText: searchText.toString()),
                                ),
                              );
                            },
                            icon: Icon(Icons.search)
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),

              // Quick action buttons
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                height: 102,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:  [
                    _ColumnButton(icon: Icons.contact_page_rounded, label: 'Reports', route: 'reports'),
                    _ColumnButton(icon: Icons.location_searching_rounded, label: 'Locate', route: 'locate',),
                    _ColumnButton(icon: Icons.history_rounded, label: 'History', route: 'locate'),
                    _ColumnButton(icon: Icons.chat_bubble_rounded, label: 'Chat with AI', route: 'chatbot'),
                  ],
                ),
              ),

              // Section header
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.all(15),
                child: Text(
                  'Access 3D model',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ),

              // Placeholder for content cards
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            height: 150,
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
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                elevation: MaterialStateProperty.all(0),
                overlayColor: MaterialStateProperty.all(Colors.grey.shade50),
              ),
              onPressed: () {
                Navigator.pushNamed(context, 'diagnosis');
              },
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('images/model_preview.png'),
                      height: 50,
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Locate area of pain",
                      style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColumnButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String route;
   _ColumnButton({required this.icon, required this.label, required this.route});

  @override
  State<_ColumnButton> createState() => _ColumnButtonState();
}

class _ColumnButtonState extends State<_ColumnButton> {

  void whenPressed(String route){
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    const redAccent = Color(0xFFE53935);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            color: redAccent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: IconButton(
              onPressed: () {whenPressed(widget.route);},
              icon: Icon(widget.icon, color: Colors.white, size: 22)
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
