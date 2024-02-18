import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/core/injection.dart';
import 'package:tm_ressource_tracker/domain/usecases/delete_user_data.dart';
import 'package:tm_ressource_tracker/jsons.dart';
import 'package:tm_ressource_tracker/presentation/extension/locales_ext.dart';

class DeleteUserDataButton extends StatefulWidget {
  const DeleteUserDataButton({Key? key}) : super(key: key);

  @override
  State<DeleteUserDataButton> createState() => _DeleteUserDataButtonState();
}

class _DeleteUserDataButtonState extends State<DeleteUserDataButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        setState(() {
          loading = true;
        });
        final result = await serviceLocator<DeleteUserData>()();
        setState(() {
          loading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result
                    ? LocaleKeys.settings.delete_data
                        .success()
                        .translate(context)
                    : LocaleKeys.settings.delete_data
                        .error()
                        .translate(context),
              ),
            ),
          );
        }
      },
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: loading
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              )
            : Icon(Icons.delete_forever),
      ),
      label: Text(
        LocaleKeys.settings.delete_data.button().translate(context),
      ),
    );
  }
}
