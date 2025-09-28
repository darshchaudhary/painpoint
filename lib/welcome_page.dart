import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final List<String> texts = [
    "Easily highlight where it hurts and share with your doctor.",
    "Tap, trace, and let your care team see what you feel.",
    "Access our 3D model wireframe to pinpoint where you feel discomfort."
  ];

  final List<String> images = [
    "images/body_1.png",
    "images/body_2.png",
    "images/body_3.png",
    "images/body_4.png",
    "images/body_5.png",
    "images/body_6.png",
  ];

  String? currentImage = "images/body_3.png";

  void pickRandomImage() {
    final random = Random();
    setState(() {
      currentImage = images[random.nextInt(images.length)];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    pickRandomImage();
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white
              ),
              margin: const EdgeInsets.fromLTRB(15, 75, 15, 15),
              width: double.infinity,
              child:  Image(
                image: AssetImage(currentImage!),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration:  BoxDecoration(
                color: Color(0xFFFEFDFD),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // shadow color
                    offset: const Offset(0, -3), // negative y = top
                    blurRadius: 10,
                    spreadRadius: 0.5,
                  ),
                ],

              ),
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      Text(
                        'Map your body, discover your \nrelief.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'poppins',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        texts[0],
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          fontFamily: 'poppins',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE53935),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, 'login');
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xFFE53935),
                            ),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFFFFF),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, 'registration');
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Color(0xFFE53935),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
