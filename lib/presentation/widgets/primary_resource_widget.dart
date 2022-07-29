import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/presentation/extension/resource_type_extension.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/widgets/custom_card.dart';

class PrimaryResourceWidget extends StatelessWidget {
  const PrimaryResourceWidget({
    Key? key,
    required this.type,
    required this.stock,
    required this.production,
    required this.stockHistory,
    required this.productionHistory,
  }) : super(key: key);

  final ResourceType type;
  final int stock;
  final int production;
  final List<int> stockHistory;
  final List<int> productionHistory;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: type.resourceName,
      child: CustomCard(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Image(
                          image: type.resourceImage,
                          width: 50,
                        ),
                        verticalSpacer,
                        Tooltip(
                          message: '${type.resourceName} stock is $stock',
                          child: Text(
                            '$stock',
                          ),
                        ),
                        Tooltip(
                          message:
                              '${type.resourceName} production is $production',
                          child: Text(
                            '$production',
                            style: TextStyle(color: Colors.brown),
                          ),
                        ),
                      ],
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
