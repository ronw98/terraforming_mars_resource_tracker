import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/constants.dart';

class CreditCostWidget extends StatelessWidget {
  const CreditCostWidget({
    required this.value,
    required this.size,
  });

  final int value;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          AppConstants.numbered_resource_path_map[Resource.CREDITS]!,
          height: size,
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 0.4*size,
              ),
            ),
          ),
        ),
      ],
    );
  }
}