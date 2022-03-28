import 'package:flutter/material.dart';
import '../services/midi_utils.dart';

class NonLinearSlider extends StatelessWidget {
  const NonLinearSlider({
    this.label = "#Label",
    this.subtitle,
    this.resetFunction,
    required this.readValue,
    required this.setValue,
    this.actualValue,
    this.steps = 10,
    Key? key,
  }) : super(key: key);

  final int steps;
  final Function? resetFunction;
  final Function setValue;
  final int readValue;
  final String label;
  final String? subtitle;
  final String? actualValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Row(
            children: [
              Text(label),
              if (resetFunction != null)
                TextButton(
                  onPressed: () => resetFunction!(),
                  child: Text("Reset"),
                )
            ],
          ),
          subtitle: subtitle != null ? Text(subtitle!) : null,
          trailing: actualValue != null
              ? Text(actualValue!)
              : Text(readValue.toString()),
        ),
        Slider(
          min: 0,
          max: steps.toDouble(),
          value: readValue.toDouble(),
          onChanged: (value) {
            setValue(value.toInt());
          },
        ),
      ],
    );
  }
}