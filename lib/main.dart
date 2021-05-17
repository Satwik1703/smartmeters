import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smart_meter/data.dart';
import 'package:smart_meter/screens/welcome.dart';
import 'package:flutter_svg/svg.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
