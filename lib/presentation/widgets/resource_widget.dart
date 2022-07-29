import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/presentation/managers/resource_cubit.dart';
import 'package:tm_ressource_tracker/presentation/widgets/none_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/primary_resource_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/terraforming_rating_widget.dart';

class ResourceWidget extends StatelessWidget {
  const ResourceWidget({Key? key, required this.resourceType}) : super(key: key);
  final ResourceType resourceType;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResourceCubit, ResourceState>(
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (resources) {
            final resource = resources[resourceType];
            if (resource == null) {
              return const NoneWidget();
            }
            return resource.when(
              terraformingLevel: (type, stock, stockHistory) {
                return TerraformingRatingWidget(
                  stock: stock,
                  stockHistory: stockHistory,
                );
              },
              primaryResource: (type, stock, stockHistory, prod, prodHistory) {
                return PrimaryResourceWidget(
                  type: type,
                  stock: stock,
                  stockHistory: stockHistory,
                  production: prod,
                  productionHistory: prodHistory,
                );
              },
            );
          },
          orElse: () => const NoneWidget(),
        );
      },
    );
  }
}
