import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/text_field_input.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final emailController = TextEditingController();

  void resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      // showDialog(
      //   context: context,
      //   builder: (context) {
      //     return AlertDialog(
      //       content: Text('Password reset link sent! Check your email'),
      //     );
      //   },
      //);
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 200),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Enter your email address and we will send you a password reset link',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[900], fontSize: 20),
            ),
          ),
          const SizedBox(height: 20),

          // email textfield
          TextFieldInput(
            textInputType: TextInputType.emailAddress,
            textEditingController: emailController,
            hintText: 'Email',
            obscureText: false,
          ),
          const SizedBox(height: 10),

          // sign in button
          MyButton(
            text: "Reset Password",
            onTap: resetPassword,
            isLoading: false,
          ),
        ],
      ),
    );
  }
}
