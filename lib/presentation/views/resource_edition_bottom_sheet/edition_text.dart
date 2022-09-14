import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/presentation/widgets/text_editable_value.dart';

class EditionText extends StatelessWidget {
  const EditionText({
    Key? key,
    required this.value,
    this.onValueChanged,
    this.textColor,
  }) : super(key: key);

  final int value;
  final Function(int newValue)? onValueChanged;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final style =
        Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor);
    return RichText(
      text: TextSpan(
        style: style,
        children: [
          TextSpan(text: '('),
          WidgetSpan(
            child: TextEditableValue(
              editable: true,
              value: value,
              signedString: true,
              onValueChanged: onValueChanged,
              style: style,
            ),
          ),
          TextSpan(
            text: ')',
          ),
        ],
      ),
    );
  }
}
