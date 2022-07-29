import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/widgets/edit_value_button.dart';

class EditValueWidget extends StatelessWidget {
  const EditValueWidget({
    Key? key,
    required this.value,
    required this.onValueChanged,
    this.textStyle,
  }) : super(key: key);
  final int value;
  final void Function(int) onValueChanged;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EditValueButton(
          text: '-10',
          onPressed: () {
            onValueChanged(value - 10);
          },
        ),
        EditValueButton(
          text: '-5',
          onPressed: () {
            onValueChanged(value - 5);
          },
        ),
        EditValueButton(
          text: '-1',
          onPressed: () {
            onValueChanged(value - 1);
          },
        ),
        horizontalSpacer,
        Text(
          '$value',
          style: textStyle,
        ),
        horizontalSpacer,
        EditValueButton(
          text: '+1',
          onPressed: () {
            onValueChanged(value + 1);
          },
        ),
        EditValueButton(
          text: '+5',
          onPressed: () {
            onValueChanged(value + 5);
          },
        ),
        EditValueButton(
          text: '+10',
          onPressed: () {
            onValueChanged(value + 10);
          },
        ),
      ],
    );
  }
}
