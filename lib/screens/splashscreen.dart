// import 'package:flutter/material.dart';
// import 'package:smart_meter/screens/login.dart';
//
// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   int counter = 0;
//
//   void nextImage() {
//     if(counter < 2){
//       setState(() {
//         counter++;
//       });
//     }
//     else{
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => Login()),
//       );
//     }
//   }
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: double.infinity,
//         padding: EdgeInsets.all(0.0),
//         child: GestureDetector(
//           onTap: nextImage,
//           child: new Image.asset(
//             'assets/$counter.png',
//             height: double.infinity,
//             width: double.infinity,
//             fit: BoxFit.cover,
//           ),
//         )
//       )
//     );
//   }
// }
//

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smart_meter/screens/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var counter;
  var texts = [
    "Manage all utilities with one simple tap",
    "Pay all your utility bills with just an easy swipe",
    "Minimize cost with smart usage insights "
  ];
  var text;

  @override
  void initState() {
    super.initState();
    counter = 0;
    text = texts[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 70,
            child: CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.7,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 4),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason){
                  setState(() {
                    counter = index;
                    text = texts[index];
                  });
                }
              ),
              items: [1,2,3].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                            color: Colors.white
                        ),
                        child: SvgPicture.asset('assets/sp$i.svg')
                    );
                  },
                );
              }).toList(),
            ),
          ),
          Expanded(
            flex: 30,
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.18, child:
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
                            child:
                              AutoSizeText('$text',
                                style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.085, fontWeight: FontWeight.bold),
                                maxLines: 3,
                              ),
                          )
                        ),
                        Container(
                          // color: Colors.amber,
                            height: 50,
                            width: 200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [1,2,3].map((i) {
                                int index = [1,2,3].indexOf(i);
                                return Container(
                                  width: 28.0,
                                  height: 10.0,
                                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                                  decoration: BoxDecoration(
                                    shape: counter == index ? BoxShape.rectangle : BoxShape.circle,
                                    borderRadius: counter == index ? BorderRadius.all(Radius.circular(8.0)) : null,
                                    color: counter == index
                                        ? Color.fromRGBO(247, 124, 37, 1)
                                        : Color.fromRGBO(0, 0, 0, 0.4),
                                  ),
                                );
                              }).toList(),
                            )
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: Stack(
                        children: [
                          Positioned(
                              top: 0,
                              right: -5,
                              child: RawMaterialButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Login()),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Hero(tag: 'img', child: Image.asset('assets/icons/triangle_left.png')),
                                    Positioned(
                                      top: 0,
                                      bottom: 0,
                                      left: 0,
                                      right: 10,
                                      child: Image.asset('assets/icons/arrow_right.png'),
                                    )
                                  ],
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            )
          ),
          Expanded(
            flex: 5,
            child: RichText(
                text: TextSpan(
                    style: TextStyle(fontSize: 10.0, color: const Color(0xFF262626),),
                    children: [
                      TextSpan(text: 'powered by ', style: TextStyle(fontSize: 10, color: Colors.black, fontFamily: 'Poppins')),
                      TextSpan(text: 'pert infoconsulting pvt ltd', style: TextStyle(fontFamily: 'Poppins', color: Color(0xFFF77C25)))
                    ]
                )
            ),
          )
        ],
      ),
    );
  }
}
