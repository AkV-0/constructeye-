import 'package:flutter/material.dart';

import '../services/AuthService.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late final confirmPasswordController = TextEditingController();

  bool loading = false;
  bool showPassword = false;
  bool showConfirmPassword = false;
  
  // Role Selection State
  String selectedRole = 'client';

  static const Color kDark = Color(0xFF37353E);
  static const Color kAccent = Color(0xFF715A5A);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final kCardBg = Theme.of(context).cardColor;
    final kText =
        Theme.of(context).textTheme.bodyLarge?.color ?? const Color(0xFF37353E);
    const kDark = Color(0xFF37353E);
    const kAccent = Color(0xFF715A5A);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : kDark,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 768;
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Container(
                    width: isMobile ? constraints.maxWidth - 32 : 480,
                    margin: const EdgeInsets.symmetric(vertical: 32),
                    padding: EdgeInsets.all(isMobile ? 24 : 40),
                    decoration: BoxDecoration(
                      color: kCardBg,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(
                            ((isDark ? 0.3 : 0.12) * 255).round(),
                          ),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo
                        Center(
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [kAccent, Color(0xFF8B6B6B)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.construction,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Center(
                          child: Text(
                            "Create Your Account",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : kDark,
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        Center(
                          child: Text(
                            "Join ConstructEye today",
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Email
                        _label("Email Address", kText),
                        const SizedBox(height: 8),
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: kText),
                          decoration: _inputDeco(
                            "Enter your email",
                            Icons.email_outlined,
                            isDark,
                            kAccent,
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Role Selection Dropdown
                        _label("Select Role", kText),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: selectedRole,
                          dropdownColor: kCardBg,
                          style: TextStyle(color: kText, fontSize: 16),
                          decoration: _inputDeco(
                            "Select your role",
                            Icons.badge_outlined,
                            isDark,
                            kAccent,
                          ),
                          items: const [
                            DropdownMenuItem(value: 'client', child: Text('Client')),
                            DropdownMenuItem(value: 'executive', child: Text('Executive/Engineer')),
                            // Admin accounts should only be created via Firebase Console
                          ],
                          onChanged: (value) {
                            setState(() => selectedRole = value ?? 'client');
                          },
                        ),

                        const SizedBox(height: 18),

                        // Password
                        _label("Password", kText),
                        const SizedBox(height: 8),
                        TextField(
                          controller: passwordController,
                          obscureText: !showPassword,
                          style: TextStyle(color: kText),
                          decoration: _inputDeco(
                            "Enter your password",
                            Icons.lock_outline,
                            isDark,
                            kAccent,
                            suffix: IconButton(
                              icon: Icon(
                                showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: kAccent,
                              ),
                              onPressed: () =>
                                  setState(() => showPassword = !showPassword),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Confirm Password
                        _label("Confirm Password", kText),
                        const SizedBox(height: 8),
                        TextField(
                          controller: confirmPasswordController,
                          obscureText: !showConfirmPassword,
                          style: TextStyle(color: kText),
                          decoration: _inputDeco(
                            "Confirm your password",
                            Icons.lock_outline,
                            isDark,
                            kAccent,
                            suffix: IconButton(
                              icon: Icon(
                                showConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: kAccent,
                              ),
                              onPressed: () => setState(
                                () =>
                                    showConfirmPassword = !showConfirmPassword,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Create Account button
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kAccent,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: loading ? null : _handleSignup,
                            child: loading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Text(
                                    "Create Account",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Login link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              ),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  color: kAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
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

  Future<void> _handleSignup() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      _snack("Please fill in all fields");
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      _snack("Passwords do not match", color: Colors.orange);
      return;
    }
    if (passwordController.text.length < 6) {
      _snack("Password must be at least 6 characters", color: Colors.orange);
      return;
    }
    
    setState(() => loading = true);
    
    // Passing the state variable selectedRole into the updated signUp function
    final user = await AuthService().signUp(
      emailController.text.trim(),
      passwordController.text.trim(),
      role: selectedRole,
    );
    
    setState(() => loading = false);
    if (!mounted) return;
    
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      _snack("Signup Failed", color: Colors.red);
    }
  }

  void _snack(String msg, {Color? color}) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  Widget _label(String text, Color color) => Text(
    text,
    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: color),
  );

  InputDecoration _inputDeco(
    String hint,
    IconData prefix,
    bool isDark,
    Color kAccent, {
    Widget? suffix,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: isDark ? Colors.grey[900] : const Color(0xFFF4F5F5),
      hintText: hint,
      hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
      prefixIcon: Icon(prefix, color: kAccent),
      suffixIcon: suffix,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? Colors.grey[800]! : const Color(0xFFE0E0E0),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: kAccent, width: 2),
      ),
    );
  }
}