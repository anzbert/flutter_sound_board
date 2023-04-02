import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final presetNotifierProvider = NotifierProvider<PresetNotfier, int>(() {
  return PresetNotfier();
});

class PresetNotfier extends Notifier<int> {
  static const int number = 5;

  @override
  int build() {
    return 1;
  }

  /// Set to a Preset between 1 and 5
  void set(int newPreset) {
    ref.read(senderProvider.notifier).playModeHandler.killAllNotes();
    state = newPreset.clamp(1, number);
  }
}
