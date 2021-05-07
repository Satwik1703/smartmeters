import 'dart:async';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_meter/data.dart';
import 'package:smart_meter/screens/splashscreen.dart';
import 'package:smart_meter/screens/homescreen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  @override
  void initState(){
    super.initState();
    loadData();
    super.initState();
    Future.wait([
      precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/sp1.svg'), null),
      precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/sp2.svg'), null),
      precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/sp3.svg'), null),
    ]);
    Timer( Duration(seconds: 3), (){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
            (Route<dynamic> route) => false,
      );
    });
  }

  void loadData() async {
    var prefs = await SharedPreferences.getInstance();
    var value = prefs.getString('data') ?? null;
    if(value != null){
      await Provider.of<Data>(context, listen: false).setData(value);
      await  Provider.of<Data>(context, listen: false).getDashboardData();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topRight,
            color: Colors.white,
            child: Image.asset('assets/welcome.png'),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            child: GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => SplashScreen()),
                // );
              },
            ),
          ),
          // Center(child: Text("Smart Meters", style: TextStyle(fontSize: 21.0, color: Colors.white))),
          Center(child: SvgPicture.asset('assets/welcome.svg', height: 80, width: 80)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: RichText(
                  text: TextSpan(
                      style: TextStyle(fontSize: 10.0, color: const Color(0xFF262626),),
                      children: [
                        TextSpan(text: 'powered by ', style: TextStyle(fontSize: 10, color: Colors.black, fontFamily: 'Poppins')),
                        TextSpan(text: 'pert infoconsulting pvt ltd', style: TextStyle(fontFamily: 'Poppins', color: Color(0xFFF77C25)))
                      ]
                  )
              ),
            ),
          )
        ],
      )
    );
  }
}
