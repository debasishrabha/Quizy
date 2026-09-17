import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({
    super.key,
  }); //StartScreen is a constructor here and we have to pass key to statelesswidge by using super.key such that it can recognize whether it is old or new widge and key is name argument

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/quiz-logo.png', width: 300),
          Text('Learn flutter in fun way'),
        ],
      ),
    );
  }
} //class is a blueprint used to tell the dart how this custom widge is created
