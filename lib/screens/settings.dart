import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 2, child: Container(),),
          Expanded(
            flex: 8,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                  ),
                ),
                Positioned(
                  top: -80.0,
                  left: 0.0,
                  right: 0.0,
                  child: SettingsCard(),
                )
              ],
            )
          )
        ],
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: Card(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0)
        ),
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 22.0),
                child: Row(
                  children: [
                    Icon(Icons.image, size: MediaQuery.of(context).size.width * 0.15,),
                    SizedBox(width: 20.0,),
                    Expanded(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText('Sandeep Raj', minFontSize: 20.0, maxLines: 1,),
                          Row(
                            children: [
                              Icon(Icons.phone, color: Colors.orange, size: 15.0,),
                              SizedBox(width: 15.0,),
                              Text('+91 7799800005'),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.email_outlined, color: Colors.orange, size: 15.0,),
                              SizedBox(width: 15.0,),
                              AutoSizeText('+91 sathwikgaddam@gmail.com'),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ),
            Expanded(
              flex: 3,
              child: Container(color: Colors.green,),
            )
          ],
        ),
      ),
    );
  }
}

