import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final touchReleaseBuffer =
    NotifierProvider.autoDispose<_TouchReleaseBuffer, List<TouchEvent>>(
  _TouchReleaseBuffer.new,
);

/// Data Structure that holds released Touch Events
class _TouchReleaseBuffer extends TouchBufferBase {
  bool _checkerRunning = false;

  @override
  List<TouchEvent> build() => [];

  /// Releases a Channel for re-use (only when in MPE mode)
  void releaseChannelIfMpeMode(int channel) {
    if (ref.read(senderProvider) is PlayModeMPE) {
      (ref.read(senderProvider) as PlayModeMPE).releaseMPEChannel(channel);
    }
  }

  /// Check if any of the [TouchEvent]s currently contain an active note
  bool get _hasActiveNotes =>
      state.any((element) => element.noteEvent.noteOnMessage != null);

  /// Update note in the released events buffer, by adding it or updating
  /// the timer of the corresponding note
  Future<void> updateReleasedEvent(TouchEvent event) async {
    final index = state.indexWhere(
      (element) => element.noteEvent.note == event.noteEvent.note,
    );

    if (index >= 0) {
      state[index].noteEvent.updateReleaseTime(); // update time
      releaseChannelIfMpeMode(state[index].noteEvent.channel);

      state[index].noteEvent.channel = event.noteEvent.channel;
      state = [...state];
    } else {
      event.noteEvent.updateReleaseTime();
      state = [...state, event];
    }
    if (state.isNotEmpty) await _checkReleasedEvents();
  }

  Future<void> _checkReleasedEvents() async {
    if (_checkerRunning) return; // only one running instance possible!
    _checkerRunning = true;

    while (_hasActiveNotes) {
      await Future.delayed(
        const Duration(milliseconds: 5),
        () {
          for (var i = 0; i < state.length; i++) {
            if (DateTime.now().millisecondsSinceEpoch -
                    state[i].noteEvent.releaseTime >
                ref.read(noteReleaseUsable)) {
              state[i].noteEvent.noteOff(); // note OFF

              releaseChannelIfMpeMode(state[i].noteEvent.channel);

              // mark to remove from buffer
              state[i].markKillIfNoteOffAndNoAnimation();
              state = [...state];
            }
          }
          killAllMarkedReleasedTouchEvents();
        },
      );
    }
    _checkerRunning = false;
  }

  /// Removes a Note by its midi value from this buffer
  void removeNoteFromReleaseBuffer(int note) {
    for (final element in state) {
      if (element.noteEvent.note == note) {
        releaseChannelIfMpeMode(element.noteEvent.channel);
      }
    }
    if (state.any((element) => element.noteEvent.note == note)) {
      state = state.where((element) => element.noteEvent.note != note).toList();
    }
  }

  /// Remove all [TouchEvent]s that have been marked to be discarded
  /// from the buffer
  void killAllMarkedReleasedTouchEvents() {
    if (state.any((element) => element.kill)) {
      state = state.where((element) => !element.kill).toList();
    }
  }
}
