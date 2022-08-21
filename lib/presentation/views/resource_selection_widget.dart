import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/constants.dart';
import 'package:tm_ressource_tracker/domain/entities/cost_resource.dart';
import 'package:tm_ressource_tracker/domain/entities/marker_or_resource.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/presentation/extension/marker_type_extension.dart';
import 'package:tm_ressource_tracker/presentation/extension/resource_type_extension.dart';
import 'package:tm_ressource_tracker/presentation/widgets/marker_or_resource_dropdown_list.dart';
import 'package:tm_ressource_tracker/presentation/widgets/production_widget.dart';

class ResourceSelectionWidget extends StatelessWidget {
  const ResourceSelectionWidget({
    Key? key,
    required this.onNewType,
    required this.costResource,
  }) : super(key: key);

  final void Function(MarkerOrResource) onNewType;

  final CostResource costResource;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: MarkerOrResourceDropdownList(
            onItemTap: (markerOrResource) => onNewType(markerOrResource),
          ),
        ),
      ],
      splashRadius: 0,
      elevation: 0,
      color: Colors.transparent,
      child: costResource.when(
        stock: (_, ResourceType type) => Image(
          image: type.resourceImage,
          height: AppConstants.standardProjectItemSize,
        ),
        marker: (int value, MarkerType marker) => Image(
          image: marker.markerImage,
          height: AppConstants.standardProjectItemSize,
        ),
        production: (int value, ResourceType type) => SizedBox(
          child: ProductionWidget(type: type),
          height: AppConstants.standardProjectItemSize,
        ),
      ),
    );
  }
}
