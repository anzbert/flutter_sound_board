import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'dart:async';

import '../services/_services.dart';

class MidiData extends ChangeNotifier {
  final List<int> rxNoteBuffer = List.filled(128, 0);

  rxNotesReset() {
    rxNoteBuffer.fillRange(0, 128, 0);
    notifyListeners();
  }

  int channel = 0;

  StreamSubscription<MidiPacket>? _rxSubscription;
  final MidiCommand _midiCommand = MidiCommand();

// constructor:
  MidiData() {
    _rxSubscription = _midiCommand.onMidiDataReceived?.listen((packet) {
      int statusByte = packet.data[0];

      // print(
      //     "${packet.data} @ ${packet.timestamp} from ${packet.device.name} / ID:${packet.device.id}");

      // If the message is NOT a command (0xFn), and NOT using the correct channel -> return:
      if (statusByte & 0xF0 != 0xF0 && statusByte & 0x0F != channel) return;

      MidiMessageType type = MidiUtils.getMidiMessageType(statusByte);

      // Data only handling noteON(9) and noteOFF(8) at the moment:
      if (type == MidiMessageType.noteOn || type == MidiMessageType.noteOff) {
        int note = packet.data[1];
        int velocity = packet.data[2];

        switch (type) {
          case MidiMessageType.noteOn:
            rxNoteBuffer[note] = velocity;
            notifyListeners();
            break;
          case MidiMessageType.noteOff:
            rxNoteBuffer[note] = 0;
            notifyListeners();
            break;
          default:
            return;
        }
      }
    });
  }

  @override
  void dispose() {
    _rxSubscription?.cancel();
    super.dispose();
  }
}