import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smart_meter/data.dart';

class TopRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var flatIndex = Provider.of<Data>(context).flatIndex;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 7,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 10.0,),
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
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
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
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.only(right: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Home", style: TextStyle(fontSize: 10.0, color: Colors.white), textAlign: TextAlign.end,),
                  AutoSizeText("${Provider.of<Data>(context).data['customerflatData'][flatIndex]['blockData']['name']} ${Provider.of<Data>(context).data['customerflatData'][flatIndex]['flatData']['name']}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1, minFontSize: 2, textAlign: TextAlign.end,)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  var alerts = true;

  @override
  void initState() {
    super.initState();
    alerts = true;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: (MediaQuery.of(context).size.height > 600) ? MediaQuery.of(context).size.height * 0.09 : MediaQuery.of(context).size.height * 0.14,
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
              ),
              padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
              child: CustomRadioButton(
                elevation: 0,
                absoluteZeroSpacing: false,
                enableShape: true,
                width: MediaQuery.of(context).size.height * 0.15,
                // customShape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(15.0),
                // ),
                buttonLables: [
                  'Alerts',
                  'Promotions'
                ],
                buttonValues: [
                  'alerts',
                  'promotions'
                ],
                defaultSelected: 'alerts',

                unSelectedColor: Colors.white,
                selectedColor: Color(0xFFF77C25),
                unSelectedBorderColor: Color(0xFF707070),
                selectedBorderColor: Colors.transparent,
                buttonTextStyle: ButtonTextStyle(
                  selectedColor: Colors.white,
                  unSelectedColor: Color(0xFF707070),
                  textStyle: TextStyle(fontSize: 15),
                ),
                radioButtonValue: (value) {
                  if(value == 'alerts'){
                    setState(() {
                      alerts = true;
                    });
                  }
                  else{
                    setState(() {
                      alerts = false;
                    });
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: (alerts) ? Alerts() : Container(),
            ),
          )
        ],
      )
    );
  }
}

class Alerts extends StatelessWidget {
  const Alerts({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(0.0),
      children: [
        SizedBox(height: 20.0,),
        NotiInvoice(),
        NotiInvoice(),
      ],
    );
  }
}

class NotiInvoice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (MediaQuery.of(context).size.height > 600) ? MediaQuery.of(context).size.height * 0.12 : MediaQuery.of(context).size.height * 0.18,
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 10.0,),
            SvgPicture.asset('assets/invoice.svg', height: 55, width: 55,),
            SizedBox(width: 10.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AutoSizeText.rich(
                    TextSpan(
                      text: 'Invoice of ',
                      children: [
                        TextSpan(
                          text: '3500 INR',
                          style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        TextSpan(text: ' generated for '),
                        TextSpan(
                          text: "Jan'21",
                          style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        TextSpan(text: ' to be payed by '),
                        TextSpan(
                          text: "6 Feb'21",
                          style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                    minFontSize: 2,
                    maxLines: 2,
                  ),
                  SizedBox(height: 15,),
                  GestureDetector(
                    onTap: (){
                      print('tapped');
                    },
                    child: AutoSizeText('View Invoice', maxLines: 1, minFontSize: 2, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF77C25)),),
                  )
                ],
              ),
            ),
            SizedBox(width: 10.0,),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.13,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 30,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                      color: Color.fromRGBO(247, 124, 37, 0.2)
                    ),
                    child: Text('1h'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
