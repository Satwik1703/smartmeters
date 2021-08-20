import 'dart:io';
// import 'dart:js';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smart_meter/data.dart';
import 'package:smart_meter/screens/welcome.dart';
import 'package:flutter_svg/svg.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider.value(
        //   value: Data(),
        // )
        ChangeNotifierProvider(
          // builder: (_) => Data(),
          create: (_) => Data(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SmartMeters',
        theme: new ThemeData(scaffoldBackgroundColor: const Color(0xFFF77C25), fontFamily: 'Poppins'),
        home: Welcome()
      ),
    );
  }
}
