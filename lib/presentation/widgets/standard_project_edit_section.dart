import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/constants.dart';
import 'package:tm_ressource_tracker/domain/entities/cost_resource.dart';
import 'package:tm_ressource_tracker/domain/entities/marker_or_resource.dart';
import 'package:tm_ressource_tracker/presentation/managers/configuration_cubit.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/views/resource_selection_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/category_separator_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/circle_icon_button.dart';
import 'package:tm_ressource_tracker/presentation/widgets/none_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/number_text_edit.dart';

class StandardProjectEditSection extends StatelessWidget {
  const StandardProjectEditSection({
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CategorySeparatorWidget(
            text: isCost ? 'Project cost' : 'Project reward'),
        ...resources.map(
          (costResource) {
            return Padding(
              padding: const EdgeInsets.only(bottom: smallPadding),
              child: Row(
                children: [
                  Expanded(
                    child: UnconstrainedBox(
                      alignment: Alignment.centerLeft,
                      child: NumberTextEdit(
                        value: costResource.value,
                        onValueChanged: (value) => _onNewQuantity(
                          context,
                          value,
                          costResource,
                        ),
                      ),
                    ),
                  ),
                  horizontalSpacer,
                  Flexible(
                    flex: 6,
                    child: ResourceSelectionWidget(
                      onNewType: (newType) => _onNewType(
                        context,
                        newType,
                        costResource,
                      ),
                      costResource: costResource,
                    ),
                  ),
                  horizontalBigSpacer,
                  ShapeIconButton(
                    onPressed: () => _onRemovePressed(context, costResource),
                    icon: Icon(
                      Icons.remove,
                      size: AppConstants.standardProjectItemSize,
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        verticalSpacer,
        Row(
          children: [
            Expanded(
              child: const NoneWidget(),
            ),
            horizontalSpacer,
            Flexible(
              flex: 6,
              child: ShapeIconButton(
                onPressed: () => _onAddPressed(context),
                icon: Icon(
                  Icons.add,
                  size: AppConstants.standardProjectItemSize,
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            horizontalBigSpacer,
            const SizedBox(width: AppConstants.standardProjectItemSize)
          ],
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
        ? BlocProvider.of<ConfigurationCubit>(context).updateStandardProjectCost
        : BlocProvider.of<ConfigurationCubit>(context)
            .updateStandardProjectReward;

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
        ? BlocProvider.of<ConfigurationCubit>(context).updateStandardProjectCost
        : BlocProvider.of<ConfigurationCubit>(context)
            .updateStandardProjectReward;
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

  void _onAddPressed(BuildContext context) {
    final updateMethod = isCost
        ? BlocProvider.of<ConfigurationCubit>(context).addStandardProjectCost
        : BlocProvider.of<ConfigurationCubit>(context).addStandardProjectReward;

    updateMethod(projectId: projectId);
  }

  void _onRemovePressed(BuildContext context, CostResource resource) {
    final updateMethod = isCost
        ? BlocProvider.of<ConfigurationCubit>(context).removeStandardProjectCost
        : BlocProvider.of<ConfigurationCubit>(context)
            .removeStandardProjectReward;

    updateMethod(projectId: projectId, resource: resource);
  }
}
