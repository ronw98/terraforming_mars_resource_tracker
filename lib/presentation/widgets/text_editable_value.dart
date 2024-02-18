import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/presentation/extension/number_extension.dart';
import 'package:tm_ressource_tracker/presentation/managers/configuration_cubit.dart';
import 'package:tm_ressource_tracker/presentation/widgets/number_text_edit.dart';

/// This widget either displays a text or an editable text depending on
/// [Settings.editValuesWithText] value.
class TextEditableValue extends StatelessWidget {
  const TextEditableValue({
    required this.value,
    required this.editable,
    Key? key,
    this.style,
    this.onValueChanged,
    this.signedString = false,
  }) : super(key: key);
  final TextStyle? style;
  final int value;
  final Function(int)? onValueChanged;
  final bool editable;
  final bool signedString;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigurationCubit, ConfigurationState>(
      builder: (context, state) {
        final staticText = Text(
          signedString ? value.toSignedString() : value.toString(),
          style: style,
        );
        return state.maybeWhen(
          loaded: (config) {
            return config.settings.editValuesWithText && editable
                ? NumberTextEdit(
                    value: value,
                    onValueChanged: onValueChanged ?? (_) {},
                    style: style,
                    signedString: signedString,
                  )
                : staticText;
          },
          orElse: () => staticText,
        );
      },
    );
  }
}
