// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:quiz_app/api_config.dart';
// import 'package:quiz_app/reset_password_screen.dart';

// enum VerificationType { signup, forgotPassword }

// class VerificationScreen extends StatefulWidget {
//   const VerificationScreen({
//     super.key,
//     required this.email,
//     required this.type,
//     required this.onVerificationSuccess,
//   });

//   final String email;
//   final VerificationType type;
//   final VoidCallback onVerificationSuccess;

//   @override
//   State<VerificationScreen> createState() => _VerificationScreenState();
// }

// class _VerificationScreenState extends State<VerificationScreen> {
//   final otpController = TextEditingController();

//   bool isLoading = false;

//   Future<void> verifyOtp() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final response = await http.post(
//         Uri.parse("${ApiConfig.baseUrl}/api/auth/verify-otp"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "email": widget.email,
//           "otp": otpController.text.trim(),
//         }),
//       );

//       final data = jsonDecode(response.body);

//       if (!mounted) return;

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(data["message"])));

//         if (widget.type == VerificationType.signup) {
//           widget.onVerificationSuccess();
//         } else {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (_) => ResetPasswordScreen(email: widget.email),
//             ),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(data["message"])));
//       }
//     } catch (e) {
//       if (!mounted) return;

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: $e")));
//     }

//     if (mounted) {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> resendOtp() async {
//     try {
//       final response = await http.post(
//         Uri.parse("${ApiConfig.baseUrl}/api/auth/resend-otp"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"email": widget.email}),
//       );

//       final data = jsonDecode(response.body);

//       if (!mounted) return;

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(data["message"])));
//     } catch (e) {
//       if (!mounted) return;

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: $e")));
//     }
//   }

//   @override
//   void dispose() {
//     otpController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: SizedBox(
//           width: 400,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(Icons.verified_user, size: 90, color: Colors.white),

//               const SizedBox(height: 20),

//               Text(
//                 widget.type == VerificationType.signup
//                     ? "Verify Your Email"
//                     : "Verify OTP",
//                 style: const TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),

//               const SizedBox(height: 15),

//               Text(
//                 widget.type == VerificationType.signup
//                     ? "Enter the verification code sent to\n${widget.email}"
//                     : "Enter the OTP sent to\n${widget.email}",
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(color: Colors.white),
//               ),

//               const SizedBox(height: 30),

//               TextField(
//                 controller: otpController,
//                 keyboardType: TextInputType.number,
//                 maxLength: 6,
//                 decoration: const InputDecoration(
//                   filled: true,
//                   fillColor: Colors.white,
//                   labelText: "OTP",
//                   border: OutlineInputBorder(),
//                 ),
//               ),

//               const SizedBox(height: 20),

//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: isLoading ? null : verifyOtp,
//                   child: isLoading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text("Verify"),
//                 ),
//               ),

//               TextButton(
//                 onPressed: resendOtp,
//                 child: const Text(
//                   "Resend Code",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/api_config.dart';
import 'package:quiz_app/reset_password_screen.dart';

enum VerificationType { signup, forgotPassword }

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({
    super.key,
    required this.email,
    required this.type,
    required this.onVerificationSuccess,
  });

  final String email;
  final VerificationType type;
  final VoidCallback onVerificationSuccess;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController otpController = TextEditingController();

  bool isLoading = false;

  Future<void> verifyOtp() async {
    if (otpController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter OTP")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/api/auth/verify-otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.email,
          "otp": otpController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(data["message"])));

      if (response.statusCode == 200) {
        if (widget.type == VerificationType.signup) {
          widget.onVerificationSuccess();
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ResetPasswordScreen(email: widget.email),
            ),
          );
        }
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

  Future<void> resendOtp() async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/api/auth/resend-otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": widget.email}),
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(data["message"])));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_user, size: 90, color: Colors.white),

                const SizedBox(height: 20),

                Text(
                  widget.type == VerificationType.signup
                      ? "Verify Your Email"
                      : "Verify OTP",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  widget.type == VerificationType.signup
                      ? "Enter the verification code sent to\n${widget.email}"
                      : "Enter the OTP sent to\n${widget.email}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),

                const SizedBox(height: 30),

                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "OTP",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : verifyOtp,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Verify"),
                  ),
                ),

                TextButton(
                  onPressed: resendOtp,
                  child: const Text(
                    "Resend Code",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
