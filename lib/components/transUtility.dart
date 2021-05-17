import 'dart:async';
import 'dart:io' show Platform, stdout;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smart_meter/components/pdfViewer.dart';
import 'package:smart_meter/data.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TransPayment extends StatelessWidget {

  const TransPayment({
    Key key,
    this.data,
    this.flatIndex
  }) : super(key: key);

  final data;
  final flatIndex;

  @override
  Widget build(BuildContext context) {
    var size_2 = MediaQuery.of(context).size.width * 0.05;
    var icon = 'wallet';

    var a = data['transactionDate'].toString().substring(0, 10);
    DateTime dateParsed = new DateFormat("yyyy-MM-dd").parse(a);
    var time;
    DateTime timeParsed = new DateFormat("hh:mm").parse(data['createdAt'].toString().substring(11, 16));
    if(timeParsed.hour <= 12){
      time = "${data['createdAt'].toString().substring(11, 16)} am";
    }
    else{
      time = "${data['createdAt'].toString().substring(11, 16)} pm";
    }

    return RawMaterialButton(
      onPressed: (){
        // print(data['createdAt']);
        showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return DraggableScrollableSheet(
                  initialChildSize: 0.5, //set this as you want
                  maxChildSize: 0.8, //set this as you want
                  minChildSize: 0.5, //set this as you want
                  expand: false,
                  builder: (context, scrollController) {
                    return Container(
                      child: ListView(
                        controller: scrollController,
                        children: [
                          Container(
                            // height: MediaQuery.of(context).size.height * 0.5,
                            margin: EdgeInsets.only(top: 30.0),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 30.0,
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        child: Center(child: Text('Invoice Status', textAlign: TextAlign.end,)),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                                          color: Color.fromRGBO(247, 124, 37, 0.13),
                                        ),
                                      ),
                                      SizedBox(width: 10.0,),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.5,
                                        height: 1.0,
                                        color: Colors.black12,
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(15.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 20.0),
                                            child: Row(
                                              children: [
                                                (icon != null) ? SvgPicture.asset('assets/$icon.svg', height: 55, width: 55,) : Icon(Icons.account_balance_wallet_rounded, size: 45.0,),
                                                SizedBox(width: 10.0,),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(width: MediaQuery.of(context).size.width * 0.4, child: AutoSizeText("Paid Against ${Provider.of<Data>(context, listen: false).getMonthName(data['billGenerateData']['month'].toString()).substring(0, 3)}'${data['billGenerateData']['year'].toString().substring(2)} Invoice", style: TextStyle(fontFamily: 'Poppins'), minFontSize: 15 , maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: false,)),
                                                          Icon(Icons.verified, color: Colors.green,  size: 20,),
                                                        ],
                                                      ),
                                                      SizedBox(height: 3.0,),
                                                      Text('${(dateParsed.day).toString()} ${Provider.of<Data>(context).getMonthName((dateParsed.month).toString()).substring(0, 3)}, $time', style: TextStyle(fontFamily: 'Poppins'),)
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 20.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                      style: TextStyle(fontSize: size_2*0.7, color: const Color(0xFF262626),),
                                                      children: [
                                                        TextSpan(text: '${data['credit']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: size_2*0.9, fontFamily: 'Poppins')),
                                                        TextSpan(text: ' INR', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: Color(0xFF262626), fontSize: size_2*0.5))
                                                      ]
                                                  ),
                                                  textAlign: TextAlign.end,
                                                  maxLines: 1,
                                                ),
                                                // SizedBox(height: 3.0,),
                                                (data['closingBalance'].toString().length > 9)
                                                    ? Text('${data['closingBalance'].toString().substring(0, 9)}', style: TextStyle(fontSize: size_2*0.6, fontFamily: 'Poppins'),)
                                                    : Text('${data['closingBalance']}', style: TextStyle(fontSize: size_2*0.6, fontFamily: 'Poppins'),)
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Text('To', style: TextStyle(fontSize: size_2 * 0.7, color: Color.fromRGBO(75, 70, 66, 0.8))),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${Provider.of<Data>(context).data['customerflatData'][flatIndex]['projectData']['name']}', style: TextStyle(fontSize: size_2),),
                                        Image.network('${Provider.of<Data>(context, listen: false).url}${Provider.of<Data>(context, listen: false).data['customerflatData'][flatIndex]['projectData']['image']}', fit: BoxFit.cover, height: 55, width: 55,),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Text('Payment Mode', style: TextStyle(fontSize: size_2 * 0.7, color: Color.fromRGBO(75, 70, 66, 0.8))),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0, right: 30),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('${data['paymentData']['paymentMode'].toString().toUpperCase()}', style: TextStyle(fontSize: size_2, fontFamily: 'Poppins'),),
                                        SvgPicture.asset('assets/wallet.svg', height: 55, width: 55,)
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15.0,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              AutoSizeText('Wallet Transaction ID', maxLines: 1,),
                                              AutoSizeText('${data['transactionId']}', maxLines: 1,)
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              AutoSizeText('Bank Reference No', maxLines: 1,),
                                              AutoSizeText('N/A', maxLines: 1,),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                            ),
                          ),
                        ],
                      ),
                    );
                  }
              );
            }
        );
      },

      child: Tooltip(
        message: "Paid Against ${Provider.of<Data>(context, listen: false).getMonthName(data['billGenerateData']['month'].toString()).substring(0, 3)}'${data['billGenerateData']['year'].toString().substring(2)} Invoice",
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 7,
              child: Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    (icon != null) ? SvgPicture.asset('assets/$icon.svg', height: 55, width: 55,) : Icon(Icons.account_balance_wallet_rounded, size: 45.0,),
                    SizedBox(width: 10.0,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Paid Against ${Provider.of<Data>(context, listen: false).getMonthName(data['billGenerateData']['month'].toString()).substring(0, 3)}'${data['billGenerateData']['year'].toString().substring(2)} Invoice", style: TextStyle(fontFamily: 'Poppins', fontSize: size_2*0.8), maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: false,),
                          SizedBox(height: 3.0,),
                          Text('${(dateParsed.day).toString()} ${Provider.of<Data>(context).getMonthName((dateParsed.month).toString()).substring(0, 3)}, $time', style: TextStyle(fontFamily: 'Poppins'),)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                          style: TextStyle(fontSize: size_2*0.7, color: const Color(0xFF262626),),
                          children: [
                            TextSpan(text: '${data['credit']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: size_2*0.9, fontFamily: 'Poppins')),
                            TextSpan(text: ' INR', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: Color(0xFF262626), fontSize: size_2*0.5))
                          ]
                      ),
                      textAlign: TextAlign.end,
                      maxLines: 1,
                    ),
                    // SizedBox(height: 3.0,),
                    (data['closingBalance'].toString().length > 9)
                        ? Text('${data['closingBalance'].toString().substring(0, 9)}', style: TextStyle(fontSize: size_2*0.6, fontFamily: 'Poppins'),)
                        : Text('${data['closingBalance']}', style: TextStyle(fontSize: size_2*0.6, fontFamily: 'Poppins'),)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class TransUtility extends StatelessWidget {

  const TransUtility({
    Key key,
    this.data,
    this.flatIndex
  }) : super(key: key);

  final data;
  final flatIndex;

  @override
  Widget build(BuildContext context) {
    var size_2 = MediaQuery.of(context).size.width * 0.05;
    var icon;
    var utility;
    var descTypes = ['Domestic Water(MW)', 'Drinking Water(TW)', 'Elactrcity', 'Diesel Generator', 'Maintaince', 'Electricity'];
    var short = ['WM', 'GW', 'EB', 'DG', '', 'EB'];
    var icons = ['11527', 'drinking', '11475', '11474', 'maintenance', '11475'];
    for (int i=0; i<descTypes.length; i++){
      if(data['Description'] == descTypes[i]){
        icon = icons[i];
        utility = short[i];
      }
    }
    if(data['Description'] == 'Elactrcity'){
      data['Description'] = 'Electricity';
    }

    var h = (data['Description'] == 'Maintaince') ? 0.5 : 0.65;

    var a = data['transactionDate'].toString().substring(0, 10);
    DateTime dateParsed = new DateFormat("yyyy-MM-dd").parse(a);
    var time;
    DateTime timeParsed = new DateFormat("hh:mm").parse(data['createdAt'].toString().substring(11, 16));
    if(timeParsed.hour <= 12){
      time = "${data['createdAt'].toString().substring(11, 16)} am";
    }
    else{
      time = "${data['createdAt'].toString().substring(11, 16)} pm";
    }

    return RawMaterialButton(
      onPressed: (){
        if(data['Description'] == 'Recharge'){
          return;
        }

        Provider.of<Data>(context, listen: false).setReading();
        if(data['Description'] != 'Maintaince'){
          Provider.of<Data>(context, listen: false).getReadings(data['flatId'], data['blockId'], a, utility);
        }


        showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return DraggableScrollableSheet(
                  initialChildSize: h, //set this as you want
                  maxChildSize: 0.9, //set this as you want
                  minChildSize: 0.5, //set this as you want
                  expand: false,
                  builder: (context, scrollController) {
                    return Container(
                      child: ListView(
                        controller: scrollController,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 30.0),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 30.0,
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width * 0.4,
                                        child: Center(child: Text(
                                          'Payment Details', textAlign: TextAlign.end,)),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10)),
                                          color: Color.fromRGBO(247, 124, 37, 0.13),
                                        ),
                                      ),
                                      SizedBox(width: 10.0,),
                                      Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width * 0.5,
                                        height: 1.0,
                                        color: Colors.black12,
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(15.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 20.0),
                                            child: Row(
                                              children: [
                                                (icon != null) ? SvgPicture.asset(
                                                  'assets/$icon.svg', height: 55,
                                                  width: 55,) : Icon(
                                                  Icons.account_balance_wallet_rounded,
                                                  size: 45.0,),
                                                SizedBox(width: 10.0,),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      (data['Description'] == 'Recharge')
                                                          ? Text(
                                                        'Wallet Recharge Successful',
                                                        style: TextStyle(
                                                            fontFamily: 'Poppins',
                                                            fontSize: size_2 * 0.8),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        softWrap: false,)
                                                          : (data['Description'] ==
                                                          'Payment') ? Text('Payment',
                                                        style: TextStyle(
                                                            fontFamily: 'Poppins',
                                                            fontSize: size_2 * 0.8),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        softWrap: false,) :
                                                      Text(
                                                        'Paid for ${data['Description']} on ${(dateParsed.day).toString()} ${Provider.of<Data>(context).getMonthName((dateParsed.month).toString()).substring(0, 3)}',
                                                        style: TextStyle(
                                                            fontFamily: 'Poppins',
                                                            fontSize: size_2 * 0.8),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        softWrap: false,),
                                                      SizedBox(height: 3.0,),
                                                      Text('${(dateParsed.day)
                                                          .toString()} ${Provider.of<
                                                          Data>(context)
                                                          .getMonthName(
                                                          (dateParsed.month).toString())
                                                          .substring(0, 3)}, $time',
                                                        style: TextStyle(
                                                            fontFamily: 'Poppins'),)
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 20.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                      style: TextStyle(
                                                        fontSize: size_2 * 0.7,
                                                        color: const Color(
                                                            0xFF262626),),
                                                      children: [
                                                        (icon != null)
                                                            ? TextSpan(
                                                            text: '-${data['debit']}',
                                                            style: TextStyle(
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                                fontSize: size_2*0.9,
                                                                color: const Color(
                                                                    0xFF262626),
                                                                fontFamily: 'Poppins'))
                                                            : TextSpan(
                                                            text: '+${data['credit']}',
                                                            style: TextStyle(
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                                fontSize: size_2*0.9,
                                                                color: Colors.green,
                                                                fontFamily: 'Poppins')),
                                                        TextSpan(text: ' INR',
                                                            style: TextStyle(
                                                                fontFamily: 'Poppins',
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                                color: (icon == null)
                                                                    ? Colors.green
                                                                    : Color(
                                                                    0xFF262626), fontSize: size_2*0.5))
                                                      ]
                                                  ),
                                                  textAlign: TextAlign.end,
                                                  maxLines: 1,
                                                ),
                                                // SizedBox(height: 3.0,),
                                                (data['closingBalance']
                                                    .toString()
                                                    .length > 9)
                                                    ? Text('${data['closingBalance']
                                                    .toString()
                                                    .substring(0, 9)}', style: TextStyle(
                                                    fontSize: size_2 * 0.6,
                                                    fontFamily: 'Poppins'),)
                                                    : Text('${data['closingBalance']}',
                                                  style: TextStyle(fontSize: size_2 * 0.6,
                                                      fontFamily: 'Poppins'),),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Text('To', style: TextStyle(
                                        fontSize: size_2 * 0.7,
                                        color: Color.fromRGBO(75, 70, 66, 0.8))),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0, right: 30),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${Provider
                                            .of<Data>(context)
                                            .data['customerflatData'][flatIndex]['projectData']['name']}',
                                          style: TextStyle(fontSize: size_2),),
                                        Image.network('${Provider
                                            .of<Data>(context, listen: false)
                                            .url}${Provider
                                            .of<Data>(context, listen: false)
                                            .data['customerflatData'][flatIndex]['projectData']['image']}',
                                          fit: BoxFit.cover, height: 55, width: 55,),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Text('From', style: TextStyle(
                                        fontSize: size_2 * 0.7,
                                        color: Color.fromRGBO(75, 70, 66, 0.8))),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30.0, right: 30.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('Smart Meter Wallet',
                                          style: TextStyle(fontSize: size_2),),
                                        SvgPicture.asset(
                                          'assets/wallet.svg', height: 55, width: 55,)
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15.0,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              AutoSizeText('Wallet Transaction ID', maxLines: 1,),
                                              AutoSizeText('${data['transactionId']}', maxLines: 1,)
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              AutoSizeText('Bank Reference No', maxLines: 1,),
                                              AutoSizeText('N/A', maxLines: 1,),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 20.0,),

                                  (data['Description'] != 'Maintaince') ?
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 30.0,
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.4,
                                            child: Center(child: Text('Meter Reading',
                                              textAlign: TextAlign.end,)),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomRight: Radius.circular(10)),
                                              color: Color.fromRGBO(247, 124, 37, 0.13),
                                            ),
                                          ),
                                          SizedBox(width: 10.0,),
                                          Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.5,
                                            height: 1.0,
                                            color: Colors.black12,
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 20.0,),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 30.0, right: 30.0, top: 10.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Text('Start Reading',
                                              style: TextStyle(fontSize: size_2 * 0.85),),
                                            Text('${Provider
                                                .of<Data>(context)
                                                .start}',
                                              style: TextStyle(fontSize: size_2 * 0.85),)
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 30.0, right: 30.0, top: 10.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Text('End Reading',
                                              style: TextStyle(fontSize: size_2 * 0.85),),
                                            Text('${Provider
                                                .of<Data>(context)
                                                .end}',
                                              style: TextStyle(fontSize: size_2 * 0.85),)
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 30.0, right: 30.0, top: 10.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Text('Total Units Used',
                                              style: TextStyle(fontSize: size_2 * 0.85),),
                                            Text('${Provider
                                                .of<Data>(context)
                                                .consumed}',
                                              style: TextStyle(fontSize: size_2 * 0.85),)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ) : Container(),


                                ],
                              ),

                            ),
                          ),
                        ],
                      ),
                    );
                  }
              );
            }
        );
      },
      child: Tooltip(
        message: 'Paid for ${data['Description']} on ${(dateParsed.day).toString()} ${Provider.of<Data>(context).getMonthName((dateParsed.month).toString()).substring(0, 3)}',
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 7,
              child: Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    (icon != null) ? SvgPicture.asset('assets/$icon.svg', height: 55, width: 55,) : SvgPicture.asset('assets/wallet.svg', height: 55, width: 55,),
                    SizedBox(width: 10.0,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (data['Description'] == 'Recharge') ? Text('Wallet Recharge Successful', style: TextStyle(fontFamily: 'Poppins', fontSize: size_2*0.8), maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: false,)
                              : (data['Description'] == 'Payment') ? Text('Payment', style: TextStyle(fontFamily: 'Poppins', fontSize: size_2*0.8), maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: false,) :
                          Text('Paid for ${data['Description']} on ${(dateParsed.day).toString()} ${Provider.of<Data>(context).getMonthName((dateParsed.month).toString()).substring(0, 3)}', style: TextStyle(fontFamily: 'Poppins', fontSize: size_2*0.8), maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: false,),
                          SizedBox(height: 3.0,),
                          Text('${(dateParsed.day).toString()} ${Provider.of<Data>(context).getMonthName((dateParsed.month).toString()).substring(0, 3)}, $time', style: TextStyle(fontFamily: 'Poppins'),)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                          style: TextStyle(fontSize: size_2*0.7, color: const Color(0xFF262626),),
                          children: [
                            (icon != null)
                                ? TextSpan(text: '-${data['debit']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: size_2*0.9, color: const Color(0xFF262626), fontFamily: 'Poppins'))
                                : TextSpan(text: '+${data['credit']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: size_2, color: Colors.green, fontFamily: 'Poppins')),
                            TextSpan(text: ' INR', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: (icon == null) ? Colors.green : Color(0xFF262626), fontSize: size_2*0.5))
                          ]
                      ),
                      textAlign: TextAlign.end,
                      maxLines: 1,
                    ),
                    // SizedBox(height: 3.0,),
                    (data['closingBalance'].toString().length > 9)
                        ? Text('${data['closingBalance'].toString().substring(0, 9)}', style: TextStyle(fontSize: size_2*0.6, fontFamily: 'Poppins'),)
                        : Text('${data['closingBalance']}', style: TextStyle(fontSize: size_2*0.6, fontFamily: 'Poppins'),),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class TransInvoice extends StatelessWidget {

  const TransInvoice({
    Key key,
    this.data,
    this.flatIndex
  }) : super(key: key);

  final data;
  final flatIndex;

  @override
  Widget build(BuildContext context) {
    var size_2 = MediaQuery.of(context).size.width * 0.05;
    var icon = 'invoice';

    var a = data['transactionDate'].toString().substring(0, 10);
    DateTime dateParsed = new DateFormat("yyyy-MM-dd").parse(a);
    var time;
    DateTime timeParsed = new DateFormat("hh:mm").parse(data['createdAt'].toString().substring(11, 16));
    if(timeParsed.hour <= 12){
      time = "${data['createdAt'].toString().substring(11, 16)} am";
    }
    else{
      time = "${data['createdAt'].toString().substring(11, 16)} pm";
    }

    return RawMaterialButton(
      onPressed: (){
        showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return DraggableScrollableSheet(
                  initialChildSize: 0.55, //set this as you want
                  maxChildSize: 0.95, //set this as you want
                  minChildSize: 0.5, //set this as you want
                  expand: false,
                  builder: (context, scrollController) {
                    return Container(
                      child: ListView(
                        controller: scrollController,
                        children: [
                          Container(
                            // height: MediaQuery.of(context).size.height * 0.4,
                            margin: EdgeInsets.only(top: 30.0),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 30.0,
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        child: Center(child: Text('Invoice Status', textAlign: TextAlign.end,)),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                                          color: Color.fromRGBO(247, 124, 37, 0.13),
                                        ),
                                      ),
                                      SizedBox(width: 10.0,),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.5,
                                        height: 1.0,
                                        color: Colors.black12,
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(15.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 20.0),
                                            child: Row(
                                              children: [
                                                (icon != null) ? SvgPicture.asset('assets/$icon.svg', height: 55, width: 55,) : Icon(Icons.account_balance_wallet_rounded, size: 45.0,),
                                                SizedBox(width: 10.0,),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(width: MediaQuery.of(context).size.width * 0.4 ,child: AutoSizeText("Invoice Generated for ${Provider.of<Data>(context, listen: false).getMonthName(data['billGenerateData']['month'].toString()).substring(0, 3)}'${data['billGenerateData']['year'].toString().substring(2)}", style: TextStyle(fontFamily: 'Poppins', ),minFontSize: 15, maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: false,)),
                                                          Icon(Icons.verified, color: Colors.green, size: 20.0,),
                                                        ],
                                                      ),
                                                      SizedBox(height: 3.0,),
                                                      Text('${(dateParsed.day).toString()} ${Provider.of<Data>(context).getMonthName((dateParsed.month).toString()).substring(0, 3)}, $time', style: TextStyle(fontFamily: 'Poppins'),)
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 20.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                      style: TextStyle(fontSize: size_2*0.7, color: const Color(0xFF262626),),
                                                      children: [
                                                        TextSpan(text: '${data['debit']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: size_2*0.9, fontFamily: 'Poppins')),
                                                        TextSpan(text: ' INR', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: Color(0xFF262626), fontSize: size_2*0.5))
                                                      ]
                                                  ),
                                                  textAlign: TextAlign.end,
                                                  maxLines: 1,
                                                ),
                                                // SizedBox(height: 3.0,),
                                                (data['billGenerateData']['remaining_amt'].toString().length > 9)
                                                    ? Text('Closed with ${data['billGenerateData']['remaining_amt'].toString().substring(0, 9)} due', style: TextStyle(fontSize: size_2*0.6, fontFamily: 'Poppins', color: Color(0xFFF77C25)), textAlign: TextAlign.end)
                                                    : Text('Closed with ${data['billGenerateData']['remaining_amt']} due', style: TextStyle(fontSize: size_2*0.6, fontFamily: 'Poppins', color: Color(0xFFF77C25)), textAlign: TextAlign.end),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Text('To', style: TextStyle(fontSize: size_2 * 0.7, color: Color.fromRGBO(75, 70, 66, 0.8))),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${Provider.of<Data>(context).data['customerflatData'][flatIndex]['projectData']['name']}', style: TextStyle(fontSize: size_2),),
                                        Image.network('${Provider.of<Data>(context, listen: false).url}${Provider.of<Data>(context, listen: false).data['customerflatData'][flatIndex]['projectData']['image']}', fit: BoxFit.cover, height: 55, width: 55,),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 25.0,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              AutoSizeText('Wallet Transaction ID', maxLines: 1,),
                                              AutoSizeText('${data['transactionId']}', maxLines: 1,)
                                            ],
                                          ),
                                          flex: 5,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              AutoSizeText('Bank Reference No', maxLines: 1,),
                                              AutoSizeText('N/A', maxLines: 1,),
                                            ],
                                          ),
                                          flex: 5,
                                        )
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 20.0,),

                                  Row(
                                    children: [
                                      Container(
                                        height: 30.0,
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        child: Center(child: Text("${Provider.of<Data>(context, listen: false).getMonthName(data['billGenerateData']['month'].toString()).substring(0, 3)}'${data['billGenerateData']['year'].toString().substring(2)} Invoice", textAlign: TextAlign.end,)),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                                          color: Color.fromRGBO(247, 124, 37, 0.13),
                                        ),
                                      ),
                                      SizedBox(width: 10.0,),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.5,
                                        height: 1.0,
                                        color: Colors.black12,
                                      )
                                    ],
                                  ),

                                  SizedBox(height: 20,),
                                  Center(
                                    child: RawMaterialButton(
                                      child: Container(
                                        clipBehavior: Clip.none,
                                        height: 300,
                                        width: 300,
                                        child: SfPdfViewer.network(
                                          '${Provider.of<Data>(context, listen: false).url}/containers/invoice/download/${data['billGenerateData']['invoiceNo']}.pdf',
                                          canShowScrollHead: false,
                                          canShowScrollStatus: false,
                                        ),
                                      ),
                                      onPressed: (){},
                                      onHighlightChanged: (value){
                                        if(value){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context){
                                                return PdfViewer(invoiceNo: data['billGenerateData']['invoiceNo'],);
                                              }
                                            )
                                          );

                                        }
                                      },
                                    ),
                                  ),

                                  SizedBox(height: 20.0,),
                                  (Platform.isIOS)
                                    ? Container(height: 0,)
                                    : Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                                    child: RawMaterialButton(
                                        onPressed: () async{
                                          var msg = await Provider.of<Data>(context, listen: false).downloadInvoice(data['billGenerateData']['invoiceNo']);
                                          Fluttertoast.showToast(
                                            msg: "$msg",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                          );
                                        },
                                        child: Center(
                                          child: Container(
                                            height: 45.0,
                                            width: MediaQuery.of(context).size.width * 0.9,
                                            decoration: BoxDecoration(
                                                color: Color(0xFFF77C25),
                                                borderRadius: BorderRadius.circular(5.0)
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('Download PDF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                                  Icon(Icons.cloud_download_outlined, size: 25, color: Colors.white,)
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                    ),
                                  ),

                                ],
                              ),

                            ),
                          ),
                        ],
                      ),
                    );
                  }
              );
            }
        );
      },

      child: Tooltip(
        message: "Invoice Generated for ${Provider.of<Data>(context, listen: false).getMonthName(data['billGenerateData']['month'].toString()).substring(0, 3)}'${data['billGenerateData']['year'].toString().substring(2)}",
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 7,
              child: Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    (icon != null) ? SvgPicture.asset('assets/$icon.svg', height: 55, width: 55,) : Icon(Icons.account_balance_wallet_rounded, size: 45.0,),
                    SizedBox(width: 10.0,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Invoice Generated for ${Provider.of<Data>(context, listen: false).getMonthName(data['billGenerateData']['month'].toString()).substring(0, 3)}'${data['billGenerateData']['year'].toString().substring(2)}", style: TextStyle(fontFamily: 'Poppins', fontSize: size_2*0.8), maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: false,),
                          SizedBox(height: 3.0,),
                          Text('${(dateParsed.day).toString()} ${Provider.of<Data>(context).getMonthName((dateParsed.month).toString()).substring(0, 3)}, $time', style: TextStyle(fontFamily: 'Poppins'),)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                          style: TextStyle(fontSize: size_2*0.7, color: const Color(0xFF262626),),
                          children: [
                            TextSpan(text: '${data['debit']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: size_2*0.9, fontFamily: 'Poppins')),
                            TextSpan(text: ' INR', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: Color(0xFF262626), fontSize: size_2*0.5))
                          ]
                      ),
                      textAlign: TextAlign.end,
                      maxLines: 1,
                    ),
                    // SizedBox(height: 3.0,),
                    (data['billGenerateData']['remaining_amt'].toString().length > 9)
                        ? Text('Closed with ${data['billGenerateData']['remaining_amt'].toString().substring(0, 9)} due', style: TextStyle(fontSize: size_2*0.6, fontFamily: 'Poppins', color: Color(0xFFF77C25)), textAlign: TextAlign.end,)
                        : Text('Closed with ${data['billGenerateData']['remaining_amt']} due', style: TextStyle(fontSize: size_2*0.6, fontFamily: 'Poppins', color: Color(0xFFF77C25)), textAlign: TextAlign.end),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}