import 'package:beat_pads/services/_services.dart';
import 'package:beat_pads/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SustainButton extends StatefulWidget {
  const SustainButton({Key? key}) : super(key: key);

  @override
  State<SustainButton> createState() => _SustainButtonState();
}

class _SustainButtonState extends State<SustainButton> {
  final key = GlobalKey();
  bool sustainState = false;
  int? disposeChannel;

  bool notOnButtonRect(Offset touchPosition) {
    final RenderBox childRenderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final Size childSize = childRenderBox.size;
    final Offset childPosition = childRenderBox.localToGlobal(Offset.zero);

    return touchPosition.dx < childPosition.dx ||
        touchPosition.dx > childPosition.dx + childSize.width ||
        touchPosition.dy < childPosition.dy ||
        touchPosition.dy > childPosition.dy + childSize.height;
  }

  @override
  void dispose() {
    if (disposeChannel != null) {
      MidiUtils.sustainMessage(disposeChannel!, false);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int channel = Provider.of<Settings>(context, listen: true).channel;
    disposeChannel = channel;

    return Listener(
      onPointerDown: (_) {
        MidiUtils.sustainMessage(channel, true);
        setState(() {
          sustainState = true;
        });
      },
      onPointerUp: (touch) {
        if (!notOnButtonRect(touch.position)) {
          MidiUtils.sustainMessage(channel, false);
          if (mounted) {
            setState(() {
              sustainState = false;
            });
          }
        }
      },
      child: ElevatedButton(
        key: key,
        onPressed: () {},
        child: Text(
          'S',
          style: TextStyle(fontSize: 30),
        ),
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(20),
          primary: sustainState
              ? Palette.lightPink.color
              : Palette.yellowGreen.color,
          onPrimary: Palette.darkGrey.color,
        ),
      ),
    );
  }
}
