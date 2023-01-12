import 'package:flutter/material.dart';

class SliderWithText extends StatefulWidget{
  @override
  SliderWithTextState createState() => SliderWithTextState();

  const SliderWithText({
    super.key,
    required this.text,
    required this.onSliderChanged,
    required this.currentState,
  });

  final String text;
  final ValueChanged<double> onSliderChanged;
  final double currentState;
}

class SliderWithTextState extends State<SliderWithText>{

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
        Slider(
          value: currentState,
          max: 100,
          divisions: 100,
          label: currentState.round().toString(),
          onChanged: (double value) {
            setState((){
              currentState = value;
            });
          },
          onChangeEnd: (value){
            widget.onSliderChanged(currentState);
          },
        ),
      ],
    );
  }
}