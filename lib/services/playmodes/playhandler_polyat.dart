import 'package:beat_pads/services/services.dart';

class PlayModePolyAT extends PlayModeHandler {
  PlayModePolyAT(super.ref) : polyATMod = ModPolyAfterTouch1D();
  final ModPolyAfterTouch1D polyATMod;

  /// Adds a poly AT message to the regular note handling
  @override
  void handleNewTouch(PadTouchAndScreenData data) {
    polyATMod.send(ref.read(channelUsableProv), data.padNote, 0);
    super.handleNewTouch(data);
  }

  /// Modify the touchposition in the touchbuffers, either moved by pan
  /// or by animation.
  /// Send Poly AT message after the pos update
  @override
  void handlePan(NullableTouchAndScreenData data) {
    TouchEvent? event;

    void modify(TouchEvent eventInBuffer) {
      eventInBuffer.updatePosition(data.screenTouchPos);
      event = eventInBuffer;
    }

    if (ref
        .read(
          touchBuffer.notifier,
        )
        .modifyEvent(data.pointer, modify)) {
    } else if (ref
        .read(
          touchReleaseBuffer.notifier,
        )
        .modifyEvent(data.pointer, modify)) {
    } else {
      return;
    }

    if (event != null) {
      polyATMod.send(
        ref.read(channelUsableProv),
        event!.noteEvent.note,
        event!.radialChange(),
      );
    }
  }
}
