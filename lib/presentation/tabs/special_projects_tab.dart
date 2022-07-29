import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/presentation/managers/configuration_cubit.dart';
import 'package:tm_ressource_tracker/presentation/managers/resource_cubit.dart';
import 'package:tm_ressource_tracker/presentation/widgets/none_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/special_project_widget.dart';

class SpecialProjectsTab extends StatelessWidget {
  const SpecialProjectsTab({Key? key}) : super(key: key);

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
                    config.specialProjectConfig.projects
                        .map(
                          (project) => GestureDetector(
                            onTap: () => BlocProvider.of<ResourceCubit>(context)
                                .onProjectTap(project),
                            child: SpecialProjectWidget(project: project),
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
