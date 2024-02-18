import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/widgets/custom_card.dart';

class ResourceHistoryWidget extends StatelessWidget {
  const ResourceHistoryWidget({
    required this.history,
    required this.label,
    Key? key,
    this.textStyle,
  }) : super(key: key);
  final List<HistoryItem> history;
  final TextStyle? textStyle;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label),
        horizontalSpacer,
        Expanded(
          child: CustomCard(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: history.map(
                  (item) {
                    return [
                      Container(
                        decoration: item.isProductionPhase
                            ? BoxDecoration(
                                color: Color(0xFFfbb800),
                              )
                            : BoxDecoration(),
                        padding: EdgeInsets.all(1),
                        child: Text('${item.value}', style: textStyle),
                      ),
                      horizontalSpacer,
                    ];
                  },
                ).fold(
                  [],
                  (previousValue, element) => previousValue..addAll(element),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
