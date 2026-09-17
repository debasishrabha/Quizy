import 'package:flutter/material.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/question_summary.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({
    super.key,
    required this.choosenAnswers,
    required this.onRestart,
  });
  final List<String> choosenAnswers;
  final VoidCallback onRestart;

  List<Map<String, Object>> getSummaryData() {
    final List<Map<String, Object>> summary =
        []; // this is the type of the summary

    for (var i = 0; i < choosenAnswers.length; i++) {
      summary.add({
        'question_index': i, // i is used here to reflect some summary data
        'question': questions[i].text,
        'correct_answer': questions[i]
            .correctAnswer, // that means for every option the first option is the list will be correct answer not from the question screen page but in the question page
        'user_answer': choosenAnswers[i],
        // colon is used to separate the value of key and values
      }); // this curlyy braches is means to introduce value, it is an dart syntex to create value
    }
    return summary;
  } //it is very simple data structure which is used to maps values, maps have key and values, string is the key here
  //and Object is the value which allow every kind of value

  @override
  Widget build(BuildContext context) {
    final summaryData = getSummaryData();
    final numToralQuestions = questions.length;
    final numCorrectQuestions = summaryData.where((data) {
      return data['user_answer'] == data['correct_answer'];
    }).length;

    return SizedBox(
      width: double.infinity, //as much as possible
      child: Container(
        margin: const EdgeInsets.all(45),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You answered $numCorrectQuestions out of $numToralQuestions question correctly',
            ),
            SizedBox(height: 30),
            QuestionSummary(summaryData),
            SizedBox(height: 30),
            TextButton(
              onPressed: onRestart,
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 43, 0, 255),
              ),
              child: const Text('Restart Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
