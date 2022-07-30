import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/domain/entities/cost_resource.dart';
import 'package:tm_ressource_tracker/domain/entities/marker_or_resource.dart';
import 'package:tm_ressource_tracker/presentation/managers/configuration_cubit.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/views/resource_selection_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/category_separator_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/number_text_edit.dart';

class SpecialProjectEditSection extends StatelessWidget {
  const SpecialProjectEditSection({
    Key? key,
    required this.resources,
    required this.projectId,
    required this.isCost,
  }) : super(key: key);

  final List<CostResource> resources;
  final String projectId;
  final bool isCost;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CategorySeparatorWidget(
            text: isCost ? 'Project cost' : 'Project reward'),
        ...resources.map(
          (costResource) {
            return Padding(
              padding: const EdgeInsets.only(bottom: smallPadding),
              child: Row(
                children: [
                  NumberTextEdit(
                    value: costResource.value,
                    onValueChanged: (value) => _onNewQuantity(
                      context,
                      value,
                      costResource,
                    ),
                  ),
                  horizontalSpacer,
                  ResourceSelectionWidget(
                    onNewType: (newType) => _onNewType(
                      context,
                      newType,
                      costResource,
                    ),
                    costResource: costResource,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _onNewQuantity(
    BuildContext context,
    int value,
    CostResource oldCost,
  ) {
    final updateMethod = isCost
        ? BlocProvider.of<ConfigurationCubit>(context).updateSpecialProjectCost
        : BlocProvider.of<ConfigurationCubit>(context)
            .updateSpecialProjectReward;

    updateMethod(
      id: projectId,
      oldCost: oldCost,
      newCost: oldCost.copyWith(
        value: value,
      ),
    );
  }

  void _onNewType(
    BuildContext context,
    MarkerOrResource item,
    CostResource oldCost,
  ) {
    final updateMethod = isCost
        ? BlocProvider.of<ConfigurationCubit>(context).updateSpecialProjectCost
        : BlocProvider.of<ConfigurationCubit>(context)
            .updateSpecialProjectReward;
    updateMethod(
      id: projectId,
      oldCost: oldCost,
      newCost: item.when(
        marker: (marker) => CostResource.marker(
          value: oldCost.value,
          marker: marker,
        ),
        resource: (resource, production) => production
            ? CostResource.production(
                value: oldCost.value,
                type: resource,
              )
            : CostResource.stock(
                value: oldCost.value,
                type: resource,
              ),
      ),
    );
  }
}
