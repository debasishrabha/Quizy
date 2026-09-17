// import 'package:flutter/material.dart';

// class ForgotPasswordScreen extends StatefulWidget {
//   const ForgotPasswordScreen({super.key});

//   @override
//   State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   final TextEditingController emailController = TextEditingController();

//   bool isLoading = false;

//   Future<void> sendResetLink() async {
//     setState(() {
//       isLoading = true;
//     });

//     // TODOCall your backend API here

//     await Future.delayed(const Duration(seconds: 2));

//     setState(() {
//       isLoading = false;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Reset link sent successfully")),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Forgot Password")),

//       body: Padding(
//         padding: const EdgeInsets.all(20),

//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,

//           children: [
//             const SizedBox(height: 20),

//             const Icon(Icons.lock_reset, size: 80),

//             const SizedBox(height: 20),

//             const Text(
//               "Forgot Password?",
//               style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 10),

//             const Text(
//               "Enter your registered email address and we'll send you a password reset link.",
//             ),

//             const SizedBox(height: 30),

//             TextField(
//               controller: emailController,
//               keyboardType: TextInputType.emailAddress,
//               decoration: const InputDecoration(
//                 labelText: "Email",
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.email),
//               ),
//             ),

//             const SizedBox(height: 30),

//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: isLoading ? null : sendResetLink,

//                 child: isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text("Send Reset Link"),
//               ),
//             ),

//             const SizedBox(height: 20),

//             Center(
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: const Text("Back to Login"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz_app/api_config.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    super.key,
    required this.onBackToLogin,
    required this.onResetLinkSent,
  });

  final VoidCallback onBackToLogin;
  final void Function(String email) onResetLinkSent;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  bool isLoading = false;

  Future<void> sendResetLink() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter your email")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/api/auth/forgot-password"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200) {
        widget.onResetLinkSent(email); // CHANGED: tell Quiz to switch screens
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(data["message"])));
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(Icons.lock_reset, size: 80, color: Colors.white),
              ),

              const SizedBox(height: 30),

              const Text(
                "Forgot Password?",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Enter your registered email address and we'll send you a password reset link.",
                style: TextStyle(color: Colors.white),
              ),

              const SizedBox(height: 30),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : sendResetLink,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Send Reset Link"),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: widget.onBackToLogin,
                  child: const Text(
                    "Back to Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
