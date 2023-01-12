import 'dart:math';

import 'package:flutter/material.dart';

import 'argument.dart';

class DiagramPainter extends CustomPainter{
  DiagramPainter(this.args);

  List<Argument> args;

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

    var attributes = [];
    for (var element in args) {
      attributes.add(element.name);
    }

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


    var scalePoint = scale * args.first.value;
    var path = Path();

    path.moveTo(centerX, centerY - scalePoint);

    args.sublist(1).asMap().forEach((index, arg){
      var xAngle = cos(angle * (index + 1) - pi / 2);
      var yAngle = sin(angle * (index + 1) - pi / 2);
      var scaledPoint = scale * arg.value;

      path.lineTo(centerX + scaledPoint * xAngle, centerY + scaledPoint * yAngle);
    });

    path.close();

    canvas.drawPath(path, graphPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}