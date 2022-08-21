import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/presentation/extension/string_extension.dart';
import 'package:tm_ressource_tracker/presentation/managers/configuration_cubit.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/views/tm_default_bottom_sheet.dart';
import 'package:tm_ressource_tracker/presentation/widgets/none_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/standard_project_edit_section.dart';
import 'package:tm_ressource_tracker/presentation/widgets/unfocus_parent_widget.dart';

class StandardProjectEditionBottomSheet extends StatelessWidget {
  const StandardProjectEditionBottomSheet({
    Key? key,
    required this.projectId,
  }) : super(key: key);

  final String projectId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigurationCubit, ConfigurationState>(
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (config) {
            final project = config.standardProjectConfig.projects[projectId];
            if (project == null) {
              return const NoneWidget();
            }
            return UnfocusParentWidget(
              child: TMDefaultBottomSheet(
                initialChildSize: 0.5,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Column(
                    children: [
                      Text(
                        project.id.capitalizeFirst(),
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      verticalBigSpacer,
                      StandardProjectEditSection(
                        resources: project.cost,
                        projectId: projectId,
                        isCost: true,
                      ),
                      verticalBigSpacer,
                      StandardProjectEditSection(
                        resources: project.reward,
                        projectId: projectId,
                        isCost: false,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          orElse: () => const NoneWidget(),
        );
      },
    );
  }
}
