import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:tm_ressource_tracker/pages/desktop_home_page.dart';
import 'package:tm_ressource_tracker/pages/mobile_home_page.dart';
import 'package:tm_ressource_tracker/pages/web_mobile_page.dart';
class PlatformWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isMobile;
    bool isWebMobile = false;
    if(kIsWeb) {
      try {
        isWebMobile = Platform.isIOS || Platform.isAndroid;
        isMobile = isWebMobile;
      } on UnsupportedError catch (_) {
        isMobile = false;
      }
    } else {
      isMobile = Platform.isIOS || Platform.isAndroid;
    }
    if(isWebMobile) {
      return WebMobilePage();
    }
    if(isMobile) {
      return MobileHomePage();
    }
    return DesktopHomePage();
  }

}