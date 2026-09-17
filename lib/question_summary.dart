import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionSummary extends StatelessWidget {
  QuestionSummary(this.summaryData, {super.key});

  final List<Map<String, Object>> summaryData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: SingleChildScrollView(
        child: Column(
          children: summaryData.map((data) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: SizedBox(
                  width: 420, // Change this to whatever looks good
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 30,
                        child: Text('${(data['question_index'] as int) + 1}.'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['question'] as String,
                            ), //argument type int can't be used in string
                            const SizedBox(height: 5),
                            Text(
                              style: GoogleFonts.lato(
                                color: const Color.fromARGB(255, 255, 255, 255),

                                fontWeight: FontWeight.bold,
                              ),
                              data['user_answer'] as String,
                            ),
                            Text(
                              style: GoogleFonts.lato(
                                color: const Color.fromARGB(255, 133, 1, 1),

                                fontWeight: FontWeight.bold,
                              ),
                              data['correct_answer'] as String,
                            ), //here we also use type casting as know object can be any value//this tends question is stored under the key
                          ], // it is a horizontal equivalent to column widget
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(), //iterable can to convert into list
        ),
      ),
    ); //As we know children want widget but we have summary data as a map list so we have to convert the map into widget using map() function
  }
}
