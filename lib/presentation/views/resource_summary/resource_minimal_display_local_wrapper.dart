import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/core/injection.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/domain/usecases/resource_use_cases.dart';
import 'package:tm_ressource_tracker/presentation/managers/resource_cubit.dart';
import 'package:tm_ressource_tracker/presentation/widgets/none_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/resource_minimal_display.dart';

/// A wrapper around [ResourceMinimalDisplay] which uses the local resources
class ResourceMinimalDisplayLocalWrapper extends StatelessWidget {
  const ResourceMinimalDisplayLocalWrapper({
    required this.resourceType,
    Key? key,
  }) : super(key: key);
  final ResourceType resourceType;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LocalGameCubit, LocalGameState, Resource?>(
      selector: (state) {
        return state.whenOrNull<Resource?>(
          loaded: (gameState) {
            return serviceLocator<ResourceFromType>()(
              gameState.resources,
              resourceType,
            );
          },
        );
      },
      builder: (context, maybeResource) {
        if (maybeResource == null) {
          return const NoneWidget();
        }
        return ResourceMinimalDisplay(resource: maybeResource);
      },
    );
  }
}
