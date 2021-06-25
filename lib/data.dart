import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform, stdout;
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'components/utilities.dart';

class Data extends ChangeNotifier {
  // var url = 'http://18.136.149.198:3074/api'; //Dev url
  var url = 'https://pertsmartcommunity.com:3074/api';  //Production url

  var mobile_number = '';
  var otp = '';
  var flatIndex = 0;
  var dashboardData;
  var data;
  var multipleData;
  var dropdownData = new List(4);
  var dropdownValue = 'Today';
  var graphData;
  List<SalesData> chartData;
  var radioButtomValue = 'yearlySum';
  var barData;
  var barDataYear;
  List<TableRow> tableData;
  var transactions = new List();
  var start;
  var end;
  var consumed;
  var rechargeAmt = 0.0;
  var invoicePay = "full";

  var date = new DateTime.now().toString();
  var dateParse;

  var counterDate = DateTime.parse(new DateTime.now().toString());


  void changeMobileNumber(String number) {
    mobile_number = number;
    notifyListeners();
  }

  void changeOtp(String value) {
    otp = value;
    notifyListeners();
  }

  void setFlatIndex(value) {
    flatIndex = value;

    dropdownData = new List(4);
    getDashboardData();
    dropdownValue = 'Today';

    setTransactions();
    getTransactions(counterDate.month.toString(), counterDate.year.toString());

    notifyListeners();
  }

  Future<void> setData(String value) async{
    data = json.decode(value);
    return;
  }

  void changeDropdownValue(String value) {
    dropdownValue = value;
    notifyListeners();
  }

  void setBarData(){
    barData = null;
  }

  void setTransactions() {
    transactions = new List();
    counterDate = DateTime.parse(new DateTime.now().toString());
  }

  void updateCounterDate(){
    counterDate = new DateTime(counterDate.year, counterDate.month-1, counterDate.day);
    // notifyListeners();
  }

  void setReading(){
    start = 0.0;
    end = 0.0;
    consumed = 0.0;
  }



  int isoWeekNumber(DateTime date) {
    int daysToAdd = DateTime.thursday - date.weekday;
    DateTime thursdayDate = daysToAdd > 0 ? date.add(Duration(days: daysToAdd)) : date.subtract(Duration(days: daysToAdd.abs()));
    int dayOfYearThursday = dayOfYear(thursdayDate);
    return 1 + ((dayOfYearThursday - 1) / 7).floor();
  }
  int dayOfYear(DateTime date) {
    return date.difference(DateTime(date.year, 1, 1)).inDays;
  }




  Future<String> getOtp() async {
    http.Response response = await http.get(
      '$url/customers/getOtp?mobileno=$mobile_number&deviceId=12345&platformType=android'
    );
    var res = json.decode(response.body);
    if(res['success'] == true){
      otp = res['otp'];
      return res['otp'];
    }
    else {
      return "Error";
    }
  }

