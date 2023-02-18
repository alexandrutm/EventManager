import 'package:eventmanager/pages/reset_password_page.dart';
import 'package:flutter/material.dart';
import 'package:eventmanager/providers/auth_methods.dart';
import 'package:eventmanager/responsive/mobile_screen_layout.dart';
import 'package:eventmanager/responsive/responsive_layout.dart';
import 'package:eventmanager/responsive/web_screen_layout.dart';
import 'package:eventmanager/pages/register_page.dart';
import 'package:eventmanager/utils/colors.dart';
import 'package:eventmanager/utils/global_variable.dart';
import 'package:eventmanager/utils/utils.dart';

import '../components/my_button.dart';
import '../components/TextFieldInput.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleSigningIn = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods.loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == 'success') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
          (route) => false);

      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      body: SafeArea(
        child: Container(
          padding: width > webScreenSize
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 5),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(flex: 2, child: Container()),

              const Text(
                'Event Manager',
                style: TextStyle(
                    fontFamily: 'Billabong',
                    color: primaryColor,
                    fontSize: 52,
                    fontWeight: FontWeight.bold),
              ),

              Flexible(flex: 1, child: Container()),

              // email textfield
              TextFieldInput(
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
                hintText: 'Email',
              ),

              const SizedBox(height: 10),

              // password textfield
              TextFieldInput(
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              // forgot password?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const ResetPasswordPage();
                            },
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: blueLinkColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

//      if (email.isNotEmpty || password.isNotEmpty) {
              MyButton(onTap: loginUser, text: "Login", isLoading: _isLoading),

              Flexible(child: Container(), flex: 1),
              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: const [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: primaryColor,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // sign in  with google button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _isGoogleSigningIn
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(fillColor),
                      )
                    : OutlinedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(fillColor),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            _isGoogleSigningIn = true;
                          });

                          String res = await AuthMethods().signInWithGoogle();

                          // if string returned is sucess, user has been created
                          if (res == "success") {
                            setState(() {
                              _isLoading = false;
                            });
                            // navigate to the home screen
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const ResponsiveLayout(
                                  mobileScreenLayout: MobileScreenLayout(),
                                  webScreenLayout: WebScreenLayout(),
                                ),
                              ),
                            );
                          } else {
                            setState(() {
                              _isLoading = false;
                            });
                            // show the error
                            showSnackBar(context, res);
                          }

                          setState(() {
                            _isGoogleSigningIn = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Image(
                                image: AssetImage("assets/google.png"),
                                height: 30,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  'Sign in with Google',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
              ),
              Flexible(child: Container(), flex: 1),
              const SizedBox(height: 25),
              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Not a member?',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    ),
                    child: const Text(
                      'Register now',
                      style: TextStyle(
                        color: blueLinkColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
