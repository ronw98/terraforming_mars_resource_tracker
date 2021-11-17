import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WebMobilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("This website is really not made for mobiles"),
          Row(
            children: [
              ElevatedButton.icon(icon: Text(
                "Do",
                style: Theme.of(context).textTheme.caption,
              ),onPressed: () {}, label: Text("Get mobile app")),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Text(
                  "Don't",
                  style: Theme.of(context).textTheme.caption,
                ),
                label: Text("Continue to website"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
