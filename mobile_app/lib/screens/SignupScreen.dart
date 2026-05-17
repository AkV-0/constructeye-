import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F5),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),

                child: Center(
                  child: Container(
                    width: 430,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    padding: const EdgeInsets.all(24),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        const Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF37353E),
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "Sign up to get started",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),

                        const SizedBox(height: 24),

                        buildLabel("Full Name"),

                        buildTextField(
                          controller: nameController,
                          hint: "Enter your name",
                          icon: Icons.person_outline,
                        ),

                        const SizedBox(height: 16),

                        buildLabel("Phone Number"),

                        buildTextField(
                          controller: phoneController,
                          hint: "+91 00000-00000",
                          icon: Icons.phone_outlined,
                        ),

                        const SizedBox(height: 16),

                        buildLabel("Email"),

                        buildTextField(
                          controller: emailController,
                          hint: "Enter your email",
                          icon: Icons.email_outlined,
                        ),

                        const SizedBox(height: 16),

                        buildLabel("Password"),

                        buildPasswordField(
                          controller: passwordController,
                          hint: "Create a password",
                        ),

                        const SizedBox(height: 16),

                        buildLabel("Confirm Password"),

                        buildPasswordField(
                          controller: confirmPasswordController,
                          hint: "Confirm your password",
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Checkbox(value: false, onChanged: (value) {}),

                            Expanded(
                              child: RichText(
                                text: const TextSpan(
                                  text: "I agree to the ",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),

                                  children: [
                                    TextSpan(
                                      text: "Terms and Conditions",
                                      style: TextStyle(
                                        color: Color(0xFF715A5A),
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

                        SizedBox(
                          width: double.infinity,
                          height: 54,

                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF715A5A),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),

                            onPressed: () async {
                              if (passwordController.text !=
                                  confirmPasswordController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Passwords do not match"),
                                  ),
                                );

                                return;
                              }

                              try {
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                    );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Account Created Successfully",
                                    ),
                                  ),
                                );

                                Navigator.pop(context);
                              } on FirebaseAuthException catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.message ?? "Signup Failed"),
                                  ),
                                );
                              }
                            },

                            child: const Text(
                              "Create Account",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(fontSize: 15),
                            ),

                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },

                              child: const Text(
                                "Sign in",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,

      child: Text(
        text,

        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),

      child: SizedBox(
        height: 52,

        child: TextField(
          controller: controller,

          decoration: InputDecoration(
            hintText: hint,

            prefixIcon: Icon(icon),

            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
    );
  }

  Widget buildPasswordField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),

      child: SizedBox(
        height: 52,

        child: TextField(
          controller: controller,
          obscureText: true,

          decoration: InputDecoration(
            hintText: hint,

            prefixIcon: const Icon(Icons.lock_outline),

            suffixIcon: const Icon(Icons.visibility_outlined),

            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
    );
  }
}
