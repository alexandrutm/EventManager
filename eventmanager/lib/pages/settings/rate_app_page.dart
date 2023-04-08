import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class RateApp extends StatefulWidget {
  const RateApp({Key? key}) : super(key: key);

  @override
  State<RateApp> createState() {
    return _RateAppState();
  }
}

class _RateAppState extends State<RateApp> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  double progress = 1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _animationController.value = 1;
    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: 1.7,
                    child: Lottie.asset('assets/RateAppEmoji.json',
                        width: double.infinity,
                        fit: BoxFit.cover,
                        controller: _animationController,
                        onLoaded: (composition) {
                      _animationController.duration = composition.duration;
                    }),
                  ),
                  Text(
                    'How was your experience',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        letterSpacing: -2,
                        fontSize: 36,
                        fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 0),
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6, disabledThumbRadius: 6)),
                    child: Slider(
                        value: progress,
                        activeColor: Colors.black,
                        onChanged: (val) {
                          setState(() {
                            progress = val;
                            _animationController.value = 0.5 + (val / 2);
                          });
                        }),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(99)),
                      child: Text('Send',
                          style: GoogleFonts.inter(
                              fontSize: 16, fontWeight: FontWeight.w700)))
                ])));
  }
}
