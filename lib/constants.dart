class JsonKey {
  static const String stock = 'stock';
  static const String history = 'stock_history';
  static const String production = 'production';
  static const String production_history = 'production_history';
}

class AppConstants {
  static const double image_big_size = 50;
  static const double image_numbered_resource_size = 40;
  static const double stock_font_size = 20;
  static const double production_font_size = 20;
  static const double num_button_font_size = 20;
  static const Map<Resource, String> resource_path_map = <Resource, String>{
    Resource.CREDITS: 'assets/images/credits.png',
    Resource.PLANT: 'assets/images/plants.png',
    Resource.STEEL: 'assets/images/steel.png',
    Resource.TITANIUM: 'assets/images/titanium.png',
    Resource.HEAT: 'assets/images/heat.png',
    Resource.ENERGY: 'assets/images/energy.png',
  };
  static const Map<Resource, String> numbered_resource_path_map =
      <Resource, String>{
    Resource.CREDITS: 'assets/images/credits_bg.png',
    Resource.PLANT: 'assets/images/plants.png',
    Resource.STEEL: 'assets/images/steel.png',
    Resource.TITANIUM: 'assets/images/titanium.png',
    Resource.HEAT: 'assets/images/heat.png',
    Resource.ENERGY: 'assets/images/energy.png',
  };
}

enum Resource { CREDITS, PLANT, STEEL, TITANIUM, HEAT, ENERGY, NT }
