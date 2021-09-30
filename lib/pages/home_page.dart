import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_ressource_tracker/bloc/resource_bloc.dart';
import 'package:tm_ressource_tracker/entities/resource_entity.dart';
import 'package:tm_ressource_tracker/widgets/credit_cost_widget.dart';
import 'package:tm_ressource_tracker/widgets/nt_edit_widget.dart';
import 'package:tm_ressource_tracker/widgets/project_widget.dart';
import 'package:tm_ressource_tracker/widgets/resource_widget.dart';
import 'package:tm_ressource_tracker/widgets/settings_dialog_widget.dart';

import '../constants.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ResourceBloc _creditsBloc;
  late ResourceBloc _steelBloc;
  late ResourceBloc _titaniumBloc;
  late ResourceBloc _plantBloc;
  late ResourceBloc _energyBloc;
  late ResourceBloc _ntBloc;
  late ResourceBloc _heatBloc;
  bool _turmoilSelected = false;
  int _generation_number = 1;

  @override
  void initState() {
    _steelBloc = ResourceBloc(sharedPrefsKey: AppConstants.prefs_steel);
    _creditsBloc = ResourceBloc(sharedPrefsKey: AppConstants.prefs_credit);
    _titaniumBloc = ResourceBloc(sharedPrefsKey: AppConstants.prefs_titanium);
    _energyBloc = ResourceBloc(sharedPrefsKey: AppConstants.prefs_energy);
    _plantBloc = ResourceBloc(sharedPrefsKey: AppConstants.prefs_plant);
    _ntBloc = ResourceBloc(sharedPrefsKey: AppConstants.prefs_nt);
    _heatBloc = ResourceBloc(sharedPrefsKey: AppConstants.prefs_heat);

    _getFromPreferences<String>(AppConstants.prefs_nt)
        .then((value) {
      if(value != null) {
        _loadJsonStringToBloc(value, _ntBloc);
      }
      else {
        _ntBloc.add(StockAdded(20));
      }
    });
    _getFromPreferences<String>(AppConstants.prefs_credit)
        .then((value) {
      if(value != null) {
        _loadJsonStringToBloc(value, _creditsBloc);
      }
    });
    _getFromPreferences<String>(AppConstants.prefs_plant)
        .then((value) {
      if(value != null) {
        _loadJsonStringToBloc(value, _plantBloc);
      }
    });
    _getFromPreferences<String>(AppConstants.prefs_steel)
        .then((value) {
      if(value != null) {
        _loadJsonStringToBloc(value, _steelBloc);
      }
    });
    _getFromPreferences<String>(AppConstants.prefs_titanium)
        .then((value) {
      if(value != null) {
        _loadJsonStringToBloc(value, _titaniumBloc);
      }
    });
    _getFromPreferences<String>(AppConstants.prefs_energy)
        .then((value) {
      if(value != null) {
        _loadJsonStringToBloc(value, _energyBloc);
      }
    });
    _getFromPreferences<String>(AppConstants.prefs_heat)
        .then((value) {
      if(value != null) {
        _loadJsonStringToBloc(value, _heatBloc);
      }
    });

    _getFromPreferences<int>(AppConstants.prefs_gen).then((value) {
      if(value != null) {
        setState(() {
          _generation_number = value;
        });
      }
    });

    _getFromPreferences<bool>(AppConstants.prefs_turmoil).then((value) {
      if(value != null) {
        setState(() {
          _turmoilSelected = value;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TM Tracker',
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
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 0,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _onSettingsPressed();
                  },
                  child: Text('Paramètres'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      BlocProvider(
                        create: (context) => _ntBloc,
                        child: BlocBuilder<ResourceBloc, ResourceState>(
                          bloc: _ntBloc,
                          builder: (context, state) {
                            return Expanded(
                              child: NTWidget(
                                name: 'NT',
                                entity: state.resource,
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        children: [
                          BlocProvider(
                            create: (context) => _creditsBloc,
                            child: BlocBuilder<ResourceBloc, ResourceState>(
                              bloc: _creditsBloc,
                              builder: (context, state) {
                                return ResourceWidget(
                                  iconPath: 'assets/images/credits.png',
                                  entity: state.resource,
                                  prodThreshold: -5,
                                );
                              },
                            ),
                          ),
                          BlocProvider(
                            create: (context) => _plantBloc,
                            child: BlocBuilder<ResourceBloc, ResourceState>(
                              bloc: _plantBloc,
                              builder: (context, state) {
                                return ResourceWidget(
                                  iconPath: 'assets/images/plants.png',
                                  entity: state.resource,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          BlocProvider(
                            create: (context) => _steelBloc,
                            child: BlocBuilder<ResourceBloc, ResourceState>(
                              bloc: _steelBloc,
                              builder: (context, state) {
                                return ResourceWidget(
                                  iconPath: 'assets/images/steel.png',
                                  entity: state.resource,
                                );
                              },
                            ),
                          ),
                          BlocProvider(
                            create: (context) => _titaniumBloc,
                            child: BlocBuilder<ResourceBloc, ResourceState>(
                              bloc: _titaniumBloc,
                              builder: (context, state) {
                                return ResourceWidget(
                                  iconPath: 'assets/images/titanium.png',
                                  entity: state.resource,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          BlocProvider(
                            create: (context) => _energyBloc,
                            child: BlocBuilder<ResourceBloc, ResourceState>(
                              bloc: _energyBloc,
                              builder: (context, state) {
                                return ResourceWidget(
                                  iconPath: 'assets/images/energy.png',
                                  entity: state.resource,
                                );
                              },
                            ),
                          ),
                          BlocProvider(
                            create: (context) => _heatBloc,
                            child: BlocBuilder<ResourceBloc, ResourceState>(
                              bloc: _heatBloc,
                              builder: (context, state) {
                                return ResourceWidget(
                                  iconPath: 'assets/images/heat.png',
                                  entity: state.resource,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: IntrinsicWidth(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ProjectWidget(
                            name: 'Forêt',
                            price: 23,
                            resource: Resource.CREDITS,
                            onTap: () => _creditsBloc.add(StockAdded(-23)),
                            reward: [
                              Image.asset(
                                'assets/images/greenery.png',
                                height:
                                    AppConstants.image_numbered_resource_size +
                                        10,
                              ),
                            ],
                          ),
                          ProjectWidget(
                            name: 'Ville',
                            price: 25,
                            resource: Resource.CREDITS,
                            onTap: () {
                              _creditsBloc.add(ProductionAdded(1));
                              _creditsBloc.add(StockAdded(-25));
                            },
                            reward: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/city.png',
                                    height: AppConstants
                                            .image_numbered_resource_size +
                                        10,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/production.png',
                                        height: AppConstants
                                                .image_numbered_resource_size +
                                            5,
                                      ),
                                      CreditCostWidget(
                                        value: 1,
                                        size: AppConstants
                                                .image_numbered_resource_size -
                                            5,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          ProjectWidget(
                            name: 'Océan',
                            price: 18,
                            resource: Resource.CREDITS,
                            onTap: () {
                              _creditsBloc.add(StockAdded(-18));
                            },
                            reward: [
                              Image.asset(
                                'assets/images/ocean.png',
                                height:
                                    AppConstants.image_numbered_resource_size +
                                        10,
                              ),
                            ],
                          ),
                          ProjectWidget(
                            name: 'Centrale',
                            price: 11,
                            resource: Resource.CREDITS,
                            onTap: () {
                              _energyBloc.add(ProductionAdded(1));
                              _creditsBloc.add(StockAdded(-11));
                            },
                            reward: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/production.png',
                                    height: AppConstants
                                            .image_numbered_resource_size +
                                        5,
                                  ),
                                  Image.asset('assets/images/energy.png',
                                      height: AppConstants
                                              .image_numbered_resource_size -
                                          5),
                                ],
                              ),
                            ],
                          ),
                          ProjectWidget(
                            name: 'Temperature',
                            price: 14,
                            resource: Resource.CREDITS,
                            onTap: () {
                              _creditsBloc.add(StockAdded(-14));
                            },
                            reward: [
                              Image.asset(
                                'assets/images/temperature.png',
                                height:
                                    AppConstants.image_numbered_resource_size +
                                        10,
                              ),
                            ],
                          ),
                          Visibility(
                            visible: _turmoilSelected,
                            child: ProjectWidget(
                              name: 'Lobby',
                              price: 5,
                              resource: Resource.CREDITS,
                              reward: [
                                Image.asset(
                                  'assets/images/delegate.png',
                                  height: AppConstants
                                          .image_numbered_resource_size -
                                      10,
                                ),
                              ],
                              onTap: () => _creditsBloc.add(StockAdded(-5)),
                            ),
                          ),
                          ProjectWidget(
                            name: 'Temperature',
                            price: 8,
                            resource: Resource.HEAT,
                            onTap: () => _heatBloc.add(StockAdded(-8)),
                            reward: [
                              Image.asset(
                                'assets/images/temperature.png',
                                height:
                                    AppConstants.image_numbered_resource_size +
                                        10,
                              ),
                            ],
                          ),
                          ProjectWidget(
                            name: 'Forêt',
                            price: 8,
                            resource: Resource.PLANT,
                            onTap: () {
                              _plantBloc.add(StockAdded(-8));
                            },
                            reward: [
                              Image.asset(
                                'assets/images/greenery.png',
                                height:
                                    AppConstants.image_numbered_resource_size +
                                        10,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _onGenerateTap,
                    child: Text(
                      'Generate',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.indigo,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _heatBloc.close();
    _ntBloc.close();
    _creditsBloc.close();
    _energyBloc.close();
    _plantBloc.close();
    _titaniumBloc.close();
    _steelBloc.close();
    super.dispose();
  }

  void _onGenerateTap() async {
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
    prefs.setInt(AppConstants.prefs_gen, _generation_number+1);
    setState(() {
      _generation_number++;
    });
  }

  void _onResetTap() async {
    final bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Voulez vous vraiment réinitialiser les données?"),
        actions: [
          TextButton(
            child: Text('Confirmer'),
            onPressed: () => Navigator.pop(context, true),
          ),
          TextButton(
            child: Text('Annuler'),
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
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
