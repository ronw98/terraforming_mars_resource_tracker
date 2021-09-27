import 'package:flutter/material.dart';

import 'edit_value_button.dart';

class EditableFieldBig extends StatelessWidget {
  EditableFieldBig({
    required this.value,
    required this.onValueChanged,
    this.buttonTextStyle,
    this.valueTextStyle,
  });

  final int value;
  final Function(int) onValueChanged;
  final TextStyle? buttonTextStyle;
  final TextStyle? valueTextStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        EditValueButton(
          onPressed: () => onValueChanged(-10),
          text: '-10',
        ),
        EditValueButton(
          onPressed: () => onValueChanged(-5),
          text: '-5',
        ),
        EditValueButton(
          onPressed: () => onValueChanged(-1),
          text: '-1',
        ),
        Text(
          '$value',
          style: valueTextStyle
        ),
        EditValueButton(
          onPressed: () => onValueChanged(1),
          text: '+1',
        ),
        EditValueButton(
          onPressed: () => onValueChanged(5),
          text: '+5',
        ),
        EditValueButton(
          onPressed: () => onValueChanged(10),
          text: '+10',
        ),
      ],
    );
  }
}
