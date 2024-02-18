import 'package:flutter/material.dart';

class CategorySeparatorWidget extends StatelessWidget {
  const CategorySeparatorWidget({
    required this.text,
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const Divider(),
      ],
    );
  }
}
