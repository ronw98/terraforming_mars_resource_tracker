import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/jsons.dart';
import 'package:tm_ressource_tracker/presentation/extension/standard_project_extension.dart';
import 'package:tm_ressource_tracker/presentation/extension/string_extension.dart';
import 'package:tm_ressource_tracker/presentation/managers/configuration_cubit.dart';
import 'package:tm_ressource_tracker/presentation/managers/resource_cubit.dart';
import 'package:tm_ressource_tracker/presentation/widgets/none_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/standard_project_widget.dart';

class StandardProjectsTab extends StatelessWidget {
  const StandardProjectsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        BlocBuilder<ConfigurationCubit, ConfigurationState>(
          builder: (context, state) {
            return state.maybeWhen(
              loaded: (config) {
                return SliverList(
                  delegate: SliverChildListDelegate(
                    config.standardProjectConfig.projects.values
                        .filterWithSettings(config.settings)
                        .map(
                          (project) => GestureDetector(
                            onTap: () async {
                              final result =
                                  await BlocProvider.of<ResourceCubit>(context)
                                      .onProjectTap(project);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    result
                                        ? LocaleKeys.standard_project
                                            .project_result.success
                                            .translate(context)
                                        : LocaleKeys.standard_project
                                            .project_result.error
                                            .translate(context),
                                    style: TextStyle(
                                      color: result ? Colors.green : Colors.red,
                                    ),
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            child: StandardProjectWidget(project: project),
                          ),
                        )
                        .toList(),
                  ),
                );
              },
              orElse: () => SliverToBoxAdapter(
                child: const NoneWidget(),
              ),
            );
          },
        ),
      ],
    );
  }
}
