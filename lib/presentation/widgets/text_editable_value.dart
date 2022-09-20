import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/presentation/extension/number_extension.dart';
import 'package:tm_ressource_tracker/presentation/extension/string_extension.dart';
import 'package:tm_ressource_tracker/presentation/managers/configuration_cubit.dart';
import 'package:tm_ressource_tracker/presentation/widgets/number_text_edit.dart';

/// This widget either displays a text or an editable text depending on [Settings.editValuesWithText] value
class TextEditableValue extends StatefulWidget {
  const TextEditableValue({
    Key? key,
    this.style,
    required this.value,
    this.onValueChanged,
    required this.editable,
    this.signedString = false,
  }) : super(key: key);
  final TextStyle? style;
  final int value;
  final Function(int)? onValueChanged;
  final bool editable;
  final bool signedString;

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
        final staticText = Text(
          widget.signedString
              ? widget.value.toSignedString()
              : widget.value.toString(),
          style: widget.style,
        );
        return state.maybeWhen(
          loaded: (config) {
            return config.settings.editValuesWithText && widget.editable
                ? NumberTextEdit(
                    value: widget.value,
                    onValueChanged: widget.onValueChanged ?? (_) {},
                    style: widget.style,
                    signedString: widget.signedString,
                  )
                : staticText;
          },
          orElse: () => staticText,
        );
      },
    );
  }
}
