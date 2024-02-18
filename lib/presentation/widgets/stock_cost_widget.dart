import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/assets.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/presentation/extension/resource_type_extension.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';

class StockCostWidget extends StatelessWidget {
  const StockCostWidget({
    required this.type,
    required this.value,
    Key? key,
  }) : super(key: key);

  final ResourceType type;
  final int value;

  @override
  Widget build(BuildContext context) {
    return type == ResourceType.credits
        ? CreditStockCost(value: value)
        : NonCreditStockCost(
            type: type,
            value: value,
          );
  }
}

class CreditStockCost extends StatelessWidget {
  const CreditStockCost({required this.value, Key? key}) : super(key: key);

  final int value;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(image: Images.creditsBg, fit: BoxFit.fitHeight),
        Positioned.fill(
          child: Align(
            child: FractionallySizedBox(
              widthFactor: 0.65,
              child: AutoSizeText(
                '$value',
                textAlign: TextAlign.center,
                maxLines: 1,
                minFontSize: 8,
                maxFontSize: 30,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NonCreditStockCost extends StatelessWidget {
  const NonCreditStockCost({required this.type, required this.value, Key? key})
      : super(key: key);

  final ResourceType type;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (value != 1) ...[
          Text('$value'),
          horizontalSpacer,
        ],
        Image(image: type.resourceImage),
      ],
    );
  }
}
