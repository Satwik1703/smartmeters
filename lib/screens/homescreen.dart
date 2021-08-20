import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smart_meter/components/dashboard.dart';
import 'package:smart_meter/components/transactions.dart';
import 'package:smart_meter/data.dart';
import 'package:smart_meter/screens/notifications.dart';
import 'package:smart_meter/screens/settings.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  var index = 0;

  List<Widget> topWidgets = <Widget>[
    TestRow(),
    TestRow(),
    TopRow(),
    // Container(height: 0,),
  ];

  List<Widget> widgets = <Widget>[
    Dashboard(),
    Transactions(),
    Notifications(),
    // Settings(),
  ];

  FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();
    // index = Provider.of<Data>(context, listen: true).index;
    loadTransactions();
    firebaseNotifications();
  }

  void firebaseNotifications() async {
    Provider.of<Data>(context, listen: false).initialiseNotification();

    messaging = FirebaseMessaging.instance;
    messaging
      .getToken()
      .then((value){
        Provider.of<Data>(context, listen: false).updateDeviceToken(value);
    });

    // FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async{
    //   Provider.of<Data>(context, listen: false).displayNotification(message.notification.title, message.notification.body);
    // });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Provider.of<Data>(context, listen: false).displayNotification(message.notification.title, message.notification.body);
    });


    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  void loadTransactions() async {
    await Permission.storage.request();

    // WidgetsFlutterBinding.ensureInitialized();
    // await FlutterDownloader.initialize(
    //     debug: true // optional: set false to disable printing logs to console
    // );
  }

  @override
  Widget build(BuildContext context) {
    var navBarHeight = kBottomNavigationBarHeight * 0.7;
    // var navBarWidth = 0.7;
    var navBarWidth = 1.0;
    index = Provider.of<Data>(context, listen: true).index;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: [
          bottomNavigationBarItem(navBarWidth, navBarHeight, 0, 'dashboard', 'Dashboard'),
          bottomNavigationBarItem(navBarWidth, navBarHeight, 1, 'transactions', 'Transactions'),
          bottomNavigationBarItem(navBarWidth, navBarHeight, 2, 'notifications', 'Notifications'),
          // bottomNavigationBarItem(navBarWidth, navBarHeight, 2, 'settings_bottom_bar', 'Settings'),
        ],
        currentIndex: index,
        onTap: (value){
          setState(() {
            index = value;
          });
          Provider.of<Data>(context, listen: false).setIndex(value);
        },
      ),
      body: Column(
        children: [
          topWidgets.elementAt(index),
          // Dashboard(refreshIndicatorKey: _refreshIndicatorKey),
          widgets.elementAt(index),
        ],
      ),
    );
  }

  BottomNavigationBarItem bottomNavigationBarItem(double navBarWidth, double navBarHeight, var ind, String image, String label) {
    return BottomNavigationBarItem(
            icon: FractionallySizedBox(
              widthFactor: navBarWidth,
              child: (index == ind) ?
              Container(
                height: navBarHeight,
                decoration: BoxDecoration(
                  color: (index == ind) ? Color(0xFFF77C25) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.0)
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 6.0),
                    SvgPicture.asset('assets/$image.svg', color: Colors.white,),
                    SizedBox(width: 4.0),
                    Expanded(child: AutoSizeText('$label', style: TextStyle(color: Colors.white), maxLines: 1, minFontSize: 2,)),
                  ],
                ),
              )
              : SvgPicture.asset('assets/$image.svg', color: Colors.black,),
            ),
            label: '$label',
        );
  }
}

class TestRow extends StatelessWidget {
  const TestRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var flatIndex = Provider.of<Data>(context).flatIndex;
    var noOfFlats = new List<int>.generate(Provider.of<Data>(context, listen: false).data['customerflatData'].length, (i) => i + 1);
    return SizedBox(
      height: (MediaQuery.of(context).size.height > 600) ? MediaQuery.of(context).size.height * 0.22 : MediaQuery.of(context).size.height * 0.3,
      width: double.infinity,
      child: CarouselSlider(
        options: CarouselOptions(
            // height: MediaQuery.of(context).size.height * 0.2,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: false,
            reverse: false,
            autoPlay: false,
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            scrollDirection: Axis.vertical,
            onPageChanged: (index, reason){
              Provider.of<Data>(context, listen: false).setFlatIndex(index);
            }
        ),
        items: noOfFlats.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Container(
                        // margin: EdgeInsets.only(bottom: 50.0),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 38.0, bottom: 34.0),
                          child: Container(
                            width: double.infinity,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipOval(
                                  child: Material(
                                    color: Colors.white, // button color
                                    child: InkWell(
                                      splashColor: Colors.red, // inkwell color
                                      child: SizedBox(
                                        width: 56,
                                        height: 56,
// child: Icon(Icons.menu)
                                        child: Image.network('${Provider.of<Data>(context, listen: false).url}${Provider.of<Data>(context, listen: false).data['customerflatData'][flatIndex]['projectData']['image']}', fit: BoxFit.cover,),
                                      ),
                                      onTap: () {},
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10, left: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        (Provider.of<Data>(context).data['customerflatData'][flatIndex]['projectData']['builderName'] != null)
                                        ? Text("${Provider.of<Data>(context).data['customerflatData'][flatIndex]['projectData']['builderName']}", style: TextStyle(fontSize: 10.0, color: Colors.white),) : Text(' ', style: TextStyle(fontSize: 10.0),),
                                        AutoSizeText("${Provider.of<Data>(context).data['customerflatData'][flatIndex]['projectData']['name']}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), maxFontSize: 20, minFontSize: 5.0, maxLines: 1,)
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 50.0, right: 10.0),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0, right: 18.0, top: 34.0, bottom: 34.0),
                          child: Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Home", style: TextStyle(fontSize: 10.0, color: Colors.white), textAlign: TextAlign.end,),
                                AutoSizeText("${Provider.of<Data>(context).data['customerflatData'][flatIndex]['blockData']['name']} ${Provider.of<Data>(context).data['customerflatData'][flatIndex]['flatData']['name']}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1, minFontSize: 2, textAlign: TextAlign.end,)
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
              ;
            },
          );
        }).toList(),
      ),
    );
  }
}