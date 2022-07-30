import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/assets.dart';
import 'package:tm_ressource_tracker/constants.dart';
import 'package:tm_ressource_tracker/domain/entities/special_project.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/widgets/cost_resource_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/custom_card.dart';

class SpecialProjectWidget extends StatelessWidget {
  const SpecialProjectWidget({
    Key? key,
    required this.project,
  }) : super(key: key);

  final SpecialProject project;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Wrap(
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: defaultPadding,
                spacing: bigPadding,
                children: [
                  for (final costPart in project.cost) ...[
                    SizedBox(
                      height: AppConstants.specialProjectItemSize,
                      child: CostResourceWidget(resource: costPart),
                    ),
                  ],
                ],
              ),
            ),
            horizontalBigSpacer,
            Image(
              image: Images.arrow,
              width: AppConstants.specialProjectItemSize,
            ),
            horizontalBigSpacer,
            Flexible(
              child: Wrap(
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: defaultPadding,
                spacing: bigPadding,
                children: [
                  for (final costPart in project.reward) ...[
                    SizedBox(
                      height: AppConstants.specialProjectItemSize,
                      child: CostResourceWidget(resource: costPart),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
