import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/assets.dart';
import 'package:tm_ressource_tracker/core/injection.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/jsons.dart';
import 'package:tm_ressource_tracker/presentation/extension/string_extension.dart';
import 'package:tm_ressource_tracker/presentation/managers/resource_cubit.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/widgets/custom_card.dart';
import 'package:tm_ressource_tracker/presentation/widgets/edit_value_button.dart';
import 'package:tm_ressource_tracker/presentation/widgets/text_editable_value.dart';

class TerraformingRatingWidget extends StatelessWidget {
  const TerraformingRatingWidget({
    Key? key,
    required this.stock,
    required this.stockHistory,
  }) : super(key: key);

  final int stock;
  final List<int> stockHistory;

  @override
  Widget build(BuildContext context) {
    final label =
        LocaleKeys.resources.names.terraforming_rating.translate(context);
    return Tooltip(
      message: label,
      child: CustomCard(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(label),
              verticalSpacer,
              Image(
                image: Images.terraformRating,
                width: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Tooltip(
                    message: LocaleKeys
                        .resources.tooltips.terraforming_rating.remove
                        .translate(
                      context,
                      translationParams: {'value': '1'},
                    ),
                    child: EditValueButton(
                      text: '-1',
                      onPressed: () {
                        sl<ResourceCubit>().modifyStock(
                          ResourceType.terraformingRating,
                          stock - 1,
                        );
                      },
                    ),
                  ),
                  horizontalBigSpacer,
                  Tooltip(
                    message: LocaleKeys
                        .resources.tooltips.terraforming_rating.current
                        .translate(
                      context,
                      translationParams: {'value': '$stock'},
                    ),
                    child: TextEditableValue(
                      value: stock,
                      editable: true,
                      style: TextStyle(fontSize: 20),
                      onValueChanged: (newValue) {
                        BlocProvider.of<ResourceCubit>(context).modifyStock(
                          ResourceType.terraformingRating,
                          newValue,
                        );
                      },
                    ),
                  ),
                  horizontalBigSpacer,
                  Tooltip(
                    message: LocaleKeys
                        .resources.tooltips.terraforming_rating.add
                        .translate(
                      context,
                      translationParams: {'value': '1'},
                    ),
                    child: EditValueButton(
                      text: '+1',
                      onPressed: () {
                        sl<ResourceCubit>().modifyStock(
                          ResourceType.terraformingRating,
                          stock + 1,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
