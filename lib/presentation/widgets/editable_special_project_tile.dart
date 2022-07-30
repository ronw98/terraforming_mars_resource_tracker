import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/domain/entities/special_project.dart';
import 'package:tm_ressource_tracker/presentation/views/special_project_edition_sheet.dart';
import 'package:tm_ressource_tracker/presentation/widgets/circle_icon_button.dart';
import 'package:tm_ressource_tracker/presentation/widgets/special_project_widget.dart';

class EditableSpecialProjectTile extends StatelessWidget {
  const EditableSpecialProjectTile({
    Key? key,
    required this.project,
  }) : super(key: key);
  final SpecialProject project;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SpecialProjectWidget(
            project: project,
          ),
        ),
        ShapeIconButton(
          semanticsLabel: project.id,
          onPressed: () => onEditSpecialProject(
            context,
            project,
          ),
          icon: Icon(Icons.edit),
          shape: RoundedRectangleBorder(),
        ),
      ],
    );
  }

  void onEditSpecialProject(BuildContext context, SpecialProject project) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => SpecialProjectEditionBottomSheet(projectId: project.id),
    );
  }
}
