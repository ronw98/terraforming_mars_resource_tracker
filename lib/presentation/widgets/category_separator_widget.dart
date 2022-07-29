import 'package:flutter/material.dart';

class CategorySeparatorWidget extends StatelessWidget {
  const CategorySeparatorWidget({
    Key? key,
    required this.text,
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
