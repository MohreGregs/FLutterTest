import 'package:flutter/material.dart';

class SliderWithText extends StatefulWidget {
  @override
  SliderWithTextState createState() => SliderWithTextState();

  const SliderWithText({
    super.key,
    required this.text,
    required this.onSliderChanged,
    required this.currentState,
    required this.rangeStart,
    required this.rangeEnd,
  });

  final String text;
  final ValueChanged<double> onSliderChanged;
  final double currentState;
  final int rangeStart;
  final int rangeEnd;
}

class SliderWithTextState extends State<SliderWithText> {
  double currentState = 0;

  double _getSliderValue() {
    return widget.currentState;
  }

  @override
  void initState() {
    super.initState();
    currentState = _getSliderValue();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.text,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text(widget.rangeStart.toString()),
                Expanded(
                  child: Slider(
                    value: currentState,
                    min: widget.rangeStart.toDouble(),
                    max: widget.rangeEnd.toDouble(),
                    divisions: (widget.rangeEnd - widget.rangeStart).toInt(),
                    label: currentState.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        currentState = value;
                      });
                    },
                    onChangeEnd: (value) {
                      widget.onSliderChanged(currentState);
                    },
                  ),
                ),
                Text(widget.rangeEnd.toString())
              ],
            ))
      ],
    );
  }
}
