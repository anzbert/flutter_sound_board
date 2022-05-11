import 'package:beat_pads/screen_pads_menu/_screen_pads_menu.dart';

import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';

import 'package:beat_pads/services/_services.dart';

class ReturnToMenuButton extends StatelessWidget {
  const ReturnToMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    double padSpacing = width * ThemeConst.padSpacingFactor;
    double padRadius = width * ThemeConst.padRadiusFactor;
    return Padding(
      padding: EdgeInsets.fromLTRB(0, padSpacing, padSpacing, padSpacing),
      child: GestureDetector(
        onLongPress: () {
          Navigator.push(
            context,
            TransitionUtils.fade(const PadMenuScreen()),
          );
        },
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            elevation: 10,
            padding: const EdgeInsets.all(0),
            alignment: Alignment.center,
            primary: Palette.tan.color.withOpacity(0.7),
            onPrimary: Palette.darkGrey.color.withOpacity(0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(padRadius),
            ),
          ),
          child: Tooltip(
            decoration: BoxDecoration(
                color: Palette.cadetBlue.color.withOpacity(0.7),
                borderRadius: BorderRadius.circular(3)),
            message: "Long-Press for Menu",
            triggerMode: TooltipTriggerMode.tap,
            showDuration: const Duration(milliseconds: 1000),
            padding: const EdgeInsets.all(5),
            child: const FittedBox(
              fit: BoxFit.contain,
              child: Icon(
                Icons.menu_rounded,
                size: 100,
              ),
            ),
          ),
        ),
      ),
    );
  }
}