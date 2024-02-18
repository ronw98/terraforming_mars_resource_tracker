import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/assets.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/presentation/extension/resource_type_extension.dart';

class ProductionWidget extends StatelessWidget {
  const ProductionWidget({
    required this.type,
    Key? key,
  }) : super(key: key);

  final ResourceType type;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image: Images.production,
              fit: BoxFit.fill,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: FractionallySizedBox(
              heightFactor: 0.82,
              widthFactor: 0.85,
              child: Image(image: type.resourceImage),
            ),
          ),
        ],
      ),
    );
  }
}
