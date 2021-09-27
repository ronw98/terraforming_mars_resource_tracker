import 'package:flutter/material.dart';

class ProjectWidget extends StatelessWidget {
  ProjectWidget({required this.name, required this.price, required this.unit, this.onTap,});
  final String name;
  final int price;
  final String unit;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(name),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$price',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      unit,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
