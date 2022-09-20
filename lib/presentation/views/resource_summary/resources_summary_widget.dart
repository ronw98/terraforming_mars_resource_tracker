import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/presentation/managers/resource_cubit.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/views/resource_summary/resource_minimal_display.dart';
import 'package:tm_ressource_tracker/presentation/widgets/custom_card.dart';
import 'package:tm_ressource_tracker/presentation/widgets/none_widget.dart';

class ResourcesSummaryWidget extends StatelessWidget {
  const ResourcesSummaryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResourceCubit, ResourceState>(
      buildWhen: (previous, next) => previous.runtimeType != next.runtimeType,
      builder: (context, state) {
        return state.maybeMap(
          loaded: (_) => CustomCard(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: bigPadding,
                runSpacing: smallPadding,
                children: ResourceType.values
                    .map((type) => ResourceMinimalDisplay(resourceType: type))
                    .toList(),
              ),
            ),
          ),
          orElse: () => const NoneWidget(),
        );
      },
    );
  }
}
