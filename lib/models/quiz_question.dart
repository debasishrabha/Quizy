// class QuizQuestion {
//   const QuizQuestion(this.text, this.answers);

//   final String text;
//   final List<String> answers;
//   List<String> getShuffledAnswer() {
//     final shuffledList = List.of(answers);
//     shuffledList.shuffle();
//     return shuffledList;
//   }
// } //not extend anything because there will be no widget

class QuizQuestion {
  QuizQuestion({
    required this.id,
    required this.text,
    required this.answers,
    required this.correctAnswer,
  });

  final int? id;
  final String text;
  final List<String> answers;
  final String correctAnswer;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['question_id'],
      text: json['question'],
      answers: [
        json['option1'],
        json['option2'],
        json['option3'],
        json['option4'],
      ],
      correctAnswer: json['correct_answer'],
    );
  }

  List<String> getShuffledAnswer() {
    final shuffledList = List<String>.from(answers);
    shuffledList.shuffle();
    return shuffledList;
  }
}
