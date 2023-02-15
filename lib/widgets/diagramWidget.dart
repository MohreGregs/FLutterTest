import 'package:flutter/material.dart';

import '../classes/argument.dart';
import '../classes/diagramPainter.dart';

class DiagramPage extends StatelessWidget {
  const DiagramPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Argument> args =
        ModalRoute.of(context)?.settings.arguments as List<Argument>;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data"),
      ),
      body: args.isNotEmpty
          ? CustomPaint(
              size: const Size(double.infinity, double.infinity),
              painter: DiagramPainter(args))
          : const Text("No Data"),
    );
  }
}
