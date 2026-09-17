import 'package:flutter/material.dart';
import 'package:quiz_app/answer_button.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key, required this.onSelectAnswer});
  final void Function(String answer) onSelectAnswer;

  @override
  State<QuestionScreen> createState() {
    return _QuestionScreenState();
  }
}

class _QuestionScreenState extends State<QuestionScreen> {
  var currentQuestionIndex = 0;
  answerQuestion(String selectedAnswer) {
    widget.onSelectAnswer(selectedAnswer);
    setState(() {
      currentQuestionIndex = currentQuestionIndex + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];
    return SizedBox(
      width: double.infinity, //as much as possible
      child: Container(
        margin: const EdgeInsets.all(45),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQuestion.text,
              style: GoogleFonts.lato(
                color: const Color.fromARGB(255, 212, 200, 244),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            // AnswerButton(answerText: 'Answer', onTap: () {}), this can not be worked bacause it is defined as named parameter
            // AnswerButton(
            //   currentQuestion.answers[0],
            //   () {},
            // ), //this is positional parameter
            // SizedBox(height: 10),
            ...currentQuestion.getShuffledAnswer().map(
              (answer) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AnswerButton(answer, () {
                    answerQuestion(answer);
                  }),
                );
              },
            ), //map is used to convert string(list) into answerbutton widget, here function is used as value, the function we pass here automatically executed by dart
            // AnswerButton(currentQuestion.answers[1], () {}),
            // SizedBox(height: 10),
            // AnswerButton(currentQuestion.answers[2], () {}),
            // SizedBox(height: 10),
            // AnswerButton(currentQuestion.answers[3], () {}),
            // SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
