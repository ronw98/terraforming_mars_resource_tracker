import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/presentation/extension/string_extension.dart';
import 'package:tm_ressource_tracker/presentation/managers/configuration_cubit.dart';

/// This widget either displays a text or an editable text depending on [Settings.editValuesWithText] value
class TextEditableValue extends StatefulWidget {
  const TextEditableValue({
    Key? key,
    this.style,
    required this.value,
    required this.onValueChanged,
  }) : super(key: key);
  final TextStyle? style;
  final int value;
  final Function(int) onValueChanged;

  @override
  State<TextEditableValue> createState() => _TextEditableValueState();
}

class _TextEditableValueState extends State<TextEditableValue> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    _controller = TextEditingController(text: '${widget.value}');
    _controller.addListener(() {
      final lastCharacter = _controller.text.last;
      // Character typed is '-' in beginning of string, allowed
      if(lastCharacter == '-' && _controller.text.length ==1 ) {
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
  void didUpdateWidget(covariant TextEditableValue oldWidget) {
    // If the widget has a changed value, update the value in the controller
    if (oldWidget.value != widget.value) {
      _controller.text = '${widget.value}';
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
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigurationCubit, ConfigurationState>(
      builder: (context, state) {
        final staticText = Text('${widget.value}', style: widget.style);
        return state.maybeWhen(
          loaded: (config) {
            return config.settings.editValuesWithText
                ? IntrinsicWidth(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      onEditingComplete: () {
                        widget.onValueChanged(
                          int.tryParse(_controller.text) ?? 0,
                        );
                        _focusNode.unfocus();
                      },
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
                  )
                : staticText;
          },
          orElse: () => staticText,
        );
      },
    );
  }
}