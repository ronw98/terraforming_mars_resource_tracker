import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/pages/home_page.dart';

void main() {
  runApp(ResourceTracker());
}

class ResourceTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(fontFamily: 'Enter Sansman'),
    );
  }
}
