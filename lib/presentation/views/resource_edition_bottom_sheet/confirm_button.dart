import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/jsons.dart';
import 'package:tm_ressource_tracker/presentation/extension/locales_ext.dart';

class EditionConfirmButton extends StatelessWidget {
  const EditionConfirmButton({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 4,
          ),
        ],
      ),
      child: Material(
        elevation: 0,
        type: MaterialType.button,
        color: Theme.of(context).colorScheme.primary,
        child: InkWell(
          onTap: onPressed,
          child: SafeArea(
            child: ElevatedButton.icon(
              onPressed: null,
              icon: Icon(Icons.check),
              label: Text(
                LocaleKeys.common.confirm().translate(context),
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
      ),
    );
  }
}
