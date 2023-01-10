import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/presentation/managers/resource_cubit.dart';
import 'package:tm_ressource_tracker/presentation/widgets/none_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/resource_minimal_display.dart';

/// A wrapper around [ResourceMinimalDisplay] which uses the local resources
class ResourceMinimalDisplayLocalWrapper extends StatelessWidget {
  const ResourceMinimalDisplayLocalWrapper({
    Key? key,
    required this.resourceType,
  }) : super(key: key);
  final ResourceType resourceType;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ResourceCubit, ResourceState, Resource?>(
      selector: (state) => state.whenOrNull<Resource?>(
        loaded: (resources) => resources[resourceType],
      ),
      builder: (context, maybeResource) {
        if (maybeResource == null) {
          return const NoneWidget();
        }
        return ResourceMinimalDisplay(resource: maybeResource);
      },
    );
  }
}
