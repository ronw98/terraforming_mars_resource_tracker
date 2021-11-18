import 'package:tm_ressource_tracker/constants.dart';
import 'package:tm_ressource_tracker/features/resource/bloc/resource_bloc.dart';

/// Small file that creates bindings between resource bloc and actual instances,
/// This is use to ease BlocProvider resolution in the homepage

class NTBloc extends ResourceBloc {
  NTBloc() : super(sharedPrefsKey: AppConstants.prefs_nt);
}

class SteelBloc extends ResourceBloc {
  SteelBloc() : super(sharedPrefsKey: AppConstants.prefs_steel);
}

class PlantBloc extends ResourceBloc {
  PlantBloc() : super(sharedPrefsKey: AppConstants.prefs_plant);
}

class TitaniumBloc extends ResourceBloc {
  TitaniumBloc() : super(sharedPrefsKey: AppConstants.prefs_titanium);
}

class CreditsBloc extends ResourceBloc {
  CreditsBloc() : super(sharedPrefsKey: AppConstants.prefs_credit);
}

class EnergyBloc extends ResourceBloc {
  EnergyBloc() : super(sharedPrefsKey: AppConstants.prefs_energy);
}

class HeatBloc extends ResourceBloc {
  HeatBloc() : super(sharedPrefsKey: AppConstants.prefs_heat);
}
