import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/domain/entities/standard_project.dart';
import 'package:tm_ressource_tracker/presentation/extension/standard_project_extension.dart';
import 'package:tm_ressource_tracker/presentation/views/standard_project_edition_sheet.dart';
import 'package:tm_ressource_tracker/presentation/widgets/circle_icon_button.dart';
import 'package:tm_ressource_tracker/presentation/widgets/standard_project_widget.dart';

class EditableStandardProjectTile extends StatelessWidget {
  const EditableStandardProjectTile({
    required this.project,
    Key? key,
  }) : super(key: key);
  final StandardProject project;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StandardProjectWidget(
            project: project,
          ),
        ),
        ShapeIconButton(
          semanticsKey: project.translatedName(context),
          onPressed: () => onEditStandardProject(
            context,
            project,
          ),
          icon: Icon(Icons.edit),
          shape: RoundedRectangleBorder(),
        ),
      ],
    );
  }

  void onEditStandardProject(BuildContext context, StandardProject project) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => StandardProjectEditionBottomSheet(projectId: project.id),
    );
  }
}
