import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smart_meter/components/transactionsList.dart';
import 'package:smart_meter/data.dart';

class Transactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size_1 = MediaQuery.of(context).size.width * 0.03;
    var size_2 = MediaQuery.of(context).size.width * 0.07;
    var flatIndex = Provider.of<Data>(context).flatIndex;

    return Expanded(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.12, left: 15, right: 15, bottom: 15),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.04,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RawMaterialButton(
                            onPressed: (){
                              // var currentDate = Provider.of<Data>(context, listen: false).counterDate;
                              // Provider.of<Data>(context, listen:false).setTransactions();
                              // Provider.of<Data>(context, listen: false).getTransactions(currentDate.month.toString(), currentDate.year.toString());
                            },
                            child: AutoSizeText('Statement History', maxLines: 1, style: TextStyle(fontFamily: 'Poppins'),)
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                        onRefresh: Provider.of<Data>(context, listen: false).refreshTransactions,
                        child: TransactionsList()
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: -60.0,
            left: 0.0,
            right: 0.0,
            // child: TransPostCard(size_2: size_2, size_1: size_1),
            child: (Provider.of<Data>(context, listen: true).data['customerflatData'][flatIndex]['projectData']['projectUtilityType'] == 1000)
                ? TransPreCard(size_2: size_2, size_1: size_1) : (Provider.of<Data>(context).data['customerflatData'][flatIndex]['projectData']['projectUtilityType'] == 1001) ? TransPostCard(size_2: size_2, size_1: size_1) : TransPrePost(),
          )
        ],
      ),
    );
  }
}

class TransPreCard extends StatelessWidget {
  const TransPreCard({
    Key key,
    @required this.size_2,
    @required this.size_1,
  }) : super(key: key);

