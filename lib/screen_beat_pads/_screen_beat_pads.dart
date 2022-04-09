import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:beat_pads/screen_home/_screen_home.dart';

import 'package:beat_pads/screen_beat_pads/button_lock_screen.dart';
import 'package:beat_pads/screen_beat_pads/buttons_octave.dart';
import 'package:beat_pads/screen_beat_pads/pads.dart';
import 'package:beat_pads/screen_beat_pads/slider_pitch_bend.dart';

class BeatPadsScreen extends StatelessWidget {
  const BeatPadsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;

    return Consumer<Settings>(
      builder: (context, settings, child) {
        return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          floatingActionButton:
              settings.lockScreenButton ? LockScreenButton() : null,
          body: SafeArea(
            child: Row(
              children: [
                // OCTAVE BUTTONS
                if (settings.octaveButtons) OctaveButtons(),

                // PITCH BEND
                if (settings.pitchBend) PitchBender(),

                // PADS
                Expanded(flex: 1, child: VariablePads())
              ],
            ),
          ),
        );
      },
    );
  }
}
