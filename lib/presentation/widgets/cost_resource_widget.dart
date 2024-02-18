import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/domain/entities/cost_resource.dart';
import 'package:tm_ressource_tracker/presentation/widgets/marker_cost_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/production_cost_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/stock_cost_widget.dart';

class CostResourceWidget extends StatelessWidget {
  const CostResourceWidget({required this.resource, Key? key})
      : super(key: key);

  final CostResource resource;

  @override
  Widget build(BuildContext context) {
    return resource.when(
      stock: (value, type) => StockCostWidget(
        type: type,
        value: value,
      ),
      production: (value, type) => ProductionCostWidget(
        value: value,
        type: type,
      ),
      marker: (value, type) => MarkerCostWidget(
        type: type,
        value: value,
      ),
    );
  }
}