  final double size_2;
  final double size_1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.175,
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
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Wallet Balance', style: TextStyle(fontSize: size_2*0.8, fontFamily: 'Poppins'),),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: size_1, color: const Color(0xFF262626),),
                          children: [
                            TextSpan(text: '${Provider.of<Data>(context).dashboardData['prepaiddata']['balence']}', style: TextStyle(fontSize: size_2*0.9, fontFamily: 'Poppins', fontWeight: FontWeight.bold), ),
                            TextSpan(text: ' INR ', style: TextStyle(fontSize: size_2*0.6, fontFamily: 'Poppins', fontWeight: FontWeight.bold), )
                          ]
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                color: Color(0xFFfef2e9),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        RichText(
                          text: TextSpan(
                              style: TextStyle(fontSize: size_1, color: const Color(0xFF262626),),
                              children: [
                                TextSpan(text: 'Last recharge on ', style: TextStyle(fontSize: size_1, fontFamily: 'Poppins'),),
                                TextSpan(text: "${Provider.of<Data>(context).dashboardData['prepaiddata']['lastrechargedate']}", style: TextStyle(fontSize: size_1, fontFamily: 'Poppins', fontWeight: FontWeight.bold),)
                              ]
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Fluttertoast.showToast(
                              msg: "Please Contact Admin for Payments",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Recharge', style: TextStyle(fontSize: size_1*1.2, fontFamily: 'Poppins', color: Color(0xFFF77C25)),),
                              Icon(Icons.arrow_forward, size: size_1*1.2, color: Color(0xFFF77C25),)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}

class TransPrePost extends StatelessWidget {
  const TransPrePost({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size_1 = MediaQuery.of(context).size.height * 0.013;
    var size_2 = MediaQuery.of(context).size.height * 0.025;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.175,
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
              flex: 70,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 500,
                      child: Container(
                        clipBehavior: Clip.none,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 5.0, right: 10.0, bottom: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Prepaid', style: TextStyle(color: Color(0xFFF77C25), fontSize: size_1),),
                              Text('Balance', style: TextStyle(fontSize: size_1),),
                              RichText(
                                  text: TextSpan(
                                      style: TextStyle(fontSize: size_1, color: const Color(0xFF262626),),
                                      children: [
                                        TextSpan(text: '${Provider.of<Data>(context).dashboardData['prepaiddata']['balence']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: size_2*0.8, color: const Color(0xFF262626))),
                                        TextSpan(text: ' INR')
                                      ]
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(flex: 1, child: Divider(height: 2.0, thickness: MediaQuery.of(context).size.height * 0.1, color: Colors.black12,)),
                    Expanded(
                      flex: 500,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 5.0, right: 0.0, bottom: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Postpaid', style: TextStyle(color: const Color(0xFFF77C25), fontSize: size_1),),
                                    Text("Remaining Amount", style: TextStyle(fontSize: size_1*0.8),),
                                    RichText(
                                        text: TextSpan(
                                            style: TextStyle(fontSize: size_1, color: const Color(0xFF262626),),
                                            children: [
                                              TextSpan(text: '${Provider.of<Data>(context).dashboardData['postpaiddata']['remainingAmount']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: size_2, color: const Color(0xFF262626))),
                                              TextSpan(text: ' INR')
                                            ]
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 30,
                child: Container(
                  color: const Color(0xFFfef2e9),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: GestureDetector(
                              onTap: (){
                                Fluttertoast.showToast(
                                  msg: "Please Contact Admin for Payments",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Recharge ", style: TextStyle(color: Color(0xFFF77C25), fontSize: size_1)),
                                  Icon(Icons.arrow_forward, size: size_1*1.2, color: Color(0xFFF77C25),),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: GestureDetector(
                              onTap: (){
                                Fluttertoast.showToast(
                                  msg: "Please Contact Admin for Payments",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Pay Now ", style: TextStyle(color: Color(0xFFF77C25), fontSize: size_1)),
                                  Icon(Icons.arrow_forward, size: size_1*1.2, color: Color(0xFFF77C25),),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}

class TransPostCard extends StatelessWidget {
  const TransPostCard({
    Key key,
    @required this.size_2,
    @required this.size_1,
  }) : super(key: key);

  final double size_2;
  final double size_1;

  @override
  Widget build(BuildContext context) {
    var nowDate = DateTime.parse(new DateTime.now().toString());
    nowDate = new DateTime(nowDate.year, nowDate.month-1, nowDate.day);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.175,
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
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("${Provider.of<Data>(context, listen: false).getMonthName(nowDate.month.toString()).toString().substring(0, 3)}'${nowDate.year.toString().substring(2)} due amount", style: TextStyle(fontSize: size_2*0.7, fontFamily: 'Poppins'),),
                      RichText(
                        text: TextSpan(
                            style: TextStyle(fontSize: size_1, color: const Color(0xFF262626),),
                            children: [
                              TextSpan(text: '${Provider.of<Data>(context).dashboardData['postpaiddata']['invoiceAmount']}', style: TextStyle(fontSize: size_2*0.9, fontFamily: 'Poppins', fontWeight: FontWeight.bold), ),
                              TextSpan(text: ' INR ', style: TextStyle(fontSize: size_2*0.6, fontFamily: 'Poppins', fontWeight: FontWeight.bold), )
                            ]
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 3,
                child: Container(
                  color: Color(0xFFfef2e9),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          RichText(
                            text: TextSpan(
                                style: TextStyle(fontSize: size_1, color: const Color(0xFF262626),),
                                children: [
                                  TextSpan(text: 'Due on ', style: TextStyle(fontSize: size_1, fontFamily: 'Poppins'),),
                                  TextSpan(text: "${Provider.of<Data>(context).dashboardData['postpaiddata']['duedate']}", style: TextStyle(fontSize: size_1, fontFamily: 'Poppins', fontWeight: FontWeight.bold),)
                                ]
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Fluttertoast.showToast(
                                msg: "Please Contact Admin for Payments",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Pay Now', style: TextStyle(fontSize: size_1*1.2, fontFamily: 'Poppins', color: Color(0xFFF77C25)),),
                                Icon(Icons.arrow_forward, size: size_1*1.2, color: Color(0xFFF77C25),)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}