import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/domain/entities/user_resources.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/widgets/custom_card.dart';
import 'package:tm_ressource_tracker/presentation/widgets/resource_minimal_display.dart';

class UserResourcesWidget extends StatelessWidget {
  const UserResourcesWidget({
    Key? key,
    required this.userResources,
  }) : super(key: key);

  final UserResources userResources;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userResources.userName),
            verticalBigSpacer,
            Wrap(
              alignment: WrapAlignment.center,
              spacing: bigPadding,
              runSpacing: smallPadding,
              children: ResourceType.values
                  .map(
                    (type) => ResourceMinimalDisplay(
                      resource: userResources.resources[type]!,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
