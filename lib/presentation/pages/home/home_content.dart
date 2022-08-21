import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/presentation/tabs/resources_tab.dart';
import 'package:tm_ressource_tracker/presentation/tabs/standard_projects_tab.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverToBoxAdapter(
                child: TabBar(
                  tabs: [
                    Tab(text: 'Resources'),
                    Tab(text: 'Standard projects',)
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          children: [
            ResourcesTab(),
            StandardProjectsTab(),
          ],
        ),
      ),
    );
  }
}
