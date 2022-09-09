import 'package:flutter/material.dart';

class TMDefaultPage extends StatelessWidget {
  const TMDefaultPage({
    Key? key,
    required this.pageContent,
  }) : super(key: key);

  final Widget pageContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: SweepGradient(
          center: Alignment.bottomCenter,
          startAngle: 0,
          endAngle: 3.1415 / 4,
          tileMode: TileMode.mirror,
          colors: [
            Color.fromARGB(255, 108, 64, 38),
            Color.fromARGB(255, 84, 56, 40),
            Color.fromARGB(255, 110, 60, 32),
            Color.fromARGB(255, 140, 80, 38),
          ],
        ),
      ),
      child: pageContent,
    );
  }
}
