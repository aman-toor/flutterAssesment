import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_assesment/screens/welcome_screen.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const NeumorphicApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      theme: NeumorphicThemeData(
        baseColor: Color(0xFFFFFFFF),
        accentColor: Color.fromRGBO(64, 64, 64, 1),
        lightSource: LightSource.topLeft,
        depth: 10,
      ),
      darkTheme: NeumorphicThemeData(
        baseColor: Color.fromRGBO(41,41,41, 1),
        accentColor:  Color.fromRGBO(217, 137, 106, 1),
        lightSource: LightSource.topLeft,
        depth: 6,
      ),
      home: WelcomeScreen(),
    );
  }
}
