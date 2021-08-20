import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smart_meter/data.dart';

class PrepaidCard extends StatelessWidget {
  const PrepaidCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size_1 = MediaQuery.of(context).size.height * 0.015;
    var size_2 = MediaQuery.of(context).size.height * 0.025;

    return SizedBox(
      height: (MediaQuery.of(context).size.height > 600) ? MediaQuery.of(context).size.height * 0.2 : MediaQuery.of(context).size.height * 0.23,
      // width: MediaQuery.of(context).size.width * 0.2,
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
              flex: 75,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 60,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0, top: 5.0, right: 10.0, bottom: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Monthly Limit', style: TextStyle(fontSize: size_1),),
                              RichText(
                                  text: TextSpan(
                                      style: TextStyle(fontSize: size_1, color: const Color(0xFF262626),),
                                      children: [
                                        TextSpan(text: '${Provider.of<Data>(context).dashboardData['meterdata']['TotalCost']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: size_2, color: const Color(0xFF262626))),
                                        TextSpan(text: '/6000')
                                      ]
                                  )
                              ),
                              LinearProgressIndicator(
                                  backgroundColor: const Color(0xFFECECEC),
                                  valueColor: AlwaysStoppedAnimation(const Color(0xFFF77C25)),
                                  minHeight: 20,
                                  value: (Provider.of<Data>(context).dashboardData['meterdata']['TotalCost'].runtimeType != String)
                                      ? (Provider.of<Data>(context).dashboardData['meterdata']['TotalCost'] / 6000)
                                      : (double.parse(Provider.of<Data>(context).dashboardData['meterdata']['TotalCost']) / 6000)
                              ),
                              // Text('Safe to Spend 400/day', style: TextStyle(fontSize: size_1),)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 40,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 5.0, right: 0.0, bottom: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Yesterday Cost", style: TextStyle(fontSize: size_1*0.8),),
                                    RichText(
                                        text: TextSpan(
                                            style: TextStyle(fontSize: size_1, color: const Color(0xFF262626),),
                                            children: [
                                              TextSpan(text: '${Provider.of<Data>(context).dashboardData['prepaiddata']['cost']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: size_2, color: const Color(0xFF262626))),
                                              TextSpan(text: ' INR')
                                            ]
                                        )
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Balance", style: TextStyle(fontSize: size_1),),
                                    RichText(
                                        text: TextSpan(
                                            style: TextStyle(fontSize: size_1, color: const Color(0xFF262626),),
                                            children: [
                                              TextSpan(text: '${Provider.of<Data>(context).dashboardData['prepaiddata']['balence']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: size_2, color: const Color(0xFF262626))),
                                              TextSpan(text: ' INR')
                                            ]
                                        )
                                    ),
                                  ],
                                ),
                              )
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
                flex: 25,
                child: Container(
                  color: const Color(0xFFfef2e9),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10, right: 30),
                    child: GestureDetector(
                      onTap: (){
                        Provider.of<Data>(context, listen: false).paymentGateway(context, false);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FittedBox(fit: BoxFit.fitWidth, child: Text("Last Recharged on ${Provider.of<Data>(context).dashboardData['prepaiddata']['lastrechargedate']}")),
                          FittedBox(fit: BoxFit.fitWidth,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Recharge", style: TextStyle(color: Color(0xFFF77C25)),),
                                  Icon(Icons.arrow_forward, size: size_1*1.2, color: Color(0xFFF77C25),)
                                ],
                              )
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

class PostPaid extends StatelessWidget {
  const PostPaid({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size_1 = MediaQuery.of(context).size.height * 0.015;
    var size_2 = MediaQuery.of(context).size.height * 0.025;

    return SizedBox(
      height: (MediaQuery.of(context).size.height > 600) ? MediaQuery.of(context).size.height * 0.2 : MediaQuery.of(context).size.height * 0.23,
      // width: MediaQuery.of(context).size.width * 0.2,
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
              flex: 75,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 60,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0, top: 5.0, right: 10.0, bottom: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Monthly Limit', style: TextStyle(fontSize: size_1),),
                              RichText(
                                  text: TextSpan(
                                      style: TextStyle(fontSize: size_1, color: const Color(0xFF262626),),
                                      children: [
                                        TextSpan(text: '${Provider.of<Data>(context).dashboardData['meterdata']['TotalCost']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: size_2, color: const Color(0xFF262626))),
                                        TextSpan(text: '/6000')
                                      ]
                                  )
                              ),
                              LinearProgressIndicator(
                                  backgroundColor: const Color(0xFFECECEC),
                                  valueColor: AlwaysStoppedAnimation(const Color(0xFFF77C25)),
                                  minHeight: 20,
                                  value: (Provider.of<Data>(context).dashboardData['meterdata']['TotalCost'].runtimeType != String)
                                      ? (Provider.of<Data>(context).dashboardData['meterdata']['TotalCost'] / 6000)
                                      : (double.parse(Provider.of<Data>(context).dashboardData['meterdata']['TotalCost']) / 6000)
                              ),
                              // Text('Safe to Spend 400/day', style: TextStyle(fontSize: size_1),)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 40,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 5.0, right: 0.0, bottom: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Due Amount", style: TextStyle(fontSize: size_1),),
                                    RichText(
                                        text: TextSpan(
                                            style: TextStyle(fontSize: size_1, color: const Color(0xFF262626),),
                                            children: [
                                              TextSpan(text: '${Provider.of<Data>(context).dashboardData['postpaiddata']['invoiceAmount']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: size_2, color: const Color(0xFF262626))),
                                              TextSpan(text: ' INR')
                                            ]
                                        )
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Balance", style: TextStyle(fontSize: size_1),),
                                    RichText(
                                        text: TextSpan(
                                            style: TextStyle(fontSize: size_1, color: const Color(0xFF262626),),
                                            children: [
                                              TextSpan(text: '${Provider.of<Data>(context).dashboardData['postpaiddata']['remainingAmount']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: size_2, color: const Color(0xFF262626))),
                                              TextSpan(text: ' INR'),
                                            ]
                                        )
                                    ),
                                  ],
                                ),
                              )
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
                flex: 25,
                child: Container(
                  color: const Color(0xFFfef2e9),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10, right: 30),
                    child: GestureDetector(
                      onTap: (){
                        Provider.of<Data>(context, listen: false).paymentGateway(context, true);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FittedBox(fit: BoxFit.fitWidth, child: Text("Due on ${Provider.of<Data>(context).dashboardData['postpaiddata']['duedate']}")),
                          FittedBox(fit: BoxFit.fitWidth,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Pay Now", style: TextStyle(color: Color(0xFFF77C25)),),
                                  Icon(Icons.arrow_forward, color: Color(0xFFF77C25), size: size_1*1.2,)
                                ],
                              )
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

class PrePost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size_1 = MediaQuery.of(context).size.height * 0.013;
    var size_2 = MediaQuery.of(context).size.height * 0.025;

    ScrollController scrollController = ScrollController(
      initialScrollOffset: 20,
      keepScrollOffset: true,
    );
    return SizedBox(
      height: (MediaQuery.of(context).size.height > 600) ? MediaQuery.of(context).size.height * 0.21 : MediaQuery.of(context).size.height * 0.23,
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
              flex: 75,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Prepaid', style: TextStyle(color: Color(0xFFF77C25), fontSize: size_1),),
                              Text('Yesterday Cost', style: TextStyle(fontSize: size_1),),
                              RichText(
                                  text: TextSpan(
                                      style: TextStyle(fontSize: size_1, color: const Color(0xFF262626)),
                                      children: [
                                        TextSpan(text: '${Provider.of<Data>(context).dashboardData['prepaiddata']['cost']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: size_2*0.9, color: const Color(0xFF262626))),
                                        TextSpan(text: ' INR')
                                      ]
                                  )
                              ),
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
                                    Text("Due Amount", style: TextStyle(fontSize: size_1),),
                                    RichText(
                                        text: TextSpan(
                                            style: TextStyle(fontSize: size_1, color: const Color(0xFF262626),),
                                            children: [
                                              TextSpan(text: '${Provider.of<Data>(context).dashboardData['postpaiddata']['invoiceAmount']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: size_2*0.9, color: const Color(0xFF262626))),
                                              TextSpan(text: ' INR')
                                            ]
                                        )
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Balance", style: TextStyle(fontSize: size_1),),
                                    RichText(
                                        text: TextSpan(
                                            style: TextStyle(fontSize: size_1, color: const Color(0xFF262626),),
                                            children: [
                                              TextSpan(text: '${Provider.of<Data>(context).dashboardData['postpaiddata']['remainingAmount']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: size_2*0.8, color: const Color(0xFF262626))),
                                              TextSpan(text: ' INR'),
                                            ]
                                        )
                                    ),
                                  ],
                                ),
                              )
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
                flex: 25,
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
                                Provider.of<Data>(context, listen: false).paymentGateway(context, false);
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
                                Provider.of<Data>(context, listen: false).paymentGateway(context, true);
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


