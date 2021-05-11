import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'components/utilities.dart';

class Data extends ChangeNotifier {
  var url = 'http://18.136.149.198:3074/api'; //Dev url
  // var url = 'http://65.1.28.192:3074/api';  //Production url

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
    print(counterDate.month.toString() + counterDate.year.toString());
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
    // try{
    //   WidgetsFlutterBinding.ensureInitialized();
    //   await FlutterDownloader.initialize(
    //       debug: true // optional: set false to disable printing logs to console
    //   );
    // }
    // catch (e){
    //   print('Initialize warning');
    // }

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
    var monthArray = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
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
    print('$month $year');

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

    print("$start $end");
    notifyListeners();
  }


  Future<String> downloadInvoice(invoiceNo) async {
    Fluttertoast.showToast(
      msg: "Download Started",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );

    // String dir = (await getExternalStorageDirectory()).path;
    // final taskId = await FlutterDownloader.enqueue(
    //   url: '$url/containers/invoice/download/$invoiceNo.pdf',
    //   savedDir: '$dir',
    //   showNotification: true, // show download progress in status bar (for Android)
    //   openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    // );
    //
    // await Future.delayed(const Duration(seconds: 2), (){});
    // await FlutterDownloader.open(taskId: taskId);
    return ("Download Completed");
  }
}