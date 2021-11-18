import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/features/home/bloc/bloc_bindings.dart';
import 'package:tm_ressource_tracker/features/resource/bloc/resource_bloc.dart';
import 'package:tm_ressource_tracker/features/resource/widgets/nt_edit_widget.dart';
import 'package:tm_ressource_tracker/features/resource/widgets/resource_widget.dart';

class ResourceWidgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BlocBuilder<NTBloc, ResourceState>(
          builder: (context, state) {
            return NTWidget(
              name: 'NT',
              entity: state.resource,
            );
          },
        ),
        Row(
          children: [
            BlocBuilder<CreditsBloc, ResourceState>(
              builder: (context, state) {
                return Expanded(
                  child: ResourceWidget<CreditsBloc>(
                    iconPath: 'assets/images/credits.png',
                    entity: state.resource,
                    prodThreshold: -5,
                  ),
                );
              },
            ),
            BlocBuilder<PlantBloc, ResourceState>(
              builder: (context, state) {
                return Expanded(
                  child: ResourceWidget<PlantBloc>(
                    iconPath: 'assets/images/plants.png',
                    entity: state.resource,
                  ),
                );
              },
            ),
          ],
        ),
        Row(
          children: [
            BlocBuilder<SteelBloc, ResourceState>(
              builder: (context, state) {
                return Expanded(
                  child: ResourceWidget<SteelBloc>(
                    iconPath: 'assets/images/steel.png',
                    entity: state.resource,
                  ),
                );
              },
            ),
            BlocBuilder<TitaniumBloc, ResourceState>(
              builder: (context, state) {
                return Expanded(
                  child: ResourceWidget<TitaniumBloc>(
                    iconPath: 'assets/images/titanium.png',
                    entity: state.resource,
                  ),
                );
              },
            ),
          ],
        ),
        Row(
          children: [
            BlocBuilder<EnergyBloc, ResourceState>(
              builder: (context, state) {
                return Expanded(
                  child: ResourceWidget<EnergyBloc>(
                    iconPath: 'assets/images/energy.png',
                    entity: state.resource,
                  ),
                );
              },
            ),
            BlocBuilder<HeatBloc, ResourceState>(
              builder: (context, state) {
                return Expanded(
                  child: ResourceWidget<HeatBloc>(
                    iconPath: 'assets/images/heat.png',
                    entity: state.resource,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
