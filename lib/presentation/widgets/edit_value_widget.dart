import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/widgets/edit_value_button.dart';
import 'package:tm_ressource_tracker/presentation/widgets/text_editable_value.dart';

class EditValueWidget extends StatelessWidget {
  const EditValueWidget({
    Key? key,
    required this.value,
    this.onValueChanged,
    this.onNewValue,
    this.textStyle,
    this.editable = false,
  }) : super(key: key);
  final int value;
  final void Function(int change)? onValueChanged;
  final void Function(int newValue)? onNewValue;
  final TextStyle? textStyle;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EditValueButton(
          text: '-10',
          onPressed: () {
            onValueChanged?.call(- 10);
          },
        ),
        EditValueButton(
          text: '-5',
          onPressed: () {
            onValueChanged?.call(- 5);
          },
        ),
        EditValueButton(
          text: '-1',
          onPressed: () {
            onValueChanged?.call(- 1);
          },
        ),
        horizontalSpacer,
        TextEditableValue(
          value: value,
          style: textStyle,
          editable: editable,
          onValueChanged: onNewValue,
        ),
        horizontalSpacer,
        EditValueButton(
          text: '+1',
          onPressed: () {
            onValueChanged?.call(1);
          },
        ),
        EditValueButton(
          text: '+5',
          onPressed: () {
            onValueChanged?.call(5);
          },
        ),
        EditValueButton(
          text: '+10',
          onPressed: () {
            onValueChanged?.call(10);
          },
        ),
      ],
    );
  }
}
