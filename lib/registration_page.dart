import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _agreeToTerms = false;

  final _firestore = FirebaseFirestore.instance;

  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    const redAccent = Color(0xFFE53935);

    return Scaffold(
      backgroundColor: redAccent,
      body: Column(
        children: [
          // Top fixed section
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                  color: redAccent,
                child: Center(
                  child: Text(
                    'Sign Up',
                    style: GoogleFonts.poiretOne(
                      fontSize: 60,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
              ),
            ),
          ),

          // Bottom scrollable form section
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        "Relieve your pain with us.",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // First Name
                      TextFormField(
                        controller: _firstNameController,
                        onChanged: (value) {

                        },
                        decoration: InputDecoration(
                          labelText: "First Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        validator: (value) =>
                        value == null || value.isEmpty ? "First name is required" : null,
                      ),
                      const SizedBox(height: 20),

                      // Last Name
                      TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: "Last Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        validator: (value) =>
                        value == null || value.isEmpty ? "Last name is required" : null,
                      ),
                      const SizedBox(height: 20),

                      // Date of Birth
                      TextFormField(
                        controller: _dobController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Date of Birth",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          prefixIcon: const Icon(Icons.calendar_today_outlined),
                        ),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            _dobController.text =
                            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                          }
                        },
                        validator: (value) =>
                        value == null || value.isEmpty ? "Date of birth is required" : null,
                      ),
                      const SizedBox(height: 20),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Email is required";
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!emailRegex.hasMatch(value)) return "Enter a valid email";
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Password
                      TextFormField(
                        controller: _passwordController,
                        onChanged: (value) {
                          password = value;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: const Icon(Icons.visibility_off_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Password is required";
                          if (value.length < 6) return "Password must be at least 6 characters";
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Confirm Password
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _confirmController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Re-enter Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: const Icon(Icons.visibility_off_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Please re-enter your password";
                          if (value != _passwordController.text) return "Passwords do not match";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Terms
                      Row(
                        children: [
                          Checkbox(
                            value: _agreeToTerms,
                            onChanged: (val) {
                              setState(() => _agreeToTerms = val ?? false);
                            },
                            activeColor: redAccent,
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.black87,
                                ),
                                children: [
                                  const TextSpan(text: "By checking the box, you agree to our "),
                                  TextSpan(
                                    text: "Terms and Conditions",
                                    style: const TextStyle(
                                      color: redAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Register button
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: redAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (!_agreeToTerms) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("You must agree to the Terms and Conditions"),
                                  ),
                                );
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Registration successful!")),
                              );

                              try {
                                final newUser = await _auth.createUserWithEmailAndPassword(email: email.toString(), password: password.toString());
                                if (newUser != null) {
                                  Navigator.pushNamed(context, 'landing');
                                }
                                await _firestore.collection('users')
                                    .doc(newUser.user!.uid)
                                    .set({
                                  'firstName': _firstNameController.text.trim(),
                                  'lastName': _lastNameController.text.trim(),
                                  'dob': _dobController.text.trim(),
                                  'createdAt': FieldValue.serverTimestamp(),
                                });
                              } catch (e) {
                                print(e);
                              }


                            }

                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Already have account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, 'login'),
                            child: Text(
                              "Login here",
                              style: TextStyle(
                                color: redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
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
