import 'package:firebase_core/firebase_core.dart';
import 'package:eventmanager/login_page.dart';
import 'package:flutter/material.dart';
import 'login_check.dart';
import 'onboarding_screen.dart';
import 'login_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const EventManager());
}

class EventManager extends StatelessWidget {
  const EventManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: OnBoardingScreen(),
      home: CheckLogin(),
    );
  }
}
