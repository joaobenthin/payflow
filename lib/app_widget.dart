import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payflow/shared/modules/barcode_scanner/barcode_scanner_page.dart';
import 'package:payflow/shared/modules/home/home_page.dart';
import 'package:payflow/shared/modules/insert_boleto/insert_boleto_page.dart';
import 'package:payflow/shared/modules/login/login_page.dart';
import 'package:payflow/shared/modules/splash/splash_page.dart';
import 'package:payflow/shared/themes/app_colors.dart';

class AppWidget extends StatelessWidget {
  AppWidget() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pay Flow',
        theme: ThemeData(
            primarySwatch: Colors.orange, primaryColor: AppColors.primary),
        initialRoute: "/splash",
        routes: {
          "/splash": (context) => SplashPage(),
          "/home": (context) => HomePage(),
          "/login": (context) => LoginPage(),
          "/barcode_scanner": (context) => BarcodeScannerPage(),
          "/insert_boleto": (context) => InsertBoletoPage()
        });
  }
}
