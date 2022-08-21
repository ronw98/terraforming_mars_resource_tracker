import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/assets.dart';
import 'package:tm_ressource_tracker/constants.dart';
import 'package:tm_ressource_tracker/domain/entities/standard_project.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/widgets/cost_resource_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/custom_card.dart';

class StandardProjectWidget extends StatelessWidget {
  const StandardProjectWidget({
    Key? key,
    required this.project,
  }) : super(key: key);

  final StandardProject project;

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
                      height: AppConstants.standardProjectItemSize,
                      child: CostResourceWidget(resource: costPart),
                    ),
                  ],
                ],
              ),
            ),
            horizontalBigSpacer,
            Image(
              image: Images.arrow,
              width: AppConstants.standardProjectItemSize,
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
                      height: AppConstants.standardProjectItemSize,
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
