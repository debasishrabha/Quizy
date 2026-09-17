import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/models/quiz_question.dart';
import 'package:quiz_app/results_screen.dart';
import 'package:test/test.dart';

void main() {
  test('getSummaryData returns correct summary', () {
    // Arrange
    questions.add(
      QuizQuestion(
        id: 1,
        text: 'what is 2+2',
        answers: ['3', '4', '5', '6'],
        correctAnswer: '4',
      ),
    );

    final resultsScreen = ResultsScreen(
      choosenAnswers: ['4'],
      onRestart: () {},
    );

    // Act
    final result = resultsScreen.getSummaryData();

    // Assert
    expect(result[0]['question_index'], 0);
    expect(result[0]['question'], 'what is 2+2');
    expect(result[0]['correct_answer'], '4');
    expect(result[0]['user_answer'], '4');
  });
}
