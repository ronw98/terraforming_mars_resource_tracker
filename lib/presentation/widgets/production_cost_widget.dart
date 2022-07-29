import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/assets.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/presentation/widgets/stock_cost_widget.dart';

class ProductionCostWidget extends StatelessWidget {
  const ProductionCostWidget({
    Key? key,
    required this.value,
    required this.type,
  }) : super(key: key);

  final int value;
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
              child: StockCostWidget(value: value, type: type),
            ),
          ),
        ],
      ),
    );
  }
}
