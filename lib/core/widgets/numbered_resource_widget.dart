import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/constants.dart';

class NumberedResource extends StatelessWidget {
  const NumberedResource({
    required this.resource,
    required this.value,
    required this.size,
  });

  final Resource resource;
  final int value;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontSize: size/2,
          ),
        ),
        const SizedBox(width: 5,),
        Image.asset(
          AppConstants.numbered_resource_path_map[resource]!,
          width: size,
        ),
      ],
    );
  }
}
