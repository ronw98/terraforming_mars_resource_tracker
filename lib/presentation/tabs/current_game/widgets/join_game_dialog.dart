import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/jsons.dart';
import 'package:tm_ressource_tracker/presentation/extension/string_extension.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/theme/app_theme.dart';
import 'package:tm_ressource_tracker/presentation/widgets/custom_card.dart';

class JoinInfo {
  JoinInfo(this.inviteCode, this.userName);

  final String inviteCode;
  final String userName;
}

class JoinGameDialog extends StatefulWidget {
  const JoinGameDialog({Key? key}) : super(key: key);

  @override
  State<JoinGameDialog> createState() => _JoinGameDialogState();
}

class _JoinGameDialogState extends State<JoinGameDialog> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    _codeController.addListener(() {
      setState(() {});
    });

    _nameController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: CustomCard(
        backgroundColor: TMColors.dialogBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(LocaleKeys.game.join_dialog.title.translate(context)),
              verticalBigSpacer,
              TextField(
                controller: _codeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text(
                    LocaleKeys.game.join_dialog.invite_code.translate(context),
                  ),
                ),
              ),
              verticalSpacer,
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text(
                    LocaleKeys.game.join_dialog.user_name.translate(context),
                  ),
                ),
              ),
              verticalBigSpacer,
              ElevatedButton.icon(
                onPressed: _nameController.text.isEmpty ||
                        _codeController.text.length != 6
                    ? null
                    : () {
                        // TODO: join logic here
                        if (_nameController.text.isNotEmpty &&
                            _codeController.text.isNotEmpty) {
                          Navigator.pop(
                            context,
                            JoinInfo(
                              _codeController.text,
                              _nameController.text,
                            ),
                          );
                        }
                      },
                icon: Icon(Icons.check),
                label: Text(
                  LocaleKeys.game.join_dialog.confirm.translate(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
