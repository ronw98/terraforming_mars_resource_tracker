import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/presentation/extension/number_extension.dart';
import 'package:tm_ressource_tracker/presentation/extension/string_extension.dart';

class NumberTextEdit extends StatefulWidget {
  const NumberTextEdit({
    Key? key,
    required this.value,
    required this.onValueChanged,
    this.style,
    this.signedString = false,
  }) : super(key: key);
  final int value;
  final Function(int) onValueChanged;
  final TextStyle? style;
  final bool signedString;

  @override
  State<NumberTextEdit> createState() => _NumberTextEditState();
}

class _NumberTextEditState extends State<NumberTextEdit> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void didUpdateWidget(covariant NumberTextEdit oldWidget) {
    // If the widget has a changed value, update the value in the controller
    if (oldWidget.value != widget.value) {
      _controller.text = widget.signedString
          ? widget.value.toSignedString()
          : '${widget.value}';
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = TextEditingController(text: '${widget.value}');
    _controller.addListener(() {
      final lastCharacter = _controller.text.last;
      // Character typed is '-' in beginning of string, allowed
      if (lastCharacter == '-' && _controller.text.length == 1) {
        return;
      }
      // Character is invalid character => remove
      if (int.tryParse(lastCharacter) == null) {
        _controller.text =
            _controller.text.substring(0, _controller.text.length - 1);
        _controller.selection = TextSelection(
          baseOffset: _controller.text.length,
          extentOffset: _controller.text.length,
        );
      }
    });
    _focusNode = FocusNode();
    _focusNode.addListener(
      () {
        if (_focusNode.hasFocus) {
          _controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controller.text.length,
          );
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(200, 220, 220, 220),
      child: IntrinsicWidth(
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          onEditingComplete: () {
            widget.onValueChanged(
              int.tryParse(_controller.text) ?? 0,
            );
            _focusNode.unfocus();
          },
          textAlign: TextAlign.center,
          style: widget.style,
          maxLines: 1,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.numberWithOptions(
            decimal: false,
            signed: true,
          ),
        ),
      ),
    );
  }
}
