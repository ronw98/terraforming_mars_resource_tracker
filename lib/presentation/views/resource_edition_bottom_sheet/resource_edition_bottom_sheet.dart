import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/constants.dart' as constants;
import 'package:tm_ressource_tracker/core/injection.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/domain/usecases/resource_use_cases.dart';
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
    required this.resourceType,
    Key? key,
  }) : super(key: key);
  final ResourceType resourceType;

  @override
  State<ResourceEditionBottomSheet> createState() =>
      _ResourceEditionBottomSheetState();
}

class _ResourceEditionBottomSheetState extends State<ResourceEditionBottomSheet>
    with SingleTickerProviderStateMixin {
  late final ValueNotifier<int> stockChange = ValueNotifier(0);
  late final ValueNotifier<int> prodChange = ValueNotifier(0);
  late final AnimationController _animationController;
  Animation<int>? _stockAnimation;
  Animation<int>? _prodAnimation;
  bool lock = false;

  @override
  void dispose() {
    stockChange.dispose();
    prodChange.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(
        () {
          final sa = _stockAnimation;
          if (sa != null) {
            stockChange.value = sa.value;
          }
          final pa = _prodAnimation;
          if (pa != null) {
            prodChange.value = pa.value;
          }
          if (_animationController.isCompleted) {
            _stockAnimation = null;
            _prodAnimation = null;
            lock = false;
            if (mounted) {
              Navigator.pop(context);
            }
          }
        },
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConfigBuilder(
      builder: (config) {
        return TMDefaultBottomSheet(
          initialChildSize: 0.55,
          minChildSize: 0.3,
          bottomChild: EditionConfirmButton(onPressed: _onConfirmPressed),
          child: BlocBuilder<LocalGameCubit, LocalGameState>(
            builder: (context, state) {
              return SafeArea(
                child: state.maybeWhen(
                  loaded: (gameState) {
                    final resource = serviceLocator<ResourceFromType>()(
                      gameState.resources,
                      widget.resourceType,
                    );
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
                          CategorySeparatorWidget(
                            text: LocaleKeys.resources.edition.stock
                                .translate(context),
                          ),
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
                            textStyle: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                          CategorySeparatorWidget(
                            text: LocaleKeys.resources.edition.production
                                .translate(context),
                          ),
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
      },
    );
  }

  void _onConfirmPressed() {
    if (lock) {
      return;
    }
    HapticFeedback.vibrate();
    context.read<LocalGameCubit>().addStockOrProduction(
          resourceType: widget.resourceType,
          stockChange: stockChange.value,
          productionChange: prodChange.value,
        );
    if(prodChange.value == 0 && stockChange.value == 0 && mounted) {
      Navigator.pop(context);
      return;
    }

    _prodAnimation =
        IntTween(begin: prodChange.value, end: 0).animate(_animationController);
    _stockAnimation = IntTween(begin: stockChange.value, end: 0)
        .animate(_animationController);

    _animationController.reset();
    _animationController.forward();
    lock = true;
  }

  void _onStockChanged(int value) {
    if (!lock) stockChange.value += value;
  }

  void _onNewStockChange(int value) {
    if (!lock) stockChange.value = value;
  }

  void _onProductionChanged(int value) {
    if (!lock) prodChange.value += value;
  }

  void _onNewProdChange(int value) {
    if (!lock) prodChange.value = value;
  }
}
