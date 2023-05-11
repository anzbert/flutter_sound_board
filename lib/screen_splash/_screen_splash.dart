import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:beat_pads/screen_pads_menu/_screen_pads_menu.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showClickToContinue = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const HSLColor.fromAHSL(1, 240, 0.1, 0.99).toColor(),
        body: Listener(
          onPointerDown: (_) async {
            await Navigator.push(
              context,
              TransitionUtils.fade(const PadMenuScreen()),
            );
          },
          child: Center(
            child: Column(
              children: [
                const Expanded(
                  flex: 8,
                  child: RiveAnimation.asset(
                    'assets/anim/doggo.riv',
                    alignment: Alignment.center,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      // AnimatedTextKit 4.2.2 broken as of flutter 3.10 with Impeller on iOS
                      // Using a placeholder static text widget in the meantime.
                      // TODO(anzio): Remove placholder when it works again after an update
                      child: Platform.isIOS
                          ? Builder(
                              builder: (context) {
                                Future<void>.delayed(
                                  const Duration(milliseconds: 2000),
                                  () => setState(
                                    () => showClickToContinue = true,
                                  ),
                                );
                                return Text(
                                  'Beat Pads',
                                  style: TextStyle(
                                    fontSize: 52,
                                    fontFamily: 'Righteous',
                                    letterSpacing: 4,
                                    fontWeight: FontWeight.bold,
                                    color: Palette.cadetBlue,
                                  ),
                                );
                              },
                            )
                          : AnimatedTextKit(
                              animatedTexts: [
                                ColorizeAnimatedText(
                                  'BeatPads',
                                  speed: const Duration(milliseconds: 250),
                                  textAlign: TextAlign.center,
                                  textStyle: const TextStyle(
                                    fontSize: 52,
                                    fontFamily: 'Righteous',
                                    letterSpacing: 4,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  colors: [
                                    Palette.cadetBlue,
                                    Palette.lightPink,
                                    Palette.darkGrey,
                                    Palette.yellowGreen,
                                  ],
                                ),
                              ],
                              isRepeatingAnimation: false,
                              onFinished: () => setState(
                                () => showClickToContinue = true,
                              ),
                            ),
                    ),
                  ),
                ),
                Expanded(
                  child: showClickToContinue
                      ? AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: [
                            FadeAnimatedText(
                              'Tap To Continue',
                              duration: const Duration(milliseconds: 1400),
                              textStyle: const TextStyle(color: Colors.black),
                            ),
                          ],
                        )
                      : const Text(''),
                ),
              ],
            ),
          ),
        ),
      );
}
