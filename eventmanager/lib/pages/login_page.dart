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
      body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: width > webScreenSize
                  ? EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 3)
                  : const EdgeInsets.symmetric(horizontal: 5),
              decoration: const BoxDecoration(
                gradient: backgroundGradientColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 150.0),
                    child: Text(
                      'Event Manager',
                      style: TextStyle(
                          fontFamily: 'Billabong',
                          color: primaryColorBlack,
                          fontSize: 52,
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  // email textfield
                  Padding(
                    padding: EdgeInsets.only(top: 100.0),
                    child: TextFieldInput(
                      textInputType: TextInputType.emailAddress,
                      textEditingController: _emailController,
                      hintText: 'Email',
                    ),
                  ),
                  // password textfield
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextFieldInput(
                      textInputType: TextInputType.text,
                      textEditingController: _passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),
                  ),
                  // forgot password?
                  Padding(
                    padding: const EdgeInsets.only(top: 1.0, left: 200),
                    child: TextButton(
                        onPressed: () {
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
                              decoration: TextDecoration.underline,
                              color: blueLinkColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'WorkSansMedium'),
                        )),
                  ),
                  //      if (email.isNotEmpty || password.isNotEmpty) {
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: MyButton(
                        onTap: loginUser, text: "Login", isLoading: _isLoading),
                  ),

                  // or continue with
                  Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: <Color>[
                                  Colors.white10,
                                  Colors.white,
                                ],
                                begin: FractionalOffset(0.0, 0.0),
                                end: FractionalOffset(1.0, 1.0),
                                stops: <double>[0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          width: 100.0,
                          height: 1.0,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Text(
                            'Or',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'WorkSansMedium'),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: <Color>[
                                  Colors.white,
                                  Colors.white10,
                                ],
                                begin: FractionalOffset(0.0, 0.0),
                                end: FractionalOffset(1.0, 1.0),
                                stops: <double>[0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          width: 100.0,
                          height: 1.0,
                        ),
                      ],
                    ),
                  ),
                  // sign in  with google button
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: _isGoogleSigningIn
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(fillColor),
                          )
                        : OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(fillColor),
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

                              String res =
                                  await AuthMethods().signInWithGoogle();

                              // if string returned is sucess, user has been created
                              if (res == "success") {
                                setState(() {
                                  _isLoading = false;
                                });
                                // navigate to the home screen
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ResponsiveLayout(
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
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 30),
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
                                        color: primaryColorBlack,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                  ),
                  // not a member? register now
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Not a member?',
                              style: TextStyle(
                                color: primaryColorBlack,
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
                                  decoration: TextDecoration.underline,
                                  color: blueLinkColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
