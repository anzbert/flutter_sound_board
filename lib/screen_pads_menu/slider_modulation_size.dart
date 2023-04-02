import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';

class ModSizeSliderTile extends StatefulWidget {
  const ModSizeSliderTile(
      {this.label = "#label",
      this.subtitle,
      this.min = 0,
      this.max = 1,
      required this.setValue,
      required this.readValue,
      this.resetValue,
      this.onChangeEnd,
      required this.trailing,
      Key? key})
      : super(key: key);

  final String label;
  final String? subtitle;
  final double min;
  final double max;
  final Function setValue;
  final Function? onChangeEnd;
  final double readValue;
  final Function? resetValue;
  final Widget trailing;

  @override
  State<ModSizeSliderTile> createState() => _ModSizeSliderTileState();
}

class _ModSizeSliderTileState extends State<ModSizeSliderTile> {
  bool showPreview = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Row(
                children: [
                  Text(widget.label),
                  if (widget.resetValue != null)
                    TextButton(
                      onPressed: () {
                        widget.resetValue!();
                        setState(() {
                          showPreview = true;
                        });
                        Future.delayed(const Duration(milliseconds: 800), () {
                          if (mounted) {
                            setState(() {
                              showPreview = false;
                            });
                          }
                        });
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text("Reset"),
                    )
                ],
              ),
              subtitle: widget.subtitle != null ? Text(widget.subtitle!) : null,
              trailing: widget.trailing,
            ),
            Builder(
              builder: (context) {
                double width = MediaQuery.of(context).size.width;
                return SizedBox(
                  width: width * ThemeConst.sliderWidthFactor,
                  child: Slider(
                    min: widget.min,
                    max: widget.max,
                    value: widget.readValue.clamp(widget.min, widget.max),
                    onChanged: (value) {
                      widget.setValue(value);
                    },
                    onChangeStart: (_) => setState(() {
                      showPreview = true;
                    }),
                    onChangeEnd: (_) {
                      setState(() {
                        showPreview = false;
                      });
                      if (widget.onChangeEnd != null) widget.onChangeEnd!();
                    },
                  ),
                );
              },
            ),
          ],
        ),
        if (showPreview) const PaintModPreview(),
      ],
    );
  }
}
