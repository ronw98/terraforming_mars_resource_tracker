import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/bloc/resource_bloc.dart';
import 'package:tm_ressource_tracker/widgets/nt_edit_widget.dart';
import 'package:tm_ressource_tracker/widgets/project_widget.dart';
import 'package:tm_ressource_tracker/widgets/resource_widget.dart';

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

  @override
  void initState() {
    _steelBloc = ResourceBloc();
    _creditsBloc = ResourceBloc();
    _titaniumBloc = ResourceBloc();
    _energyBloc = ResourceBloc();
    _plantBloc = ResourceBloc();
    _ntBloc = ResourceBloc();
    _heatBloc = ResourceBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terraforming Mars Tracker'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                BlocProvider(
                  create: (context) => _ntBloc,
                  child: BlocBuilder<ResourceBloc, ResourceState>(
                    builder: (context, state) {
                      return Expanded(
                          child: NTWidget(name: 'NT', entity: state.resource));
                    },
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocProvider(
                  create: (context) => _creditsBloc,
                  child: BlocBuilder<ResourceBloc, ResourceState>(
                    bloc: _creditsBloc,
                    builder: (context, state) {
                      return Expanded(
                        child: ResourceWidget(
                          iconPath: 'assets/images/credits.png',
                          entity: state.resource,
                          prodThreshold: -5,
                        ),
                      );
                    },
                  ),
                ),
                BlocProvider(
                  create: (context) => _plantBloc,
                  child: BlocBuilder<ResourceBloc, ResourceState>(
                    bloc: _plantBloc,
                    builder: (context, state) {
                      return Expanded(
                        child: ResourceWidget(
                          iconPath: 'assets/images/plants.png',
                          entity: state.resource,
                        ),
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
                      return Expanded(
                        child: ResourceWidget(
                          iconPath: 'assets/images/steel.png',
                          entity: state.resource,
                        ),
                      );
                    },
                  ),
                ),
                BlocProvider(
                  create: (context) => _titaniumBloc,
                  child: BlocBuilder<ResourceBloc, ResourceState>(
                    bloc: _titaniumBloc,
                    builder: (context, state) {
                      return Expanded(
                        child: ResourceWidget(
                          iconPath: 'assets/images/titanium.png',
                          entity: state.resource,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocProvider(
                  create: (context) => _energyBloc,
                  child: BlocBuilder<ResourceBloc, ResourceState>(
                    bloc: _energyBloc,
                    builder: (context, state) {
                      return Expanded(
                        child: ResourceWidget(
                          iconPath: 'assets/images/energy.png',
                          entity: state.resource,
                        ),
                      );
                    },
                  ),
                ),
                BlocProvider(
                  create: (context) => _heatBloc,
                  child: BlocBuilder<ResourceBloc, ResourceState>(
                    bloc: _heatBloc,
                    builder: (context, state) {
                      return Expanded(
                        child: ResourceWidget(
                          iconPath: 'assets/images/heat.png',
                          entity: state.resource,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ProjectWidget(
                    name: 'Forêt',
                    price: 23,
                    unit: 'Crédits',
                    onTap: () => _creditsBloc.add(StockAdded(-25)),
                  ),
                ),
                Expanded(
                  child: ProjectWidget(
                    name: 'Ville',
                    price: 25,
                    unit: 'Crédits',
                    onTap: () {
                      _creditsBloc.add(ProductionAdded(1));
                      _creditsBloc.add(StockAdded(-25));
                    },
                  ),
                ),
                Expanded(
                  child: ProjectWidget(
                    name: 'Océan',
                    price: 18,
                    unit: 'Crédits',
                    onTap: () {
                      _creditsBloc.add(StockAdded(-18));
                    },
                  ),
                ),
                Expanded(
                  child: ProjectWidget(
                    name: 'Centrale',
                    price: 11,
                    unit: 'Crédits',
                    onTap: () {
                      _energyBloc.add(ProductionAdded(1));
                      _creditsBloc.add(StockAdded(-11));
                    },
                  ),
                ),
                Expanded(
                  child: ProjectWidget(
                    name: 'Temperature',
                    price: 14,
                    unit: 'Crédits',
                    onTap: () {
                      _creditsBloc.add(StockAdded(-14));
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ProjectWidget(
                    name: 'Temperature',
                    price: 8,
                    unit: 'Chaleur',
                    onTap: () => _heatBloc.add(StockAdded(-8)),
                  ),
                ),
                Expanded(
                  child: ProjectWidget(
                    name: 'Forêt',
                    price: 8,
                    unit: 'Plantes',
                    onTap: () {
                      _plantBloc.add(StockAdded(-8));
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _onGenerateTap,
                    child: Text(
                      'Generate',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.indigo,
                    ),
                  ),
                ),
              ],
            )
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

  void _onGenerateTap() {
    _heatBloc.add(StockAdded(_energyBloc.state.resource.stock));
    _energyBloc
        .add(ResourceChanged(_energyBloc.state.resource.copyWith(stock: 0)));
    _creditsBloc.add(StockAdded(_ntBloc.state.resource.stock));
    _creditsBloc.add(ProduceEvent());
    _steelBloc.add(ProduceEvent());
    _titaniumBloc.add(ProduceEvent());
    _plantBloc.add(ProduceEvent());
    _energyBloc.add(ProduceEvent());
    _heatBloc.add(ProduceEvent());
  }
}
