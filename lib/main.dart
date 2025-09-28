import "package:flutter/material.dart";
import "package:painpoint/chatbot.dart";
import "package:painpoint/diagnosis_page.dart";
import "package:painpoint/landing_page.dart";
import "package:painpoint/locate_page.dart";
import "package:painpoint/login_page.dart";
import "package:painpoint/past_reports.dart";
import "package:painpoint/registration_page.dart";
import "package:painpoint/search_page.dart";
import "package:painpoint/welcome_page.dart";
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'welcome_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "apikey.env");
  print('Welcome to PainPoint');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(
      PainPoint(),
  );
}

class PainPoint extends StatelessWidget {
  const PainPoint({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'welcome',
      routes: {
        'welcome': (context) => WelcomePage(),
        'login' : (context) => LoginPage(),
        'registration': (context) => RegistrationPage(),
        'landing': (context) => LandingPage(),
        'locate': (context) => LocatePage(),
        'chatbot': (context) => ChatbotPage(),
        'diagnosis': (context) => DiagnosisPage(),
        'reports': (context) => PastReportsPage()
      },
    );
  }
}