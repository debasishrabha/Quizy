import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quiz_app/api_config.dart';
import 'package:quiz_app/models/quiz_question.dart';

class QuestionService {
  static Future<List<QuizQuestion>> fetchQuestions() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/news/start-quiz');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((question) => QuizQuestion.fromJson(question)).toList();
    } else {
      throw Exception(
        'Failed to load quiz. Status Code: ${response.statusCode}',
      );
    }
  }
}
