import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/features/home/bloc/bloc_bindings.dart';
import 'package:tm_ressource_tracker/features/home/pages/home_page.dart';

void main() {
  runApp(ResourceTracker());
}

class ResourceTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NTBloc()),
        BlocProvider(create: (_) => SteelBloc()),
        BlocProvider(create: (_) => TitaniumBloc()),
        BlocProvider(create: (_) => PlantBloc()),
        BlocProvider(create: (_) => CreditsBloc()),
        BlocProvider(create: (_) => HeatBloc()),
        BlocProvider(create: (_) => EnergyBloc()),
      ],
      child: MaterialApp(
        home: HomePage(),
        theme: ThemeData(fontFamily: 'Enter Sansman'),
      ),
    );
  }
}
