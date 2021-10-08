import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/widgets/credit_cost_widget.dart';
import 'package:tm_ressource_tracker/widgets/numbered_resource_widget.dart';

import '../constants.dart';
import 'custom_card.dart';

class ProjectWidget extends StatelessWidget {
  ProjectWidget({
    required this.name,
    required this.price,
    required this.resource,
    required this.reward,
    this.onTap,
  });

  final String name;
  final int price;
  final Resource resource;
  final Function()? onTap;
  final List<Widget> reward;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: CustomCard(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    resource == Resource.CREDITS
                        ? CreditCostWidget(value: price)
                        : NumberedResource(
                            resource: resource,
                            value: price,
                          ),
                    const SizedBox(width: 5,),
                    Image.asset('assets/images/arrow.png', width: 30,),
                    const SizedBox(width: 5,),
                    ...reward,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
