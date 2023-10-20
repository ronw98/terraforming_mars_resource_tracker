import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/presentation/extension/resource_type_extension.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';

class ResourceMinimalDisplay extends StatelessWidget {
  const ResourceMinimalDisplay({
    required this.resource,
    Key? key,
  }) : super(key: key);

  final Resource resource;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: 15);

    final resource = this.resource;
    final resourceType = resource.type;
    return switch (resource) {
      TerraformingRating() => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: resourceType.resourceImage,
              height: 40,
            ),
            horizontalSmallSpacer,
            Text(resource.stock.toString(), style: style)
          ],
        ),
      PrimaryResource() => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(image: resourceType.resourceImage, height: 40),
            horizontalSmallSpacer,
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  resource.stock.toString(),
                  style: style,
                ),
                Text(
                  resource.production.toString(),
                  style: style.copyWith(color: Colors.brown),
                ),
              ],
            ),
          ],
        ),
    };
  }
}
