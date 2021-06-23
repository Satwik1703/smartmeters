import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smart_meter/components/transUtility.dart';
import 'package:smart_meter/data.dart';
import 'package:intl/intl.dart';

class TransactionsList extends StatefulWidget {
  @override
  _TransactionsListState createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  ScrollController _controller;

  @override
  void initState() {
    if(Provider.of<Data>(context, listen:false).transactions.isEmpty){
      var currentDate = Provider.of<Data>(context, listen: false).counterDate;
      Provider.of<Data>(context, listen:false).setTransactions();
      Provider.of<Data>(context, listen: false).getTransactions(currentDate.month.toString(), currentDate.year.toString());

      Provider.of<Data>(context, listen: false).updateCounterDate();
      var m = Provider.of<Data>(context, listen: false).counterDate.month.toString();
      var y = Provider.of<Data>(context, listen: false).counterDate.year.toString();
      Provider.of<Data>(context, listen: false).getTransactions(m, y);
    }

    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      Provider.of<Data>(context, listen: false).updateCounterDate();
      var m = Provider.of<Data>(context, listen: false).counterDate.month.toString();
      var y = Provider.of<Data>(context, listen: false).counterDate.year.toString();
      Provider.of<Data>(context, listen: false).getTransactions(m, y);
    }
  }

  @override
  Widget build(BuildContext context) {
    var flatIndex = Provider.of<Data>(context).flatIndex;

    return (Provider.of<Data>(context).transactions.length > 0) ?
      ListView.builder(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: EdgeInsets.only(top: 0),
      controller: _controller,
      itemCount: Provider.of<Data>(context).transactions.length,
      itemBuilder: (context, index){
        return Container(
          margin: EdgeInsets.only(top: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // (Provider.of<Data>(context).transactions.length > index)
              // ? Text('${Provider.of<Data>(context).getMonthName((Provider.of<Data>(context).transactions[index][0]['transactionDate']).toString().substring(5, 7))}') : Container(height: 0,),
              // SizedBox(height: 5.0,),
              ListView.builder(
                padding: EdgeInsets.only(top: 0),
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: Provider.of<Data>(context).transactions[index].length,
                itemBuilder: (context, ind){
                  return (Provider.of<Data>(context).transactions[index][ind]['Description'] == 'Invoice')
                      ? TransInvoice(data: Provider.of<Data>(context).transactions[index][ind], flatIndex: flatIndex,)
                      : (Provider.of<Data>(context).transactions[index][ind]['Description'] == 'Payment')
                        ? TransPayment(data: Provider.of<Data>(context).transactions[index][ind], flatIndex: flatIndex,)
                        : TransUtility(data: Provider.of<Data>(context).transactions[index][ind], flatIndex: flatIndex,);
                },
              )
            ],
          ),
        );
      },
    ) : Container();
  }
}


