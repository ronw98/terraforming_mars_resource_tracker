import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tm_ressource_tracker/constants.dart';
import 'package:tm_ressource_tracker/core/injection.dart';
import 'package:tm_ressource_tracker/core/locale/locale_helper.dart';
import 'package:tm_ressource_tracker/presentation/managers/configuration_cubit.dart';
import 'package:tm_ressource_tracker/presentation/managers/online_game_cubit.dart';
import 'package:tm_ressource_tracker/presentation/managers/resource_cubit.dart';
import 'package:tm_ressource_tracker/presentation/pages/home/home_page.dart';
import 'package:tm_ressource_tracker/presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Setting SystemUIOverlay
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ),
  );
  //Setting SystemUIMode
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );

  await _checkTrustedCertificates();
  await configureDependencies();

  runApp(ResourceTracker());
}

/// Adds Let's Encrypt base certificate to the list of trusted certificates
///
/// Fixes a problem on Android 7-
Future<void> _checkTrustedCertificates() async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt <= 25) {
      try {
        SecurityContext.defaultContext.setTrustedCertificatesBytes(
          ascii.encode(
            AppConstants.kISRG_X1,
          ),
        );
      } catch (e) {
        // ignore errors here, maybe it's already trusted
      }
    }
  }
}

class ResourceTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocalGameCubit>(
          create: (_) => serviceLocator()..loadResources(),
        ),
        BlocProvider<ConfigurationCubit>(
          create: (_) => serviceLocator()..loadConfig(),
        ),
        BlocProvider<OnlineGameCubit>(
          create: (_) => serviceLocator()..initialize(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        theme: appTheme,
        supportedLocales: TMI18n.supportedLocales,
        localeListResolutionCallback: TMI18n.localeListResolutionCallback,
        localizationsDelegates: [
          TMI18n.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
