import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';

class TabItem extends StatelessWidget {
  const TabItem({
    required this.widthFactor,
    required this.text,
    Key? key,
  }) : super(key: key);
  final double widthFactor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width * widthFactor,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: smallPadding),
          child: Tab(text: text),
        ),
      ),
    );
  }
}
