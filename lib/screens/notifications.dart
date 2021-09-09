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
    Provider.of<Data>(context, listen: false).getNotifications();
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
                width: MediaQuery.of(context).size.height * 0.12,
                customShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                buttonLables: [
                  'Alerts',
                  // 'Promotions'
                ],
                buttonValues: [
                  'alerts',
                  // 'promotions'
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
              // child: (alerts) ? Alerts() : Container(),
              child: RefreshIndicator(
                onRefresh: Provider.of<Data>(context, listen: false).getNotifications,
                child: (alerts) ? Alerts() : Container(),
              ),
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

    if(Provider.of<Data>(context, listen: true).notifications.length < 1){
      return Center(child: Text('No Notifications'));
    }

    return ListView.builder(
      itemCount: Provider.of<Data>(context, listen: true).notifications.length,
      itemBuilder: (context, index){
        //type => Recharge
        if(Provider.of<Data>(context, listen: true).notifications[index]['data']['type'] == 1){
          return(
            NotiOther(index)
          );
        }
        //type => invoice
        else if(Provider.of<Data>(context, listen: true).notifications[index]['data']['type'] == 2){
          return(
            // NotiInvoice(index)
              NotiPayment(index)
          );
        }
        //type => Payment
        else if(Provider.of<Data>(context, listen: true).notifications[index]['data']['type'] == 3){
          return(
            NotiOther(index)
          );
        }
        //type => Low Balance
        else if(Provider.of<Data>(context, listen: true).notifications[index]['data']['type'] == 4){
          return(
            NotiRecharge(index)
          );
        }
        return(
          NotiOther(index)
        );
      },
    );
  }
}

class NotiInvoice extends StatelessWidget {

  var index;
  NotiInvoice(var index){
    this.index = index;
  }

