// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:quiz_app/verification_screen.dart';
// import 'package:quiz_app/api_config.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({
//     super.key,
//     required this.onLoginSuccess,
//     required this.onForgotPassword,
//     required this.onSignupPressed,
//   });

//   final VoidCallback onLoginSuccess;
//   final VoidCallback onForgotPassword;
//   final VoidCallback onSignupPressed;

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   bool hidePassword = true;

//   // void login() {
//   //   // Skip login validation for now
//   //   widget.onLoginSuccess();
//   // }

//   final GoogleSignIn googleSignIn = GoogleSignIn.instance;

//   Future<void> signInWithGoogle() async {
//     try {
//       // Must initialize before first use (ideally do this once in main.dart instead)
//       // await googleSignIn.initialize();

//       final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

//       final GoogleSignInAuthentication googleAuth = googleUser.authentication;

//       final credential = GoogleAuthProvider.credential(
//         idToken: googleAuth.idToken,
//         // accessToken is no longer provided by GoogleSignInAuthentication in v7 —
//         // Firebase only needs idToken for this flow
//       );

//       final userCredential = await FirebaseAuth.instance.signInWithCredential(
//         credential,
//       );

//       final idToken = await userCredential.user!.getIdToken();

//       final response = await http.post(
//         Uri.parse("${ApiConfig.baseUrl}/api/auth/google-login"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"idToken": idToken}),
//       );

//       final data = jsonDecode(response.body);

//       if (!mounted) return;

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(data["message"])));
//         widget.onLoginSuccess();
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
//   }

//   Future<void> login() async {
//     final email = emailController.text.trim();
//     final password = passwordController.text;

//     if (email.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter email and password")),
//       );
//       return;
//     }

//     try {
//       final response = await http.post(
//         Uri.parse("${ApiConfig.baseUrl}/api/auth/login"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"email": email, "password": password}),
//       );

//       final data = jsonDecode(response.body);

//       if (!mounted) return;

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(data["message"])));

//         widget.onLoginSuccess();
//       } else if (response.statusCode == 403) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => VerificationScreen(
//               email: email,
//               type: VerificationType.signup,
//               onVerificationSuccess: () {
//                 Navigator.pop(context); // Close verification screen
//                 widget.onLoginSuccess(); // Or navigate to login/start screen
//               },
//             ),
//           ),
//         );
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
//   }

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
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
//               const Icon(Icons.quiz, size: 90, color: Colors.white),

//               const SizedBox(height: 20),

//               const Text(
//                 "Quiz App",
//                 style: TextStyle(
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),

//               const SizedBox(height: 40),

//               TextField(
//                 controller: emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: const InputDecoration(
//                   filled: true,
//                   fillColor: Colors.white,
//                   labelText: "Email",
//                   prefixIcon: Icon(Icons.email),
//                   border: OutlineInputBorder(),
//                 ),
//               ),

//               const SizedBox(height: 20),

//               TextField(
//                 controller: passwordController,
//                 obscureText: hidePassword,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.white,
//                   labelText: "Password",
//                   prefixIcon: const Icon(Icons.lock),
//                   border: const OutlineInputBorder(),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       hidePassword ? Icons.visibility_off : Icons.visibility,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         hidePassword = !hidePassword;
//                       });
//                     },
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 30),

//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: login,
//                   child: const Text("Login", style: TextStyle(fontSize: 18)),
//                 ),
//               ),

//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                   onPressed: widget.onForgotPassword,
//                   child: const Text(
//                     "Forgot Password?",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 20),

//               const Row(
//                 children: [
//                   Expanded(child: Divider(color: Colors.white)),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 10),
//                     child: Text("OR", style: TextStyle(color: Colors.white)),
//                   ),
//                   Expanded(child: Divider(color: Colors.white)),
//                 ],
//               ),

//               const SizedBox(height: 20),

//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: OutlinedButton.icon(
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: Colors.white,
//                   ),
//                   onPressed: () async {
//                     await signInWithGoogle(); //this part is google sign in option
//                   },
//                   icon: const Icon(Icons.login),
//                   label: const Text("Continue with Google"),
//                 ),
//               ),

//               const SizedBox(height: 20),

