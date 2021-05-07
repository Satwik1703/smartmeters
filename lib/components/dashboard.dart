import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_meter/components/card.dart';
import 'package:smart_meter/components/utilities.dart';
import 'package:smart_meter/data.dart';

class Dashboard extends StatelessWidget {
  // const Dashboard({
  //   Key key,
  //   @required GlobalKey<RefreshIndicatorState> refreshIndicatorKey,
  // }) : _refreshIndicatorKey = refreshIndicatorKey, super(key: key);
  //
  // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;

  @override
  Widget build(BuildContext context) {
    var flatIndex = Provider.of<Data>(context).flatIndex;
    return Expanded(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15, left: 15, right: 15, bottom: 15),
                child: Column(
                  children: [
                    UtilitySummaryRow(),
                    Expanded(
                        child: RefreshIndicator(
                          // key: _refreshIndicatorKey,
                            onRefresh: Provider.of<Data>(context, listen: false).refreshData,
                            child: Utilities()
                        )
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -60.0,
              left: 0.0,
              right: 0.0,
              child: (Provider.of<Data>(context, listen: true).data['customerflatData'][flatIndex]['projectData']['projectUtilityType'] == 1000)
                  ? PrepaidCard() : (Provider.of<Data>(context).data['customerflatData'][flatIndex]['projectData']['projectUtilityType'] == 1001) ? PostPaid() : PrePost(),
            )
          ],
        )
    );
  }
}

class UtilitySummaryRow extends StatelessWidget {
  const UtilitySummaryRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.04,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoSizeText('Utility Summary', maxLines: 1, style: TextStyle(fontFamily: 'Poppins'),),
          RawMaterialButton(
            onPressed: (){
              if(Provider.of<Data>(context, listen: false).dropdownValue == 'Today'){
                Provider.of<Data>(context, listen: false).dropdownChange('Week');
              }
              else if(Provider.of<Data>(context, listen: false).dropdownValue == 'Week'){
                Provider.of<Data>(context, listen: false).dropdownChange('Month');
              }
              else if(Provider.of<Data>(context, listen: false).dropdownValue == 'Month'){
                Provider.of<Data>(context, listen: false).dropdownChange('Year');
              }
              else if(Provider.of<Data>(context, listen: false).dropdownValue == 'Year'){
                Provider.of<Data>(context, listen: false).dropdownChange('Today');
              }
            },
            elevation: 2,
            padding: EdgeInsets.only(right: 0.0, left: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AutoSizeText('${Provider.of<Data>(context).dropdownValue}', maxLines: 1,),
                Icon(Icons.arrow_drop_down)
              ],
            ),
          )
        ],
      ),
    );
  }
}