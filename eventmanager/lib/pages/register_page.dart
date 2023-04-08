import 'package:eventmanager/components/text_field_input.dart';
import 'package:eventmanager/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eventmanager/providers/auth_methods.dart';
import 'package:eventmanager/responsive/mobile_screen_layout.dart';
import 'package:eventmanager/responsive/responsive_layout.dart';
import 'package:eventmanager/responsive/web_screen_layout.dart';
import 'package:eventmanager/pages/login_page.dart';
import 'package:eventmanager/utils/colors.dart';
import 'package:eventmanager/utils/global_variable.dart';
import 'package:eventmanager/utils/utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() {
    return _SignupScreenState();
  }
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    _image ??= (await rootBundle.load('assets/noImage_thumbnail.png'))
        .buffer
        .asUint8List();

    // signup user using our authmethodds
    String res = await AuthMethods().registerUser(
        email: _emailController.text,
        password: _passwordController.text,
        firstname: _firstnameController.text,
        lastname: _lastnameController.text,
        bio: "",
        file: _image!);
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      // showSnackBar(context, res);
    }
  }

  Future selectImage() async {
    try {
      Uint8List im = await pickImage(ImageSource.gallery);

      // set state because we need to display the image we selected on the circle avatar
      setState(() {
        _image = im;
      });
    } catch (err) {
      //print(err);
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
                Padding(
                  padding: const EdgeInsets.only(top: 130.0),
                  child: Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                              backgroundColor: Colors.red,
                            )
                          : const CircleAvatar(
                              radius: 64,
                              backgroundImage:
                                  AssetImage('assets/noImage_thumbnail.png'),
                              backgroundColor:
                                  Color.fromARGB(255, 163, 149, 244),
                            ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: TextFieldInput(
                    hintText: 'First name',
                    textInputType: TextInputType.text,
                    textEditingController: _firstnameController,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFieldInput(
                  hintText: 'Last name',
                  textInputType: TextInputType.text,
                  textEditingController: _lastnameController,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFieldInput(
                  hintText: 'Email',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFieldInput(
                  hintText: 'Password',
                  textInputType: TextInputType.text,
                  textEditingController: _passwordController,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                MyButton(
                    onTap: signUpUser, text: "Sign up", isLoading: _isLoading),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(
                            color: primaryColorBlack,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          ),
                          child: const Text(
                            ' Login.',
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
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
