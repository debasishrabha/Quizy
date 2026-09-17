import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:quiz_app/quiz.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  try {
    await GoogleSignIn.instance.initialize(
      clientId:
          "1096438738821-ciba4rg8td6g63vfpin6ses5f2mligb6.apps.googleusercontent.com",
    );
  } catch (e) {
    debugPrint("GoogleSignIn already initialized: $e");
  }

  runApp(const Quiz());
}