  @override
  Widget build(BuildContext context) {
    var timeElapsed = "0h";
    var timeDifference = 0;
    if(Provider.of<Data>(context, listen: false).notifications[index]['sendDate'] != null && Provider.of<Data>(context, listen: false).notifications[index]['sendDate'] != ""){
      timeDifference = DateTime.now().difference(DateTime.parse("${Provider.of<Data>(context, listen: false).notifications[index]['sendDate']}")).inDays;
      timeElapsed = '${timeDifference}d';

      if(timeDifference < 1){
        timeDifference = DateTime.now().difference(DateTime.parse("${Provider.of<Data>(context, listen: false).notifications[index]['sendDate']}")).inHours + 5;
        timeElapsed = '${timeDifference}h';
        if(timeDifference > 24){
          timeElapsed = '1d';
        }
      }
    }

    return SizedBox(
      height: (MediaQuery.of(context).size.height > 600) ? MediaQuery.of(context).size.height * 0.14 : MediaQuery.of(context).size.height * 0.18,
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
                  // AutoSizeText.rich(
                  //   TextSpan(
                  //     text: 'Invoice of ',
                  //     children: [
                  //       TextSpan(
                  //         text: '3500 INR',
                  //         style: TextStyle(fontWeight: FontWeight.bold)
                  //       ),
                  //       TextSpan(text: ' generated for '),
                  //       TextSpan(
                  //         text: "Jan'21",
                  //         style: TextStyle(fontWeight: FontWeight.bold)
                  //       ),
                  //       TextSpan(text: ' to be payed by '),
                  //       TextSpan(
                  //         text: "6 Feb'21",
                  //         style: TextStyle(fontWeight: FontWeight.bold)
                  //       ),
                  //     ],
                  //   ),
                  //   minFontSize: 2,
                  //   maxLines: 2,
                  // ),
                  AutoSizeText("${Provider.of<Data>(context, listen: false).notifications[index]['data']['description']}", maxLines: 2,),
                  SizedBox(height: 15,),
                  GestureDetector(
                    onTap: (){
                      Provider.of<Data>(context, listen: false).setIndex(1);
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
                    child: Text('$timeElapsed'),
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

class NotiPayment extends StatelessWidget {
  var index;
  NotiPayment(var index){
    this.index = index;
  }

  @override
  Widget build(BuildContext context) {
    var timeElapsed = "0h";
    var timeDifference = 0;
    if(Provider.of<Data>(context, listen: false).notifications[index]['sendDate'] != null && Provider.of<Data>(context, listen: false).notifications[index]['sendDate'] != ""){
      timeDifference = DateTime.now().difference(DateTime.parse("${Provider.of<Data>(context, listen: false).notifications[index]['sendDate']}")).inDays;
      timeElapsed = '${timeDifference}d';

      if(timeDifference < 1){
        timeDifference = DateTime.now().difference(DateTime.parse("${Provider.of<Data>(context, listen: false).notifications[index]['sendDate']}")).inHours + 5;
        timeElapsed = '${timeDifference}h';
        if(timeDifference > 24){
          timeElapsed = '1d';
        }
      }
    }

    return SizedBox(
      height: (MediaQuery.of(context).size.height > 600) ? MediaQuery.of(context).size.height * 0.14 : MediaQuery.of(context).size.height * 0.18,
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
                  AutoSizeText("${Provider.of<Data>(context, listen: false).notifications[index]['data']['description']}", maxLines: 3, maxFontSize: 11.0, minFontSize: 5.0,),
                  SizedBox(height: 15,),
                  GestureDetector(
                    onTap: (){
                      Provider.of<Data>(context, listen: false).paymentGateway(context, true);
                    },
                    child: AutoSizeText('Pay Now', maxLines: 1, minFontSize: 2, maxFontSize: 12, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF77C25)),),
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
                    child: Text('$timeElapsed'),
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

class NotiRecharge extends StatelessWidget {
  var index;
  NotiRecharge(var index){
    this.index = index;
  }

  @override
  Widget build(BuildContext context) {
    var timeElapsed = "0h";
    var timeDifference = 0;
    if(Provider.of<Data>(context, listen: false).notifications[index]['sendDate'] != null && Provider.of<Data>(context, listen: false).notifications[index]['sendDate'] != ""){
      timeDifference = DateTime.now().difference(DateTime.parse("${Provider.of<Data>(context, listen: false).notifications[index]['sendDate']}")).inDays;
      timeElapsed = '${timeDifference}d';

      if(timeDifference < 1){
        timeDifference = DateTime.now().difference(DateTime.parse("${Provider.of<Data>(context, listen: false).notifications[index]['sendDate']}")).inHours + 5;
        timeElapsed = '${timeDifference}h';
        if(timeDifference > 24){
          timeElapsed = '1d';
        }
      }
    }

    return SizedBox(
      height: (MediaQuery.of(context).size.height > 600) ? MediaQuery.of(context).size.height * 0.14 : MediaQuery.of(context).size.height * 0.18,
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 10.0,),
            SvgPicture.asset('assets/wallet.svg', height: 55, width: 55,),
            SizedBox(width: 10.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AutoSizeText("${Provider.of<Data>(context, listen: false).notifications[index]['data']['description']}", maxLines: 2, minFontSize: 5.0, maxFontSize: 11.0,),
                  SizedBox(height: 15,),
                  GestureDetector(
                    onTap: (){
                      Provider.of<Data>(context, listen: false).paymentGateway(context, false);
                    },
                    child: AutoSizeText('Recharge', maxLines: 1, minFontSize: 2, maxFontSize: 12, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF77C25)),),
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
                    child: Text('$timeElapsed'),
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

class NotiOther extends StatelessWidget {
  var index;
  NotiOther(var index){
    this.index = index;
  }

  @override
  Widget build(BuildContext context) {
    var timeElapsed = "0h";
    var timeDifference = 0;
    if(Provider.of<Data>(context, listen: false).notifications[index]['sendDate'] != null && Provider.of<Data>(context, listen: false).notifications[index]['sendDate'] != ""){
      timeDifference = DateTime.now().difference(DateTime.parse("${Provider.of<Data>(context, listen: false).notifications[index]['sendDate']}")).inDays;
      timeElapsed = '${timeDifference}d';

      if(timeDifference < 1){
        timeDifference = DateTime.now().difference(DateTime.parse("${Provider.of<Data>(context, listen: false).notifications[index]['sendDate']}")).inHours;
        timeElapsed = '${timeDifference}h';
        if(timeDifference > 24){
          timeElapsed = '1d';
        }
      }
    }

    return SizedBox(
      height: (MediaQuery.of(context).size.height > 600) ? MediaQuery.of(context).size.height * 0.14 : MediaQuery.of(context).size.height * 0.18,
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 10.0,),
            SvgPicture.asset('assets/wallet.svg', height: 55, width: 55,),
            SizedBox(width: 10.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AutoSizeText("${Provider.of<Data>(context, listen: false).notifications[index]['data']['description']}", maxLines: 4, minFontSize: 2.0, maxFontSize: 11.0,),
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
                    child: Text('$timeElapsed'),
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