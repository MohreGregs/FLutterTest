import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const InsertDataPage(),
        '/data': (context) => const DiagramPage(),
      },
    );
  }
}

class InsertDataPage extends StatefulWidget{
  const InsertDataPage({super.key});

  @override
  State<StatefulWidget> createState() => InsertDataPageState();
}

class InsertDataPageState extends State<InsertDataPage>{

  double size = 50;
  double ye = 50;
  double mi = 50;
  double ijhsdg = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Insert Data"),
      ),
      body: Column(
        children: <Widget>[
          SliderWithText(
              text: "Size",
              onSliderChanged: (value){
                size = value;
              },
              currentState: size
          ),
          SliderWithText(
              text: "ye",
              onSliderChanged: (value){
                ye = value;
              },
              currentState: ye
          ),
          SliderWithText(
              text: "mi",
              onSliderChanged: (value){
                mi = value;
              },
              currentState: mi
          ),
          SliderWithText(
              text: "isdhjgf",
              onSliderChanged: (value){
                ijhsdg = value;
              },
              currentState: ijhsdg
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/data',
                arguments: Arguments(size, ye, mi, ijhsdg)
              );
            },
            child: const Text('Send Data'),
          ),
        ],
      ),
    );
  }
}

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



class DiagramPage extends StatelessWidget{
  const DiagramPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Arguments args = ModalRoute.of(context)?.settings.arguments as Arguments;
    return Scaffold(
        appBar: AppBar(
        title: const Text("Data"),
    ),
    body:
      CustomPaint(size: const Size(double.infinity, double.infinity), painter: DiagramPainter(args)),

    );
  }
}



class DiagramPainter extends CustomPainter{
  DiagramPainter(this.args);

  Arguments args;

  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2.0;
    var centerY = size.height / 2.0;
    var centerOffset = Offset(centerX, centerY);
    var radius = centerX * 0.8;

    final thinPaint = Paint()
      ..strokeWidth = 1
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(centerOffset, radius, thinPaint);

    var ticks = [20, 40, 60, 80, 100];
    var tickDistance = radius / ticks.length;
    const double tickLabelFontSize = 12;

    var ticksPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    ticks.sublist(0, ticks.length - 1).asMap().forEach((index, tick) {
      var tickRadius = tickDistance * (index + 1);

      canvas.drawCircle(centerOffset, tickRadius, ticksPaint);

      TextPainter(
          text: TextSpan(
            text: tick.toString(),
            style: const TextStyle(color: Colors.grey, fontSize: tickLabelFontSize),
          ),
        textDirection: TextDirection.ltr,
      )
      ..layout(minWidth: 0, maxWidth: size.width)
      ..paint(canvas, Offset(centerX, centerY - tickRadius - tickLabelFontSize));
    });

    var attributes = ["Size", "ijgsd", "gfsg", "fsfs", "fsfsdfs", "ghjsdg"];
    var angle = (2 * pi) / attributes.length;
    const double attributeLabelFontSize = 16;
    const double attributeLabelFontWidth = 12;

    attributes.asMap().forEach((index, attribute) {
      var xAngle = cos(angle * index - pi / 2);
      var yAngle = sin(angle * index - pi / 2);

      var attributeOffset = Offset(centerX + radius * xAngle, centerY + radius * yAngle);

      canvas.drawLine(centerOffset, attributeOffset, ticksPaint);

      var labelYOffset = yAngle < 0 ? -attributeLabelFontSize : 0;
      var labelXOffset = xAngle < 0 ? -attributeLabelFontWidth * attribute.length: 0;

      TextPainter(
        text: TextSpan(
          text: attribute,
          style: const TextStyle(color: Colors.black, fontSize: attributeLabelFontSize),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      )
      ..layout(minWidth: 0, maxWidth: size.width)
      ..paint(canvas, Offset(attributeOffset.dx + labelXOffset, attributeOffset.dy + labelYOffset));
    });

    var scale = radius / ticks.last;

    var graphPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..isAntiAlias = true;

    var data = [
      args.size,
      args.ye,
      args.mi,
      args.ijhsdg,
      100,
      0
    ];

    var scalePoint = scale * data[0];
    var path = Path();

    path.moveTo(centerX, centerY - scalePoint);

    data.sublist(1).asMap().forEach((index, point){
      var xAngle = cos(angle * (index + 1) - pi / 2);
      var yAngle = sin(angle * (index + 1) - pi / 2);
      var scaledPoint = scale * point;

      path.lineTo(centerX + scaledPoint * xAngle, centerY + scaledPoint * yAngle);
    });

    path.close();

    canvas.drawPath(path, graphPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Arguments{
  final double size;
  final double ye;
  final double mi;
  final double ijhsdg;

  Arguments(this.size, this.ye, this.mi, this.ijhsdg);
}