import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/widgets/platform_widget.dart';

void main() {
  runApp(ResourceTracker());
}

class ResourceTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PlatformWidget(),
      theme: ThemeData(fontFamily: 'Enter Sansman'),
    );
  }
}
