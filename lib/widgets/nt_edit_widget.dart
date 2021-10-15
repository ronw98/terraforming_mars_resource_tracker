import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/bloc/resource_bloc.dart';
import 'package:tm_ressource_tracker/constants.dart';
import 'package:tm_ressource_tracker/entities/resource_entity.dart';

import 'custom_card.dart';
import 'edit_value_button.dart';

class NTWidget extends StatefulWidget {
  NTWidget({
    required this.name,
    required this.entity,
    this.stockThreshold = 0,
  });

  final String name;
  final ResourceEntity entity;
  final int stockThreshold;

  @override
  State<StatefulWidget> createState() => _NTWidgetState();
}

class _NTWidgetState extends State<NTWidget> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: 176,
      child: CustomCard(
        borderColors: [
          Colors.white,
          Colors.grey,
          Colors.black,
        ],
        borderWidth: 3,
        backgroundColor: Color.fromARGB(200, 220, 220, 220),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/terraformRating.png',
                width: screenWidth / AppConstants.image_big_size_divider,
              ),
              const SizedBox(height: 5),
              Text(
                '${widget.entity.stock}',
                style: TextStyle(
                  fontSize: screenWidth / AppConstants.stock_font_size_divider,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EditValueButton(
                    onPressed: () => onValueChanged(context, -1),
                    text: '-1',
                  ),
                  EditValueButton(
                    onPressed: () => onValueChanged(context, 1),
                    text: '+1',
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void onValueChanged(BuildContext context, int modification) {
    BlocProvider.of<ResourceBloc>(context).add(
      ResourceChanged(
        stock: widget.entity.stock + modification,
      ),
    );
  }
}
