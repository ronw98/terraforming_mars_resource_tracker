import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/domain/entities/cost_resource.dart';
import 'package:tm_ressource_tracker/presentation/extension/marker_type_extension.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';

class MarkerCostWidget extends StatelessWidget {
  const MarkerCostWidget({
    Key? key,
    required this.type,
    required this.value,
  }) : super(key: key);

  final MarkerType type;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (value != 1) ...[
          Text('$value'),
          horizontalSmallSpacer,
        ],
        Image(image: type.markerImage)
      ],
    );
  }
}
