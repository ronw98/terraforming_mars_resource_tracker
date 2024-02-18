import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/jsons.dart';
import 'package:tm_ressource_tracker/presentation/extension/locales_ext.dart';
import 'package:tm_ressource_tracker/presentation/tabs/current_game/current_game_tab.dart';
import 'package:tm_ressource_tracker/presentation/tabs/resources_tab.dart';
import 'package:tm_ressource_tracker/presentation/tabs/standard_projects_tab.dart';
import 'package:tm_ressource_tracker/presentation/widgets/tab_item.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverToBoxAdapter(
                child: TabBar(
                  tabs: [
                    TabItem(
                      widthFactor: 0.3,
                      text: LocaleKeys.home.tabs.resources().translate(context),
                    ),
                    TabItem(
                      widthFactor: 0.3,
                      text: LocaleKeys.home.tabs.projects().translate(context),
                    ),
                    TabItem(
                      widthFactor: 0.3,
                      text: LocaleKeys.home.tabs
                          .current_game()
                          .translate(context),
                    ),
                  ],
                  isScrollable: true,
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          children: [
            ResourcesTab(),
            StandardProjectsTab(),
            CurrentGameTab(),
          ],
        ),
      ),
    );
  }
}
