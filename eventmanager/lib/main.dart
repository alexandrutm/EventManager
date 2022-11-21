import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

void main() {
  runApp(const EventManager());
}

class EventManager extends StatelessWidget {
  const EventManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnBoardingScreen(),
    );
  }
}
