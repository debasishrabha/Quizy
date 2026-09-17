import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({
    super.key,
    required this.onStartQuiz,
    required this.isLoading,
  });

  final VoidCallback onStartQuiz;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/quiz-logo.png',
            width: 300,
            color: const Color.fromARGB(148, 255, 255, 255),
          ),

          const SizedBox(height: 80),

          Text(
            'Learn Current Affairs📚',
            style: GoogleFonts.lato(color: Colors.white, fontSize: 24),
          ),

          const SizedBox(height: 30),

          // if(isLoading){
          //   const CircularProgressIndicator(
          //     color: Colors.white,
          //   )
          // }
          // else{
          //    OutlinedButton.icon(
          //   onPressed: onStartQuiz,
          //   style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
          //   icon: const Icon(Icons.arrow_right_alt),
          //   label: const Text("Start Quiz"),
          // ),
          // }
          if (isLoading)
            const CircularProgressIndicator(color: Colors.white)
          else
            OutlinedButton.icon(
              onPressed: onStartQuiz,
              style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
              icon: const Icon(Icons.arrow_right_alt),
              label: const Text("Start Quiz"),
            ),
        ],
      ),
    );
  }
}
