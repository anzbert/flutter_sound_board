import 'package:beat_pads/screen_beat_pads/pads_and_controls.dart';
import 'package:beat_pads/screen_midi_devices/_drawer_devices.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

class BeatPadsScreen extends StatelessWidget {
  BeatPadsScreen() {
    DeviceUtils.landscapeOnly();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BeatPadsAndControls(
          preview: false,
        ),
      ),
      drawer: Drawer(
        child: MidiConfig(),
      ),
    );
  }
}
