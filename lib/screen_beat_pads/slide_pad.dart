import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_midi_command/flutter_midi_command_messages.dart';
import 'package:beat_pads/shared/_shared.dart';
import 'package:beat_pads/services/_services.dart';

class SlideBeatPad extends StatefulWidget {
  const SlideBeatPad({
    required this.selected,
    required this.note,
    Key? key,
  }) : super(key: key);

  final bool selected;
  final int note;
  @override
  State<SlideBeatPad> createState() => _SlideBeatPadState();
}

class _SlideBeatPadState extends State<SlideBeatPad> {
  int _triggerTime = DateTime.now().millisecondsSinceEpoch;
  bool _checkingSustain = false;
  bool _noteOn = false;

  int? lastNote;

  handlePush(
      int channel, int note, bool sendCC, int velocity, int sustainTime) {
    if (sustainTime != 0) {
      _triggerTime = DateTime.now().millisecondsSinceEpoch;
    }

    NoteOnMessage(channel: channel, note: note, velocity: velocity).send();
    lastNote = widget.note;

    if (sendCC) {
      CCMessage(channel: (channel + 1) % 16, controller: note, value: 127)
          .send();
    } else {}
  }

  handleRelease(int channel, int note, bool? sendCC, int sustainTime) async {
    if (sustainTime != 0) {
      if (_checkingSustain) return;

      _checkingSustain = true;
      while (await _checkSustainTime(sustainTime, _triggerTime) == false) {}
      _checkingSustain = false;
    }
    NoteOffMessage(
      channel: channel,
      note: note,
    ).send();

    if (sendCC == true) {
      CCMessage(channel: (channel + 1) % 16, controller: note, value: 0).send();
    }
  }

  Future<bool> _checkSustainTime(int sustainTime, int triggerTime) =>
      Future.delayed(
        const Duration(milliseconds: 5),
        () => DateTime.now().millisecondsSinceEpoch - triggerTime > sustainTime,
      );

  @override
  Widget build(BuildContext context) {
    // variables from settings:
    final int rootNote = Provider.of<Settings>(context, listen: true).rootNote;
    final int sustainTime =
        Provider.of<Settings>(context, listen: true).sustainTimeExp;
    final List<int> scale =
        Provider.of<Settings>(context, listen: true).scaleList;
    final int velocity = Provider.of<Settings>(context, listen: true).velocity;
    final bool showNoteNames =
        Provider.of<Settings>(context, listen: true).showNoteNames;
    final bool sendCC = Provider.of<Settings>(context, listen: true).sendCC;

    final int channel = Provider.of<Settings>(context, listen: true).channel;

    // variables from and to  midi receiver:
    Provider.of<MidiData>(context, listen: false).channel =
        channel - 1; // update MidiData Provider with latest settings

    final int _rxNote = widget.note < 127 && widget.note >= 0
        ? Provider.of<MidiData>(context, listen: true).rxNoteBuffer[widget.note]
        : 0;

    // PAD COLOR:
    final Color _color;
    Color _splashColor = Palette.lightPink.color;

    if (widget.selected == true) {
      _color = _splashColor.withAlpha(220); // maintain color when pushed

    } else if (_rxNote > 0) {
      _color = Palette.cadetBlue.color.withAlpha(
          _rxNote * 2); // receiving midi signal adjusted by received velocity

    } else if (widget.note > 127 || widget.note < 0) {
      _color = Palette.darkGrey.color; // out of midi range

    } else if (!MidiUtils.isNoteInScale(widget.note, scale, rootNote)) {
      _color = Palette.yellowGreen.color.withAlpha(160); // not in current scale

    } else if (widget.note % 12 == rootNote) {
      _color = Palette.laserLemon.color; // root note

    } else {
      _color = Palette.yellowGreen.color; // default pad color
    }

    Color _padTextColor = Palette.darkGrey.color;

    EdgeInsets _padPadding = const EdgeInsets.all(2.5);

    Size size = MediaQuery.of(context).size;
    double _fontSize = size.width * 0.022;
    BorderRadius _padRadius =
        BorderRadius.all(Radius.circular(size.width * 0.008));

// TODO: test midi sending
    if (widget.selected && !_noteOn) {
      handlePush(channel, widget.note, sendCC, velocity, sustainTime);
      _noteOn = true;
    } else if (!widget.selected && _noteOn) {
      if (lastNote != widget.note && lastNote != null) {
        handleRelease(channel, lastNote!, sendCC, sustainTime);
        lastNote = widget.note;
      } else {
        handleRelease(channel, widget.note, sendCC, sustainTime);
      }
      _noteOn = false;
    }

    return Container(
      padding: EdgeInsets.all(size.width * 0.005),
      height: double.infinity,
      width: double.infinity,
      child: Material(
        color: _color,
        borderRadius: _padRadius,
        elevation: 5,
        shadowColor: Colors.black,
        child: widget.note > 127 || widget.note < 0
            ?
            // OUT OF MIDI RANGE
            InkWell(
                onTapDown: (_) {},
                borderRadius: _padRadius,
                child: Padding(
                  padding: _padPadding,
                  child: Text(
                    "#${widget.note}",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                      fontSize: _fontSize * 0.8,
                    ),
                  ),
                ),
              )
            :
            // WITHIN MIDI RANGE
            InkWell(
                onTapDown: (_) {},
                borderRadius: _padRadius,
                splashColor: _splashColor,
                child: Padding(
                  padding: _padPadding,
                  child: Text(
                      showNoteNames
                          ? MidiUtils.getNoteName(widget.note,
                              showNoteValue: false)
                          : widget.note.toString(),
                      style: TextStyle(
                        color: _padTextColor,
                        fontSize: _fontSize,
                      )),
                ),
              ),
      ),
    );
  }
}