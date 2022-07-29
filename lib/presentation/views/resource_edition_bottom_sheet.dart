import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/constants.dart' as constants;
import 'package:tm_ressource_tracker/core/injection.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/presentation/extension/resource_type_extension.dart';
import 'package:tm_ressource_tracker/presentation/managers/resource_cubit.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/views/tm_default_bottom_sheet.dart';
import 'package:tm_ressource_tracker/presentation/widgets/category_separator_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/edit_value_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/none_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/resource_history_widget.dart';

class ResourceEditionBottomSheet extends StatelessWidget {
  const ResourceEditionBottomSheet({
    Key? key,
    required this.resourceType,
  }) : super(key: key);
  final ResourceType resourceType;

  @override
  Widget build(BuildContext context) {
    return TMDefaultBottomSheet(
      initialChildSize: 0.55,
      minChildSize: 0.3,
      child: BlocBuilder<ResourceCubit, ResourceState>(
        builder: (context, state) {
          return state.maybeWhen(
            loaded: (resources) {
              final resource = resources[resourceType];
              if (resource is! PrimaryResource) {
                return const NoneWidget();
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      resource.type.resourceName,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    verticalBigSpacer,
                    Image(
                      image: resource.type.resourceImage,
                      width: constants.AppConstants.bottomSheetImageSize,
                    ),
                    verticalBigSpacer,
                    EditValueWidget(
                      value: resource.stock,
                      onValueChanged: _onStockChanged,
                      textStyle: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    EditValueWidget(
                      value: resource.production,
                      onValueChanged: _onProductionChanged,
                      textStyle: TextStyle(
                        color: Colors.brown,
                        fontSize: 22,
                      ),
                    ),
                    CategorySeparatorWidget(text: 'History'),
                    if (resource.stockHistory.isNotEmpty)
                      ResourceHistoryWidget(
                        label: 'Stock',
                        history: resource.stockHistory,
                      ),
                    if (resource.productionHistory.isNotEmpty)
                      ResourceHistoryWidget(
                        label: 'Production',
                        history: resource.productionHistory,
                        textStyle: TextStyle(color: Colors.brown),
                      ),
                  ],
                ),
              );
            },
            orElse: () => const NoneWidget(),
          );
        },
      ),
    );
  }

  void _onStockChanged(int value) {
    sl<ResourceCubit>().modifyStock(resourceType, value);
  }

  void _onProductionChanged(int value) {
    sl<ResourceCubit>().modifyProduction(resourceType, value);
  }
}
