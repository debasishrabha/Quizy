// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:quiz_app/api_config.dart';

// class ForgotPasswordVerificationScreen extends StatefulWidget {
//   const ForgotPasswordVerificationScreen({
//     super.key,
//     required this.email,
//     required this.onOtpVerified,
//   });

//   final String email;
//   final VoidCallback onOtpVerified;

//   @override
//   State<ForgotPasswordVerificationScreen> createState() =>
//       _ForgotPasswordVerificationScreenState();
// }

// class _ForgotPasswordVerificationScreenState
//     extends State<ForgotPasswordVerificationScreen> {
//   final TextEditingController otpController = TextEditingController();

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

//         widget.onOtpVerified();
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
//               const Icon(Icons.lock_reset, size: 90, color: Colors.white),

//               const SizedBox(height: 20),

//               const Text(
//                 "Verify OTP",
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),

//               const SizedBox(height: 15),

//               Text(
//                 "Enter the OTP sent to\n${widget.email}",
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

class ForgotPasswordVerificationScreen extends StatefulWidget {
  const ForgotPasswordVerificationScreen({
    super.key,
    required this.email,
    required this.onOtpVerified,
  });

  final String email;
  final VoidCallback onOtpVerified;

  @override
  State<ForgotPasswordVerificationScreen> createState() =>
      _ForgotPasswordVerificationScreenState();
}

class _ForgotPasswordVerificationScreenState
    extends State<ForgotPasswordVerificationScreen> {
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
        widget.onOtpVerified();
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
                const Icon(Icons.lock_reset, size: 90, color: Colors.white),

                const SizedBox(height: 20),

                const Text(
                  "Verify OTP",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  "Enter the OTP sent to\n${widget.email}",
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
