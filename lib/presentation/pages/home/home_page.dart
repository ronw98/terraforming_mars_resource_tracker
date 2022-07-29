import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/presentation/pages/home/home_content.dart';
import 'package:tm_ressource_tracker/presentation/pages/settings/settings_page.dart';
import 'package:tm_ressource_tracker/presentation/widgets/circle_icon_button.dart';
import 'package:tm_ressource_tracker/presentation/widgets/tm_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: SweepGradient(
          center: Alignment.bottomCenter,
          startAngle: 0,
          endAngle: 3.1415 / 4,
          tileMode: TileMode.mirror,
          colors: [
            Color.fromARGB(255, 108, 64, 38),
            Color.fromARGB(255, 84, 56, 40),
            Color.fromARGB(255, 110, 60, 32),
            Color.fromARGB(255, 140, 80, 38),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: TMAppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ShapeIconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SettingsPage(),
                    ),
                  );
                },
                icon: Icon(Icons.settings),
                semanticsLabel: 'Settings',
              ),
            ),
          ],
          title: 'TM Calculator',
        ),
        body: SafeArea(
          child: HomeContent(),
        ),
      ),
    );
  }
}
