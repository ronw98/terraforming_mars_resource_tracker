import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/constants.dart';

class NumberedResource extends StatelessWidget {
  const NumberedResource({
    required this.resource,
    required this.value,
  });

  final Resource resource;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        const SizedBox(width: 5,),
        Image.asset(
          AppConstants.numbered_resource_path_map[resource]!,
          width: AppConstants.image_numbered_resource_size,
        ),
      ],
    );
  }
}