//               TextButton(
//                 onPressed: widget.onSignupPressed,
//                 child: const Text(
//                   "Don't have an account? Sign Up",
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
import 'package:quiz_app/verification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.onLoginSuccess,
    required this.onForgotPassword,
    required this.onSignupPressed,
  });

  final VoidCallback onLoginSuccess;
  final VoidCallback onForgotPassword;
  final VoidCallback onSignupPressed;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;

  final GoogleSignIn googleSignIn = GoogleSignIn.instance;

  // ------------------------------------------------------------
  // GOOGLE LOGIN
  // ------------------------------------------------------------

  Future<void> signInWithGoogle() async {
    try {
      print("========== GOOGLE LOGIN START ==========");

      // 1. Initialize Google Sign-In
      print("1. Initializing Google Sign-In...");

      await googleSignIn.initialize();

      print("2. Google Sign-In initialized");

      // 2. Open Google account selector
      print("3. Opening Google account selector...");

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      print("4. Google account received");
      print("Google email: ${googleUser.email}");

      // 3. Get Google authentication information
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      print("5. Google authentication received");
      print("Google ID token exists: ${googleAuth.idToken != null}");

      if (googleAuth.idToken == null) {
        throw Exception("Google ID token is null");
      }

      // 4. Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      print("6. Firebase credential created");

      // 5. Sign in to Firebase
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      print("7. Firebase authentication successful");
      print("Firebase UID: ${userCredential.user?.uid}");
      print("Firebase email: ${userCredential.user?.email}");

      // 6. Get Firebase ID token
      final idToken = await userCredential.user!.getIdToken();

      print("8. Firebase ID token received");
      print("Firebase token exists: ${idToken != null}");

      if (idToken == null) {
        throw Exception("Firebase ID token is null");
      }

      // 7. Call your backend
      final backendUrl = "${ApiConfig.baseUrl}/api/auth/google-login";

      print("9. Calling backend...");
      print("Backend URL: $backendUrl");

      final response = await http
          .post(
            Uri.parse(backendUrl),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"idToken": idToken}),
          )
          .timeout(const Duration(seconds: 15));

      // 8. Backend response
      print("10. Backend response received");
      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (!mounted) return;

      Map<String, dynamic> data;

      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = {
          "message": response.body.isNotEmpty
              ? response.body
              : "Invalid response from server",
        };
      }

      // 9. Login successful
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Google login successful")),
        );

        print("11. LOGIN SUCCESS");
        print("========== GOOGLE LOGIN END ==========");

        widget.onLoginSuccess();
      } else {
        // Backend rejected login
        print("11. BACKEND LOGIN FAILED");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Google login failed")),
        );
      }
    } on GoogleSignInException catch (e, stackTrace) {
      print("========== GOOGLE SIGN-IN ERROR ==========");
      print("Error: $e");
      print("Code: ${e.code}");
      print("Description: ${e.description}");
      print(stackTrace);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Google Sign-In failed: ${e.description ?? e.code}"),
        ),
      );
    } on FirebaseAuthException catch (e, stackTrace) {
      print("========== FIREBASE AUTH ERROR ==========");
      print("Code: ${e.code}");
      print("Message: ${e.message}");
      print(stackTrace);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Firebase login failed: ${e.message ?? e.code}"),
        ),
      );
    } on http.ClientException catch (e, stackTrace) {
      print("========== HTTP ERROR ==========");
      print("Error: $e");
      print(stackTrace);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not connect to the server")),
      );
    } catch (e, stackTrace) {
      print("========== GOOGLE LOGIN ERROR ==========");
      print("Error: $e");
      print(stackTrace);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // ------------------------------------------------------------
  // EMAIL / PASSWORD LOGIN
  // ------------------------------------------------------------

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/api/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      print("EMAIL LOGIN STATUS: ${response.statusCode}");
      print("EMAIL LOGIN BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(data["message"])));

        widget.onLoginSuccess();
      } else if (response.statusCode == 403) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerificationScreen(
              email: email,
              type: VerificationType.signup,
              onVerificationSuccess: () {
                Navigator.pop(context);
                widget.onLoginSuccess();
              },
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Login failed")),
        );
      }
    } catch (e) {
      print("EMAIL LOGIN ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // ------------------------------------------------------------
  // DISPOSE
  // ------------------------------------------------------------

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.quiz, size: 90, color: Colors.white),

              const SizedBox(height: 20),

              const Text(
                "Quiz App",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 40),

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

              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: login,
                  child: const Text("Login", style: TextStyle(fontSize: 18)),
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: widget.onForgotPassword,
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.white)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("OR", style: TextStyle(color: Colors.white)),
                  ),
                  Expanded(child: Divider(color: Colors.white)),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  onPressed: signInWithGoogle,
                  icon: const Icon(Icons.login),
                  label: const Text("Continue with Google"),
                ),
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: widget.onSignupPressed,
                child: const Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
