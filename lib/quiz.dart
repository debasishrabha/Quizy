import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/login_screen.dart';
import 'package:quiz_app/ForgotPasswordScreen.dart';
import 'package:quiz_app/verification_screen.dart';
import 'package:quiz_app/question_screen.dart';
import 'package:quiz_app/results_screen.dart';
import 'package:quiz_app/start_screen.dart';
import 'package:quiz_app/signup_page.dart';
import 'package:quiz_app/verification_resend_password.dart';
import 'package:quiz_app/reset_password_screen.dart';
import 'package:quiz_app/profile_screen.dart';
import 'package:quiz_app/services/question_service.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  // ------------------------------------------------------------
  // STATE
  // ------------------------------------------------------------

  final List<String> selectedAnswer = [];

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  String activeScreen = 'login_screen';

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      userEmail = user.email ?? '';
      activeScreen = 'start_screen';
    }
  }

  // Used by VerificationScreen
  String userEmail = "";
  String userId = "";

  // Controls the profile side panel
  bool showProfile = false;

  bool isLoading = false;

  // ------------------------------------------------------------
  // APP BAR
  // ------------------------------------------------------------

  bool _showAppBar() {
    return activeScreen == 'start_screen' ||
        activeScreen == 'questions_screen' ||
        activeScreen == 'results_screen';
  }

  // ------------------------------------------------------------
  // LOGIN SUCCESS
  // ------------------------------------------------------------

  void loginSuccess() {
    if (!mounted) return;

    setState(() {
      activeScreen = 'start_screen';
    });
  }

  // ------------------------------------------------------------
  // START QUIZ
  // ------------------------------------------------------------

  Future<void> switchScreen() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    try {
      print("Fetching quiz questions...");

      final fetchedQuestions = await QuestionService.fetchQuestions();

      print("Questions fetched successfully: ${fetchedQuestions.length}");

      if (!mounted) return;

      questions.clear();
      questions.addAll(fetchedQuestions);

      setState(() {
        selectedAnswer.clear();
        isLoading = false;
        activeScreen = 'questions_screen';
      });

      print("Quiz screen opened successfully.");
    } catch (e) {
      print("Failed to load quiz: $e");

      if (!mounted) return;
      setState(() {
        isLoading = false;
      });

      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text("Failed to load quiz: $e")),
      );
    }
  }

  // ------------------------------------------------------------
  // SELECT ANSWER
  // ------------------------------------------------------------

  void chooseAnswer(String answer) {
    if (!mounted) return;

    selectedAnswer.add(answer);

    if (selectedAnswer.length == questions.length) {
      setState(() {
        activeScreen = 'results_screen';
      });
    }
  }

  // ------------------------------------------------------------
  // RESTART QUIZ
  // ------------------------------------------------------------

  void restartQuiz() {
    if (!mounted) return;

    setState(() {
      selectedAnswer.clear();
      questions.clear();
      activeScreen = 'start_screen';
    });
  }

  // ------------------------------------------------------------
  // OPEN PROFILE
  // ------------------------------------------------------------

  void openProfile() {
    setState(() {
      showProfile = true;
    });
  }

  // ------------------------------------------------------------
  // CLOSE PROFILE
  // ------------------------------------------------------------

  void closeProfile() {
    setState(() {
      showProfile = false;
    });
  }

  // ------------------------------------------------------------
  // LOGOUT
  // ------------------------------------------------------------

  void logout() {
    setState(() {
      selectedAnswer.clear();
      questions.clear();
      userEmail = "";
      userId = "";
      showProfile = false;
      activeScreen = 'login_screen';
    });
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    Widget screenWidget;

    switch (activeScreen) {
      // --------------------------------------------------------
      // LOGIN
      // --------------------------------------------------------

      case 'login_screen':
        screenWidget = LoginScreen(
          onLoginSuccess: loginSuccess,

          onForgotPassword: () {
            setState(() {
              activeScreen = 'forgot_password_screen';
            });
          },

          onSignupPressed: () {
            setState(() {
              activeScreen = 'signup_screen';
            });
          },
        );
        break;

      // --------------------------------------------------------
      // FORGOT PASSWORD
      // --------------------------------------------------------

      case 'forgot_password_screen':
        screenWidget = ForgotPasswordScreen(
          onBackToLogin: () {
            setState(() {
              activeScreen = 'login_screen';
            });
          },

          onResetLinkSent: (email) {
            setState(() {
              userEmail = email;
              activeScreen = 'forgot_password_verification_screen';
            });
          },
        );
        break;

      // --------------------------------------------------------
      // SIGN UP
      // --------------------------------------------------------

      case 'signup_screen':
        screenWidget = SignupScreen(
          onSignupSuccess: (email) {
            setState(() {
              userEmail = email;
              activeScreen = 'verification_screen';
            });
          },

          onLoginPressed: () {
            setState(() {
              activeScreen = 'login_screen';
            });
          },
        );
        break;

      // --------------------------------------------------------
      // RESET PASSWORD
      // --------------------------------------------------------

      case 'reset_password_screen':
        screenWidget = ResetPasswordScreen(email: userEmail);
        break;

      // --------------------------------------------------------
      // SIGN UP VERIFICATION
      // --------------------------------------------------------

      case 'verification_screen':
        screenWidget = VerificationScreen(
          email: userEmail,
          type: VerificationType.signup,

          onVerificationSuccess: () {
            setState(() {
              activeScreen = 'start_screen';
            });
          },
        );
        break;

      // --------------------------------------------------------
      // FORGOT PASSWORD VERIFICATION
      // --------------------------------------------------------

      case 'forgot_password_verification_screen':
        screenWidget = ForgotPasswordVerificationScreen(
          email: userEmail,

          onOtpVerified: () {
            setState(() {
              activeScreen = 'reset_password_screen';
            });
          },
        );
        break;

      // --------------------------------------------------------
      // START SCREEN
      // --------------------------------------------------------

      case 'start_screen':
        screenWidget = StartScreen(
          onStartQuiz: switchScreen,
          isLoading: isLoading,
        );
        break;

      // --------------------------------------------------------
      // QUESTIONS
      // --------------------------------------------------------

      case 'questions_screen':
        screenWidget = QuestionScreen(onSelectAnswer: chooseAnswer);
        break;

      // --------------------------------------------------------
      // RESULTS
      // --------------------------------------------------------

      case 'results_screen':
        screenWidget = ResultsScreen(
          choosenAnswers: selectedAnswer,
          onRestart: restartQuiz,
        );
        break;

      // --------------------------------------------------------
      // DEFAULT
      // --------------------------------------------------------

      default:
        screenWidget = LoginScreen(
          onLoginSuccess: loginSuccess,

          onForgotPassword: () {
            setState(() {
              activeScreen = 'forgot_password_screen';
            });
          },

          onSignupPressed: () {
            setState(() {
              activeScreen = 'signup_screen';
            });
          },
        );
    }

    // ----------------------------------------------------------
    // MATERIAL APP
    // ----------------------------------------------------------

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Stack(
        children: [
          // ====================================================
          // MAIN QUIZY APP
          // ====================================================
          Scaffold(
            key: _scaffoldMessengerKey,

            extendBodyBehindAppBar: true,

            // ------------------------------------------------
            // APP BAR
            // ------------------------------------------------
            appBar: _showAppBar()
                ? AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    surfaceTintColor: Colors.transparent,

                    title: const Text(
                      "Quizy",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    actions: [
                      IconButton(
                        icon: const Icon(Icons.person, color: Colors.white),

                        onPressed: openProfile,
                      ),
                    ],
                  )
                : null,

            // ------------------------------------------------
            // BODY
            // ------------------------------------------------
            body: Container(
              width: double.infinity,

              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 226, 201, 255),
                    Color.fromARGB(255, 33, 15, 168),
                  ],

                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),

              child: screenWidget,
            ),
          ),

          // ====================================================
          // PROFILE SIDE PANEL
          // ====================================================
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),

            curve: Curves.easeInOut,

            right: showProfile ? 0 : -350,

            top: 0,

            bottom: 0,

            width: 350,

            child: ProfileScreen(
              email: FirebaseAuth.instance.currentUser?.email ?? userEmail,

              onClose: closeProfile,

              onLogoutPressed: logout,
            ),
          ),
        ],
      ),
    );
  }
}
