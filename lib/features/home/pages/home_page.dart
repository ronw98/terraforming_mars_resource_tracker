import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_ressource_tracker/constants.dart';
import 'package:tm_ressource_tracker/core/widgets/confirm_dialog.dart';
import 'package:tm_ressource_tracker/core/widgets/custom_card.dart';
import 'package:tm_ressource_tracker/entities/resource_entity.dart';
import 'package:tm_ressource_tracker/features/home/widgets/project_list.dart';
import 'package:tm_ressource_tracker/features/home/widgets/resource_widgets.dart';
import 'package:tm_ressource_tracker/features/resource/bloc/resource_bloc.dart';
import 'package:tm_ressource_tracker/features/settings/widgets/settings_dialog_widget.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _turmoilSelected = false;
  int _generation_number = 1;

  @override
  void initState() {
    final ResourceBloc resourceBloc = BlocProvider.of<ResourceBloc>(context);
    _getFromPreferences<String>(AppConstants.prefs_nt).then((value) {
      if (value != null) {
        try {
          _loadJsonStringToBloc(value, resourceBloc);
        } catch (_) {
          // Version upgrade security
          resourceBloc.add(RestartEvent());
        }
      } else {
        resourceBloc.add(RestartEvent());
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              'TM Calculator',
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              TextButton(
                onPressed: null,
                child: Text(
                  'Gen #$_generation_number',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              PopupMenuButton(
                onSelected: (int value) {
                  if (value == 0) {
                    _onSettingsPressed();
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: 0,
                    child: CustomCard(
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Settings'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IntrinsicWidth(
                        child: ResourceWidgets(),
                      ),
                      Expanded(
                        child: IntrinsicWidth(
                          child: ProjectList(
                            showLobbyProject: _turmoilSelected,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: _onGenerateTap,
                          child: CustomCard(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'Produce!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onGenerateTap() async {
    final bool confirm = await showDialog(
        context: context,
        builder: (BuildContext context) => ConfirmDialog(
              text: 'Confirm production?',
              cancel: 'Cancel',
              confirm: 'Confirm',
            ));
    if (!confirm) {
      return;
    }
    BlocProvider.of<ResourceBloc>(context).add(ProduceEvent(turmoil: _turmoilSelected));
    _heatBloc.add(StockAdded(_energyBloc.state.resource.stock));
    _energyBloc.add(ResourceChanged(stock: 0));
    _creditsBloc.add(StockAdded(_ntBloc.state.resource.stock));
    _creditsBloc.add(ProduceEvent());
    _steelBloc.add(ProduceEvent());
    _titaniumBloc.add(ProduceEvent());
    _plantBloc.add(ProduceEvent());
    _energyBloc.add(ProduceEvent());
    _heatBloc.add(ProduceEvent());
    if (_turmoilSelected) {
      _ntBloc.add(StockAdded(-1));
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(AppConstants.prefs_gen, _generation_number + 1);
    setState(() {
      _generation_number++;
    });
  }

  void _onResetTap() async {
    final bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) => ConfirmDialog(
        text: 'Reset data?',
        cancel: 'Cancel',
        confirm: 'Confirm',
      ),
    );
    if (!confirm) {
      return;
    }
    _ntBloc.add(ResourceReset(stock: 20));
    _creditsBloc.add(ResourceReset());
    _plantBloc.add(ResourceReset());
    _steelBloc.add(ResourceReset());
    _titaniumBloc.add(ResourceReset());
    _heatBloc.add(ResourceReset());
    _energyBloc.add(ResourceReset());
    setState(() {
      _generation_number = 1;
    });
  }

  void _onSettingsPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) => SettingsDialog(
        onResetTap: _onResetTap,
        initialValue: _turmoilSelected,
        onTurmoilChanged: (bool newValue) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool(AppConstants.prefs_turmoil, newValue);
          setState(() {
            _turmoilSelected = newValue;
          });
        },
      ),
    );
  }

  Future<T?> _getFromPreferences<T>(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key) as T?;
  }

  void _loadJsonStringToBloc(String jsonString, ResourceBloc bloc) {
    final ResourceEntity entity =
        ResourceEntity.fromJson(json.decode(jsonString));
    bloc.add(ResourceChanged(
      stock: entity.stock,
      history: entity.history,
      production: entity.production,
    ));
  }
}