  Future<String> validateOtp() async {
    http.Response response = await http.post(
      '$url/customers/validateOtp',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "mobileno": mobile_number,
        "otp": otp,
      })
    );

    var res = json.decode(response.body);
    data = res;
    notifyListeners();

    if(res['error'] != null){
      return "Error";
    }
    if(res['firstName'] != null){
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('data', json.encode(data));

      return "Success";
    }
    return "Error";
  }
  
  Future<void> getDashboardData() async{
    try{
      WidgetsFlutterBinding.ensureInitialized();
      await FlutterDownloader.initialize(
          debug: true // optional: set false to disable printing logs to console
      );
    }
    catch (e){
      print('Initialize warning');
    }

    http.Response response = await http.post(
        '$url/meterDataSummaries/getCustomerData?token=${data['token']}',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "flatId": data['customerflatData'][flatIndex]['flatId'],
          "blockId": data['customerflatData'][flatIndex]['blockId'],
          "projectId": data['customerflatData'][flatIndex]['projectId'],
          "requestType": "day",
          "customerId": data['customerflatData'][flatIndex]['customerId'],
        })
    );

    var res = json.decode(response.body);
    dashboardData = res;
    dashboardData['postpaiddata']['remainingAmount'] = (dashboardData['postpaiddata']['remainingAmount'].toString().length > 8) ? dashboardData['postpaiddata']['remainingAmount'].toString().substring(0, 8) : dashboardData['postpaiddata']['remainingAmount'];
    dropdownData[0] = dashboardData;

    notifyListeners();
  }

  void dropdownChange(String value) async{
    dropdownValue = value;
    if(value == 'Today'){
      if(dropdownData[0] == null){
        getDashboardData();
      }
      else{
        dashboardData = dropdownData[0];
        notifyListeners();
      }
    }

    else if(value == 'Week'){
      if(dropdownData[1] == null){
        http.Response response = await http.post(
            '$url/meterDataSummaries/getCustomerData?token=${data['token']}',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              "flatId": data['customerflatData'][flatIndex]['flatId'],
              "blockId": data['customerflatData'][flatIndex]['blockId'],
              "projectId": data['customerflatData'][flatIndex]['projectId'],
              "requestType": "weekly",
              "week": isoWeekNumber(DateTime.now()),
              "year": '2021',
              "customerId": data['customerflatData'][flatIndex]['customerId'],
            })
        );

        var res = json.decode(response.body);
        dashboardData = res;
        dropdownData[1] = dashboardData;
        notifyListeners();
      }
      else{
        dashboardData = dropdownData[1];
        notifyListeners();
      }
    }

    else if(value == 'Month'){
      if(dropdownData[2] == null){
        http.Response response = await http.post(
            '$url/meterDataSummaries/getCustomerData?token=${data['token']}',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              "flatId": data['customerflatData'][flatIndex]['flatId'],
              "blockId": data['customerflatData'][flatIndex]['blockId'],
              "projectId": data['customerflatData'][flatIndex]['projectId'],
              "requestType": "monthly",
              "month": DateTime.now().month,
              "year": '2021',
              "customerId": data['customerflatData'][flatIndex]['customerId'],
            })
        );

        var res = json.decode(response.body);
        dashboardData = res;
        dropdownData[2] = dashboardData;
        notifyListeners();
      }
      else{
        dashboardData = dropdownData[2];
        notifyListeners();
      }
    }

    else if(value == 'Year'){
      if(dropdownData[3] == null){
        http.Response response = await http.post(
            '$url/meterDataSummaries/getCustomerData?token=${data['token']}',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              "flatId": data['customerflatData'][flatIndex]['flatId'],
              "blockId": data['customerflatData'][flatIndex]['blockId'],
              "projectId": data['customerflatData'][flatIndex]['projectId'],
              "requestType": "yearly",
              "year": '2021',
              "customerId": data['customerflatData'][flatIndex]['customerId'],
            })
        );

        var res = json.decode(response.body);
        dashboardData = res;
        dropdownData[3] = dashboardData;
        notifyListeners();
      }
      else{
        dashboardData = dropdownData[3];
        notifyListeners();
      }
    }
    else if(value == 'Year'){
      if(dropdownData[3] == null){
        http.Response response = await http.post(
            '$url/meterDataSummaries/getCustomerData?token=${data['token']}',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              "flatId": data['customerflatData'][flatIndex]['flatId'],
              "blockId": data['customerflatData'][flatIndex]['blockId'],
              "projectId": data['customerflatData'][flatIndex]['projectId'],
              "requestType": "yearly",
              "year": '2021',
              "customerId": data['customerflatData'][flatIndex]['customerId'],
            })
        );

        var res = json.decode(response.body);
        dashboardData = res;
        dropdownData[3] = dashboardData;
        notifyListeners();
      }
      else{
        dashboardData = dropdownData[3];
        notifyListeners();
      }
    }
  }

  Future<void> refreshData() async{
    http.Response response = await http.post(
        '$url/meterDataSummaries/getCustomerData?token=${data['token']}',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "flatId": data['customerflatData'][flatIndex]['flatId'],
          "blockId": data['customerflatData'][flatIndex]['blockId'],
          "projectId": data['customerflatData'][flatIndex]['projectId'],
          "requestType": "day",
          "customerId": data['customerflatData'][flatIndex]['customerId'],
        })
    );

    dropdownValue = 'Today';
    var res = json.decode(response.body);
    dashboardData = res;
    dashboardData['postpaiddata']['remainingAmount'] = (dashboardData['postpaiddata']['remainingAmount'].toString().length > 8) ? dashboardData['postpaiddata']['remainingAmount'].toString().substring(0, 8) : dashboardData['postpaiddata']['remainingAmount'];
    dropdownData = new List(4);
    dropdownData[0] = dashboardData;

    notifyListeners();
  }

  Future<void> getGraphData(requestType, utility) async{
    dateParse =  DateTime.parse(date);
    http.Response response = await http.post(
        '$url/meterDataSummaries/getUtilitySummaryApp?token=${data['token']}',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "flatId": data['customerflatData'][flatIndex]['flatId'],
          "blockId": data['customerflatData'][flatIndex]['blockId'],
          "projectId": data['customerflatData'][flatIndex]['projectId'],
          "customerId": data['customerflatData'][flatIndex]['customerId'],
          "requestType": requestType,
          "month": dateParse.month,
          "year": dateParse.year,
        })
    );

    var res = json.decode(response.body);
    graphData = res['CummulativeData'];
    chartData = new List<SalesData>();

    for(int i=0; i<graphData.length; i++){
      String year = graphData[i]['date'];
      double sales = double.parse(graphData[i]['${utility}Cost']);
      double units = double.parse(graphData[i]['$utility']);
      chartData.add(SalesData(year, sales, units));
    }

    radioButtomValue = requestType;
    notifyListeners();
  }


  int getMonthNumber(month){
    var monthArray = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    for(int i=0; i<monthArray.length; i++){
      if(month == monthArray[i]){
        return i+1;
      }
    }
    return 1;
  }

  String getMonthName(month) {
    var monthArray = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December', '    '];
    month = int.parse(month);
    return monthArray[month-1];
  }

  Future<void> getBarData(barValue) async{
    if(radioButtomValue == 'yearlySum'){
      http.Response response = await http.post(
          '$url/meterDataSummaries/getUtilitySummaryApp?token=${data['token']}',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "flatId": data['customerflatData'][flatIndex]['flatId'],
            "blockId": data['customerflatData'][flatIndex]['blockId'],
            "projectId": data['customerflatData'][flatIndex]['projectId'],
            "customerId": data['customerflatData'][flatIndex]['customerId'],
            "requestType": 'yearly',
            "year": graphData[barValue]['date'],
          })
      );

      var res = json.decode(response.body);
      barData = res['CummulativeData'];
      barDataYear = graphData[barValue]['date'];
      notifyListeners();
    }

    else if(radioButtomValue == 'yearly'){
      http.Response response = await http.post(
          '$url/meterDataSummaries/getUtilitySummaryApp?token=${data['token']}',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "flatId": data['customerflatData'][flatIndex]['flatId'],
            "blockId": data['customerflatData'][flatIndex]['blockId'],
            "projectId": data['customerflatData'][flatIndex]['projectId'],
            "customerId": data['customerflatData'][flatIndex]['customerId'],
            "requestType": 'monthly',
            "year": dateParse.year,
            "month": getMonthNumber(graphData[barValue]['date']),
          })
      );

      var res = json.decode(response.body);
      barData = res['CummulativeData'];
      notifyListeners();
    }

    else if(radioButtomValue == 'weeklySum'){
      http.Response response = await http.post(
          '$url/meterDataSummaries/getUtilitySummaryApp?token=${data['token']}',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "flatId": data['customerflatData'][flatIndex]['flatId'],
            "blockId": data['customerflatData'][flatIndex]['blockId'],
            "projectId": data['customerflatData'][flatIndex]['projectId'],
            "customerId": data['customerflatData'][flatIndex]['customerId'],
            "requestType": 'weekly',
            "year": dateParse.year,
            "week": graphData[barValue]['date'],
          })
      );

      var res = json.decode(response.body);
      barData = res['CummulativeData'];
      notifyListeners();
    }

    notifyListeners();
  }

  Future<void> refreshTransactions() async{
    setTransactions();
    await getTransactions(counterDate.month.toString(), counterDate.year.toString());
    await refreshData();
  }

  Future<void> getTransactions(month, year) async{
    http.Response response = await http.get(
        '$url/ledgers/getTransactionDataApp?flatId=${data['customerflatData'][flatIndex]['flatId']}&year=$year&month=$month&token=${data['token']}',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
    );

    var res = json.decode(response.body);
    if(res != null || res != [] || res.toString().length > 1 || res){
      transactions.add(res);
      notifyListeners();
    }
  }

  Future<void> getReadings(flatId, blockId, date, utility, ) async{
    http.Response response = await http.get(
      '$url/deviceflats/getUntitsData?&projectId=${data['customerflatData'][flatIndex]['projectId']}&flatId=$flatId&blockId=$blockId&date=$date&utility=$utility&token=${data['token']}',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var res = json.decode(response.body);
    start = res['startUntints'];
    end = res['endtUntits'];
    consumed = res['consumedUntints'];

    notifyListeners();
  }


  Future<String> downloadInvoice(invoiceNo) async {
    Fluttertoast.showToast(
      msg: "Download Started",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );

    String dir = (await getExternalStorageDirectory()).path;
    final taskId = await FlutterDownloader.enqueue(
      url: '$url/containers/invoice/download/$invoiceNo.pdf',
      savedDir: '$dir',
      showNotification: true, // show download progress in status bar (for Android)
      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    );

    await Future.delayed(const Duration(seconds: 2), (){});
    await FlutterDownloader.open(taskId: taskId);
    return ("Download Completed");
  }

  Future<void> logout() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> editProfile(name, mobileNo, email) async{
    if(name == ''){
      name = '${data['firstName']} ${data['lastName']}';
    }
    if(mobileNo == ''){ 
      mobileNo = '${data['mobileNo']}';
    }
    if(email == ''){
      email = '${data['email']}';
    }
    var spaceIndex = name.toString().indexOf(" ");
    var firstName = name.toString().substring(0, spaceIndex);
    var lastName = name.toString().substring(spaceIndex+1);
    var spaceNumberIndex = mobileNo.toString().indexOf(" ");
    mobileNo = mobileNo.toString().substring(spaceNumberIndex+1).trim();

    http.Response response = await http.put(
          '$url/customers/updateCustomer?token=${data['token']}',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "id": '${data['id']}',
            "firstName": '$firstName',
            "lastName": "$lastName",
            "mobileNo": "$mobileNo",
            "email": "$email",
            "address": "",
          })
      );
      var res = json.decode(response.body);

      if(res['error'] != null){
        Fluttertoast.showToast(
          msg: "${res['error']['message']}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      }
      else{
        data['firstName'] = res['firstName'];
        data['lastName'] = res['lastName'];
        data['mobileNo'] = res['mobileNo'];
        data['email'] = res['email'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        prefs.setString('data', json.encode(data));

        Fluttertoast.showToast(
          msg: "Successfully Updated",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async{
    Fluttertoast.showToast(
      msg: "Payment Successful",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );

    await refreshData();
    await refreshTransactions();
  }

  void _handlePaymentError(PaymentFailureResponse response) async{
    Fluttertoast.showToast(
      msg: "Payment Failed. Please try again",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );

    await refreshData();
    await refreshTransactions();
  }

  Future<void> showModal(BuildContext ctx) {
    final _controller = TextEditingController();

    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      isScrollControlled: true,
      elevation: 10,
      backgroundColor: Colors.white,
      context: ctx,
      builder: (ctx) => Padding(
        padding: EdgeInsets.symmetric(horizontal:18 ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 25.0,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              child: Text('Enter the Recharge Amount', style: TextStyle(fontSize: 18.0),),
            ),
            SizedBox(height: 10.0,),
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, right: MediaQuery.of(ctx).size.width*0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Amount',
                      hintStyle: TextStyle(color: Color(0xFFF77C25), fontSize: 12.0),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF77C25)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF77C25)),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF77C25)),
                      ),
                    ),
                    cursorColor: Color(0xFFF77C25),
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter(RegExp(r"^\d+\.?\d{0,2}"))
                    ],
                    onChanged: (value){},
                    controller: _controller,
                    onEditingComplete: () async{
                      var value = _controller.text;
                      if(value != ""){
                        if(double.parse(value) < 100.0){
                          Fluttertoast.showToast(
                            msg: "Minimum Amount must be Rs 100",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                          return;
                        }
                        rechargeAmt = double.parse(value);

                        var amount = (rechargeAmt * 100).toInt();
                        http.Response response = await http.post(
                          '$url/payments/createRechargeOrder?token=${data['token']}',
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                          body: jsonEncode({
                            "amount": amount,
                            "flatId": "${data['customerflatData'][flatIndex]['flatId']}",
                            "paymentId": "${data['customerflatData'][flatIndex]['projectData']['paymentGatewyId']}",
                            "paymentSecret": "${data['customerflatData'][flatIndex]['projectData']['paymentGatewySecret']}",
                            "paymentCharges": data['customerflatData'][flatIndex]['projectData']['paymentGatewayCharge']
                          })
                        );
                        var res = json.decode(response.body);
                        rechargeAmt = 0.0;

                        if(res['error'] != null){
                          if(res['error']['error'] != null){
                            Fluttertoast.showToast(
                              msg: "${res['error']['error']['description']}",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                            );
                            return;
                          }
                          else{
                            Fluttertoast.showToast(
                              msg: "${res['error']['message']}",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                            );
                            return;
                          }
                        }

                        Navigator.pop(ctx);
                        var _razorpay = Razorpay();
                        _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
                        _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
                        var options = {
                        'key': '${data['customerflatData'][flatIndex]['projectData']['paymentGatewyId']}',
                        'amount': amount,
                        'name': 'Pert InfoConsulting',
                        'description': '${data['customerflatData'][flatIndex]['projectData']['name']}',
                        'order_id': res['id'],
                        'timeout': 60*5, // in seconds
                        'prefill': {
                          'contact': (data['mobileNo'] != null) ? '${data['mobileNo']}' : "",
                          'email': (data['email'] != null) ? '${data['email']}' : "",
                          }
                        };

                        try{
                          _razorpay.open(options);
                        }
                        catch (e){
                          print('!--');
                          print(e);
                        }

                      }
                    },
                  ),
                  SizedBox(height: 15.0,),
                  AutoSizeText('* Payment gateway handling fee of ${data['customerflatData'][flatIndex]['projectData']['paymentGatewayCharge']}% is charged additionally', maxLines: 1, minFontSize: 2.0, textAlign: TextAlign.start,),
                ],
              ),
            ),
            SizedBox(height: 20.0,),
          ],
        ),

      )
    );
  }

  Future<void> showPayModal(BuildContext ctx){
    final _controller = TextEditingController();
    _controller.text = dashboardData['postpaiddata']['remainingAmount'].toString();
    final textFocus = new FocusNode();

    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      isScrollControlled: true,
      elevation: 10,
      backgroundColor: Colors.white,
      context: ctx,
      builder: (ctx) => StatefulBuilder(
        builder: (BuildContext ctx, StateSetter setState){
          return Padding(
          padding: EdgeInsets.symmetric(horizontal:18 ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 25.0,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: CustomRadioButton(
                  elevation: 0,
                  absoluteZeroSpacing: false,
                  enableShape: true,
                  unSelectedColor: Colors.white,
                  selectedBorderColor: Color(0xFFF77C25),
                  unSelectedBorderColor: Color(0xFFF77C25),
                  defaultSelected: 'full',
                  buttonLables: [
                    'Full',
                    'Partial',
                  ],
                  buttonValues: [
                    "full",
                    "partial",
                  ],
                  buttonTextStyle: ButtonTextStyle(
                      selectedColor: Colors.white,
                      unSelectedColor: Colors.black,
                      textStyle: TextStyle(fontSize: 16)),
                  radioButtonValue: (value) async{
                    invoicePay = value;
                    setState(() {
                      invoicePay = value;
                    });
                    notifyListeners();

                    if(value == 'full'){
                      _controller.text = dashboardData['postpaiddata']['remainingAmount'].toString();
                    }
                    else{
                      _controller.text = "";
                      await Future.delayed(Duration(milliseconds: 200));
                      FocusScope.of(ctx).requestFocus(textFocus);
                    }
                  },
                  selectedColor: Color(0xFFF77C25),
                ),
              ),
              SizedBox(height: 10.0,),
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 8,
                            child: TextField(
                              focusNode: textFocus,
                              decoration: InputDecoration(
                                hintText: 'Amount',
                                hintStyle: TextStyle(color: Color(0xFFF77C25), fontSize: 12.0),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFF77C25)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFF77C25)),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFF77C25)),
                                ),
                              ),
                              cursorColor: Color(0xFFF77C25),
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                WhitelistingTextInputFormatter(RegExp(r"^\d+\.?\d{0,2}"))
                              ],
                              enabled: (invoicePay == 'partial'),
                              onChanged: (value){},
                              controller: _controller,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextButton(
                              onPressed: () async{
                                if(_controller.text == "" || double.parse(_controller.text) < 100.0){
                                  Fluttertoast.showToast(
                                    msg: "Minimum Amount should be Rs 100",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                  );
                                  return;
                                }
                                var number = (dashboardData['postpaiddata']['remainingAmount'].toString() != "") ? double.parse(dashboardData['postpaiddata']['remainingAmount'].toString()) : 0.0;
                                if(double.parse(_controller.text) > number){
                                  Fluttertoast.showToast(
                                    msg: "Amount should be less than Invoice Amount",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                  );
                                  return;
                                }

                                var amount = (double.parse(_controller.text)*100).toInt();
                                var invoiceNo = (dashboardData['postpaiddata']['invoiceNo'] != null) ? dashboardData['postpaiddata']['invoiceNo'] : "";

                                http.Response response = await http.post(
                                    '$url/payments/createBillOrder?token=${data['token']}',
                                    headers: <String, String>{
                                      'Content-Type': 'application/json; charset=UTF-8',
                                    },
                                    body: jsonEncode({
                                      "amount": amount,
                                      "invoiceNo": invoiceNo,
                                      "partial_payment": false,
                                      "paymentId": "${data['customerflatData'][flatIndex]['projectData']['paymentGatewyId']}",
                                      "paymentSecret": "${data['customerflatData'][flatIndex]['projectData']['paymentGatewySecret']}",
                                      "paymentCharges": data['customerflatData'][flatIndex]['projectData']['paymentGatewayCharge'],
                                    })
                                );
                                var res = json.decode(response.body);

                                if(res['error'] != null){
                                  if(res['error']['error'] != null){
                                    Fluttertoast.showToast(
                                      msg: "${res['error']['error']['description']}",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                    );
                                    return;
                                  }
                                  else{
                                    Fluttertoast.showToast(
                                      msg: "${res['error']['message']}",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                    );
                                    return;
                                  }
                                }

                                Navigator.pop(ctx);
                                var _razorpay = Razorpay();
                                _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
                                _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
                                var options = {
                                  'key': '${data['customerflatData'][flatIndex]['projectData']['paymentGatewyId']}',
                                  'amount': amount,
                                  'name': 'Pert InfoConsulting',
                                  'description': '${data['customerflatData'][flatIndex]['projectData']['name']}',
                                  'order_id': res['id'],
                                  'timeout': 60*5, // in seconds
                                  'prefill': {
                                    'contact': (data['mobileNo'] != null) ? '${data['mobileNo']}' : "",
                                    'email': (data['email'] != null) ? '${data['email']}' : "",
                                  }
                                };

                                try{
                                  _razorpay.open(options);
                                }
                                catch (e){
                                  print(e);
                                }
                              },
                              style: ButtonStyle(overlayColor: MaterialStateProperty.all(Color.fromRGBO(247, 124, 37, 0.5))),
                              child: Container(
                                width: double.infinity,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  color: Colors.white,
                                ),
                                child: Center(child: AutoSizeText('Go', style: TextStyle(color: Color(0xFFF77C25)),))
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0,),
                    AutoSizeText('* Payment gateway handling fee of ${data['customerflatData'][flatIndex]['projectData']['paymentGatewayCharge']}% is charged additionally', maxLines: 1, minFontSize: 2.0, textAlign: TextAlign.start,),
                  ],
                ),
              ),
              SizedBox(height: 20.0,),
            ],
          ),
        );
        }
      )
    ).then((value) async{
      invoicePay = 'full';
    });
  }

  void paymentGateway(context, flag) async{
    try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          if(!flag){
            await showModal(context);
          }
          else{
            await showPayModal(context);
          }
        }
      } on SocketException catch (_) {
        Fluttertoast.showToast(
          msg: "Please Check Your Internet Connection",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }

    // if(!flag){
    //   try {
    //     final result = await InternetAddress.lookup('google.com');
    //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    //       await showModal(context);
    //     }
    //   } on SocketException catch (_) {
    //     Fluttertoast.showToast(
    //       msg: "Please Check Your Internet Connection",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //     );
    //   }
    // }
    // else{
    //   try {
    //     final result = await InternetAddress.lookup('google.com');
    //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    //     }
    //   } on SocketException catch (_) {
    //     Fluttertoast.showToast(
    //       msg: "Please Check Your Internet Connection",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //     );
    //     return;
    //   }
    //
    //   await showPayModal(context);
    //
    //   // var number = dashboardData['postpaiddata']['remainingAmount'].toString();
    //   // if(number == "" || double.parse(number) < 100.0){
    //   //   Fluttertoast.showToast(
    //   //     msg: "Minimum Amount should be Rs 100",
    //   //     toastLength: Toast.LENGTH_SHORT,
    //   //     gravity: ToastGravity.BOTTOM,
    //   //   );
    //   //   return;
    //   // }
    //   // var amount = (number != "") ? (double.parse(number)*100).toInt() : 10000;
    //   // var invoiceNo = (dashboardData['postpaiddata']['invoiceNo'] != null) ? dashboardData['postpaiddata']['invoiceNo'] : "";
    //   //
    //   // http.Response response = await http.post(
    //   //     '$url/payments/createBillOrder?token=${data['token']}',
    //   //     headers: <String, String>{
    //   //       'Content-Type': 'application/json; charset=UTF-8',
    //   //     },
    //   //     body: jsonEncode({
    //   //       "amount": amount,
    //   //       "invoiceNo": invoiceNo,
    //   //       "partial_payment": true,
    //   //       "paymentId": "${data['customerflatData'][flatIndex]['projectData']['paymentGatewyId']}",
    //   //       "paymentSecret": "${data['customerflatData'][flatIndex]['projectData']['paymentGatewySecret']}",
    //   //       "paymentCharges": 2,
    //   //     })
    //   // );
    //   // var res = json.decode(response.body);
    //   //
    //   // if(res['error'] != null){
    //   //   if(res['error']['error'] != null){
    //   //     Fluttertoast.showToast(
    //   //       msg: "${res['error']['error']['description']}",
    //   //       toastLength: Toast.LENGTH_SHORT,
    //   //       gravity: ToastGravity.BOTTOM,
    //   //     );
    //   //     return;
    //   //   }
    //   //   else{
    //   //     Fluttertoast.showToast(
    //   //       msg: "${res['error']['message']}",
    //   //       toastLength: Toast.LENGTH_SHORT,
    //   //       gravity: ToastGravity.BOTTOM,
    //   //     );
    //   //     return;
    //   //   }
    //   // }
    //   //
    //   // var _razorpay = Razorpay();
    //   // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    //   // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    //   // var options = {
    //   //   'key': 'rzp_test_ITxbvBezOt6Qg8',
    //   //   'amount': amount,
    //   //   'name': 'Pert InfoConsulting',
    //   //   'description': '${data['customerflatData'][flatIndex]['projectData']['name']}',
    //   //   'order_id': res['id'],
    //   //   'timeout': 60*5, // in seconds
    //   //   'prefill': {
    //   //     'contact': (data['mobileNo'] != null) ? '${data['mobileNo']}' : "",
    //   //     'email': (data['email'] != null) ? '${data['email']}' : "",
    //   //   }
    //   // };
    //   //
    //   // try{
    //   //   _razorpay.open(options);
    //   // }
    //   // catch (e){
    //   //   print(e);
    //   // }
    // }
  }

}