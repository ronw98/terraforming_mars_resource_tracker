import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/core/injection.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/domain/usecases/resource_use_cases.dart';
import 'package:tm_ressource_tracker/presentation/managers/resource_cubit.dart';
import 'package:tm_ressource_tracker/presentation/widgets/none_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/primary_resource_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/terraforming_rating_widget.dart';

class ResourceWidget extends StatelessWidget {
  const ResourceWidget({
    required this.resourceType,
    Key? key,
  }) : super(key: key);
  final ResourceType resourceType;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalGameCubit, LocalGameState>(
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (gameState) {
            final resource = serviceLocator<ResourceFromType>()(
              gameState.resources,
              resourceType,
            );
            return switch (resource) {
              TerraformingRating() => TerraformingRatingWidget(
                  stock: resource.stock,
                  stockHistory: resource.stockHistory,
                ),
              PrimaryResource() => PrimaryResourceWidget(
                  type: resource.type,
                  stock: resource.stock,
                  stockHistory: resource.stockHistory,
                  production: resource.production,
                  productionHistory: resource.productionHistory,
                )
            };
          },
          orElse: () => const NoneWidget(),
        );
      },
    );
  }
}
