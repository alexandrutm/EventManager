import 'package:eventmanager/utils/colors.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final bool isLoading;

  const MyButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: CustomTheme.bkgGradientStart,
              offset: Offset(1.0, 6.0),
              blurRadius: 20.0,
            ),
            BoxShadow(
              color: CustomTheme.bkgGradientEnd,
              offset: Offset(1.0, 6.0),
              blurRadius: 20.0,
            ),
          ],
          gradient: LinearGradient(
              colors: <Color>[
                CustomTheme.bkgGradientStart,
                CustomTheme.bkgGradientStart
              ],
              begin: FractionalOffset(0.2, 0.2),
              end: FractionalOffset(1.0, 1.0),
              stops: <double>[0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: !isLoading
              ? Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )
              : const CircularProgressIndicator(
                  color: primaryColorBlack,
                ),
        ),
      ),
    );
  }
}
