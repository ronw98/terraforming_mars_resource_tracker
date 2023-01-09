import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/theme/app_theme.dart';
import 'package:tm_ressource_tracker/presentation/widgets/custom_card.dart';

class CreateGameDialog extends StatefulWidget {
  const CreateGameDialog({Key? key}) : super(key: key);

  @override
  State<CreateGameDialog> createState() => _CreateGameDialogState();
}

class _CreateGameDialogState extends State<CreateGameDialog> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    _nameController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Select a name'),
              verticalBigSpacer,
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('User name'),
                ),
              ),
              verticalBigSpacer,
              ElevatedButton.icon(
                onPressed: _nameController.text.isEmpty
                    ? null
                    : () {
                        // TODO: join logic here
                        if (_nameController.text.isNotEmpty) {
                          Navigator.pop(
                            context,
                            _nameController.text,
                          );
                        }
                      },
                icon: Icon(Icons.check),
                label: Text('Create game!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
