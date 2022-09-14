import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/constants.dart' as constants;
import 'package:tm_ressource_tracker/core/injection.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/jsons.dart';
import 'package:tm_ressource_tracker/presentation/builders/config_builder.dart';
import 'package:tm_ressource_tracker/presentation/extension/resource_type_extension.dart';
import 'package:tm_ressource_tracker/presentation/extension/string_extension.dart';
import 'package:tm_ressource_tracker/presentation/managers/resource_cubit.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/views/resource_edition_bottom_sheet/confirm_button.dart';
import 'package:tm_ressource_tracker/presentation/views/resource_edition_bottom_sheet/edition_text.dart';
import 'package:tm_ressource_tracker/presentation/views/tm_default_bottom_sheet.dart';
import 'package:tm_ressource_tracker/presentation/widgets/category_separator_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/edit_value_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/none_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/resource_history_widget.dart';

class ResourceEditionBottomSheet extends StatefulWidget {
  const ResourceEditionBottomSheet({
    Key? key,
    required this.resourceType,
  }) : super(key: key);
  final ResourceType resourceType;

  @override
  State<ResourceEditionBottomSheet> createState() =>
      _ResourceEditionBottomSheetState();
}

class _ResourceEditionBottomSheetState
    extends State<ResourceEditionBottomSheet> {
  late final ValueNotifier<int> stockChange = ValueNotifier(0);
  late final ValueNotifier<int> prodChange = ValueNotifier(0);

  @override
  void dispose() {
    stockChange.dispose();
    prodChange.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConfigBuilder(builder: (config) {
      return TMDefaultBottomSheet(
        initialChildSize: 0.55,
        minChildSize: 0.3,
        bottomChild: EditionConfirmButton(onPressed: _onConfirmPressed),
        child: BlocBuilder<ResourceCubit, ResourceState>(
          builder: (context, state) {
            return SafeArea(
              child: state.maybeWhen(
                loaded: (resources) {
                  final resource = resources[widget.resourceType];
                  if (resource is! PrimaryResource) {
                    return const NoneWidget();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          resource.type.resourceKey.translate(context),
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        verticalBigSpacer,
                        Image(
                          image: resource.type.resourceImage,
                          width: constants.AppConstants.bottomSheetImageSize,
                        ),
                        verticalBigSpacer,
                        ValueListenableBuilder<int>(
                          valueListenable: stockChange,
                          builder: (context, value, child) {
                            if (value != 0 ||
                                config.settings.editValuesWithText) {
                              return EditionText(
                                value: value,
                                onValueChanged: _onNewStockChange,
                              );
                            }
                            return const NoneWidget();
                          },
                        ),
                        EditValueWidget(
                          value: resource.stock,
                          onValueChanged: _onStockChanged,
                          editable: false,
                          textStyle: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                        Divider(),
                        ValueListenableBuilder<int>(
                          valueListenable: prodChange,
                          builder: (context, value, child) {
                            if (value != 0 ||
                                config.settings.editValuesWithText) {
                              return EditionText(
                                value: value,
                                onValueChanged: _onNewProdChange,
                                textColor: Colors.brown,
                              );
                            }
                            return const NoneWidget();
                          },
                        ),
                        EditValueWidget(
                          value: resource.production,
                          onValueChanged: _onProductionChanged,
                          textStyle: TextStyle(
                            color: Colors.brown,
                            fontSize: 22,
                          ),
                        ),
                        CategorySeparatorWidget(
                          text: LocaleKeys.resources.history.title
                              .translate(context),
                        ),
                        if (resource.stockHistory.isNotEmpty)
                          ResourceHistoryWidget(
                            label: LocaleKeys.resources.history.stock
                                .translate(context),
                            history: resource.stockHistory,
                          ),
                        if (resource.productionHistory.isNotEmpty)
                          ResourceHistoryWidget(
                            label: LocaleKeys.resources.history.production
                                .translate(context),
                            history: resource.productionHistory,
                            textStyle: TextStyle(color: Colors.brown),
                          ),
                      ],
                    ),
                  );
                },
                orElse: () => const NoneWidget(),
              ),
            );
          },
        ),
      );
    });
  }

  void _onConfirmPressed() {
    sl<ResourceCubit>().addStock(widget.resourceType, stockChange.value);
    sl<ResourceCubit>().addProduction(widget.resourceType, prodChange.value);

    stockChange.value = 0;
    prodChange.value = 0;
  }

  void _onStockChanged(int value) {
    stockChange.value += value;
  }

  void _onNewStockChange(int value) {
    stockChange.value = value;
  }

  void _onProductionChanged(int value) {
    prodChange.value += value;
  }

  void _onNewProdChange(int value) {
    prodChange.value = value;
  }
}
