import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/jsons.dart';
import 'package:tm_ressource_tracker/presentation/extension/string_extension.dart';

class EditionConfirmButton extends StatelessWidget {
  const EditionConfirmButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      type: MaterialType.button,
      color: Theme.of(context).colorScheme.primary,
      child: InkWell(
        onTap: onPressed,
        child: SafeArea(
          child: ElevatedButton.icon(
            onPressed: null,
            icon: Icon(Icons.check),
            label: Text(
              LocaleKeys.common.confirm.translate(context),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Colors.transparent,
              ),
              foregroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
