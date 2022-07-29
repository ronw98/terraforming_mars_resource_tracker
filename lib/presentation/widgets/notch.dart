import 'package:flutter/material.dart';

class Notch extends StatelessWidget {
  const Notch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.zero,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}