import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/domain/entities/configuration.dart';
import 'package:tm_ressource_tracker/presentation/managers/configuration_cubit.dart';
import 'package:tm_ressource_tracker/presentation/widgets/none_widget.dart';

class ConfigBuilder extends StatelessWidget {
  const ConfigBuilder({Key? key, required this.builder}) : super(key: key);

  final Widget Function(Configuration config) builder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigurationCubit, ConfigurationState>(
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (config) => builder(config),
          orElse: () => const NoneWidget(),
        );
      },
    );
  }
}
