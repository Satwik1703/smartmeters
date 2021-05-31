import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smart_meter/data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class Utilities extends StatelessWidget {
  const Utilities({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 0.0),
      children: [
        (Provider.of<Data>(context).dashboardData['meterdata']['EB'] != null) ?
        Utility(
            name: 'Electricity',
            short: 'EB',
            icon: '11475.svg',
            bill: Provider.of<Data>(context).dashboardData['meterdata']['EB'],
            units: 'KWh',
            cost: Provider.of<Data>(context).dashboardData['meterdata']['EBCost'],
            currentUnits: Provider.of<Data>(context).dashboardData['meterdata']['EBCurrentUnits'],
            updateTime: Provider.of<Data>(context).dashboardData['meterdata']['EBUpdateTime'],
        ) : Container(height: 0,),
        (Provider.of<Data>(context).dashboardData['meterdata']['DG'] != null) ?
        Utility(
            name: 'Generator',
            short: 'DG',
            icon: '11474.svg',
            bill: Provider.of<Data>(context).dashboardData['meterdata']['DG'],
            units: 'KWh',
            cost: Provider.of<Data>(context).dashboardData['meterdata']['DGCost'],
            currentUnits: Provider.of<Data>(context).dashboardData['meterdata']['DGCurrentUnits'],
            updateTime: Provider.of<Data>(context).dashboardData['meterdata']['DGUpdateTime'],
        ) : Container(height: 0,),
        (Provider.of<Data>(context).dashboardData['meterdata']['TWM'] != null) ?
        Utility(
            name: 'Drinking Water',
            short: 'TWM',
            icon: 'drinking.svg',
            bill: Provider.of<Data>(context).dashboardData['meterdata']['TWM'],
            units: 'Ltr',
            cost: Provider.of<Data>(context).dashboardData['meterdata']['TWMCost'],
            currentUnits: Provider.of<Data>(context).dashboardData['meterdata']['TWMCurrentUnits'],
            updateTime: Provider.of<Data>(context).dashboardData['meterdata']['TWMUpdateTime'],
        ) : Container(height: 0,),
        (Provider.of<Data>(context).dashboardData['meterdata']['MWM'] != null) ?
        Utility(
            name: 'Domestic Water',
            short: 'MWM',
            icon: '11527.svg',
            bill: Provider.of<Data>(context).dashboardData['meterdata']['MWM'],
            units: 'Ltr',
            cost: Provider.of<Data>(context).dashboardData['meterdata']['MWMCost'],
            currentUnits: Provider.of<Data>(context).dashboardData['meterdata']['MWMCurrentUnits'],
            updateTime: Provider.of<Data>(context).dashboardData['meterdata']['MWMUpdateTime'],
        ) : Container(height: 0,),
        Maintenance(
            icon: 'maintenance.svg',
            cost: Provider.of<Data>(context).dashboardData['meterdata']['Maintenance'],
        ),
      ],
    );
  }
}

class Utility extends StatefulWidget {
  const Utility({
    Key key,
    this.name,
    this.short,
    this.icon,
    this.bill,
    this.units,
    this.cost,
    this.currentUnits,
    this.updateTime,
  }) : super(key: key);

  final String name;
  final String short;
  final String icon;
  final bill;
  final units;
  final cost;
  final currentUnits;
  final updateTime;

  @override
  _UtilityState createState() => _UtilityState();
}

class _UtilityState extends State<Utility> {
  bool modalOpened = false;

  @override
  Widget build(BuildContext context) {
    var flatIndex = Provider.of<Data>(context).flatIndex;
    var size1 = MediaQuery.of(context).size.width * 0.04;
    var updTime = widget.updateTime;
    if(widget.updateTime.toString().length > 10){
      var a = widget.updateTime.toString().substring(0, widget.updateTime.toString().length - 1);
      var b = widget.updateTime.toString().substring(widget.updateTime.toString().length -3);
      DateTime dateParsed = new DateFormat("dd-MM-yyyy h:mm:ss").parse(a);
      var c = (dateParsed.minute.toString().length < 2) ? '0${dateParsed.minute}' : dateParsed.minute;
      updTime = '${(dateParsed.day).toString()} ${Provider.of<Data>(context, listen: false).getMonthName((dateParsed.month).toString())}, ${dateParsed.hour}:$c$b';
    }
    if(updTime.toString().length < 2){
      updTime = 'N/A';
    }

    List<TableRow> tableData;
    List<TableRow> getTableData() {
      var barData = Provider.of<Data>(context, listen: false).barData;
      if(barData == null){
        return [];
      }

      tableData = new List<TableRow>();
      var a =  TableRow(
          children: [
            Container(
              color: Color.fromRGBO(255, 242, 232, 1),
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, top: 8.0, right: 8.0, bottom: 8.0),
                child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ),
            Container(
              color: Color.fromRGBO(255, 242, 232, 1),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${widget.units}', style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ),
            Container(
              color: Color.fromRGBO(255, 242, 232, 1),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('INR', style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ),
          ]
      );
      tableData.add(a);

      for(int i=0; i<barData.length; i++){
        var object = barData[i];

        var month = object['date'];
        if(Provider.of<Data>(context, listen: false).radioButtomValue != 'yearlySum'){
          DateTime dateParsed = new DateFormat("yyyy-MM-dd").parse(object['date']);
          month = Provider.of<Data>(context).getMonthName( (dateParsed.month).toString() );
          month = month.substring(0, 3);
          month = month+"'${(dateParsed.day).toString()}";
        }
        else if(Provider.of<Data>(context, listen: false).radioButtomValue == 'yearlySum'){
          month = month.toString().substring(0,3);
          month = month + "'${(Provider.of<Data>(context).barDataYear).toString().substring(2)}";
        }

        var a =  TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0, top: 8.0, right: 8.0, bottom: 8.0),
                child: Text('$month'),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   // child: Text('${object['${short}diff']}'),
              //   child: Row(
              //     children: [
              //       (object['${widget.short}Arrow'] == "1") ? Icon(Icons.arrow_upward, color: Colors.green, size: size1,) : Icon(Icons.arrow_downward, color: Colors.red, size: size1,),
              //       Text('${object['${widget.short}diff']}%'),
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('${object[widget.short]}'),
                    (object['${widget.short}Arrow'] == "1") ? Icon(Icons.arrow_upward, color: Colors.red, size: size1,) : Icon(Icons.arrow_downward, color: Colors.green, size: size1,),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${object['${widget.short}Cost']}'),
              ),
            ]
        );

        tableData.add(a);
      }
      return tableData;
    }

    return RawMaterialButton(
      onPressed: ()async{
        await Provider.of<Data>(context, listen: false).getGraphData('yearlySum', '${widget.short}');
        Provider.of<Data>(context, listen: false).setBarData();

        if(modalOpened){
          return;
        }
        setState(() {
          modalOpened = true;
        });
        showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return graphModal(updTime, getTableData, flatIndex);
            }
        ).whenComplete(() {
          setState(() {
            modalOpened = false;
          });
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 20.0),
            child: Row(
              children: [
                SvgPicture.asset('assets/${widget.icon}', height: 55, width: 55,),
                SizedBox(width: 10.0,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.name, style: TextStyle(color: const Color(0xFFF77C25)),),
                    SizedBox(height: 5.0,),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(fontSize: 14.0, color: const Color(0xFF262626),),
                            children: [
                              TextSpan(text: '${widget.bill}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: const Color(0xFF262626), )),
                              TextSpan(text: ' ${widget.units}', style: TextStyle(fontFamily: 'Poppins'))
                            ]
                        )
                    ),
                    SizedBox(height: 3.0,),
                    Text('${widget.currentUnits}', style: TextStyle(fontFamily: 'Poppins'),)
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              margin: EdgeInsets.only(bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('', style: TextStyle(color: const Color(0xFFFE0E0E)),),
                  SizedBox(height: 5.0,),
                  // RichText(
                  //   textAlign: TextAlign.end,
                  //     text: TextSpan(
                  //         style: TextStyle(fontSize: 14.0, color: const Color(0xFF262626),),
                  //         children: [
                  //           TextSpan(text: widget.cost, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: const Color(0xFF262626), fontFamily: 'Poppins'),),
                  //           TextSpan(text: ' INR', style: TextStyle(fontFamily: 'Poppins',))
                  //         ]
                  //     )
                  // ),
                  AutoSizeText.rich(
                    TextSpan(
                          style: TextStyle(fontSize: 14.0, color: const Color(0xFF262626),),
                          children: [
                            TextSpan(text: widget.cost, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: const Color(0xFF262626), fontFamily: 'Poppins'),),
                            TextSpan(text: ' INR', style: TextStyle(fontFamily: 'Poppins',))
                          ]
                      ),
                    maxLines: 1,
                    minFontSize: 5,
                  ),
                  SizedBox(height: 3.0,),
                  Text('$updTime'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  DraggableScrollableSheet graphModal(updTime, List<TableRow> getTableData(), flatIndex) {
    return DraggableScrollableSheet(
                initialChildSize: 0.65, //set this as you want
                maxChildSize: 1, //set this as you want
                minChildSize: 0.5, //set this as you want
                expand: false,
                builder: (context, scrollController) {
                  return Container(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        Container( //Header Container
                          margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 7,
                                child: Container(  //Left Container
                                  child: Row(
                                    children: [
                                      SvgPicture.asset('assets/${widget.icon}', height: 55, width: 55,),
                                      SizedBox(width: 10.0,),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            AutoSizeText('${widget.name}', maxLines: 1, maxFontSize: 24.0, minFontSize: 2.0, style: TextStyle(fontWeight: FontWeight.bold),),
                                            SizedBox(height: 5.0,),
                                            AutoSizeText('${widget.currentUnits}  $updTime', minFontSize: 2, maxLines: 1,)
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(  //Right Container
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      AutoSizeText(
                                          (Provider.of<Data>(context, listen: true).data['customerflatData'][flatIndex]['projectData']['projectUtilityType'] == 1000) ? 'Prepaid'
                                              : (Provider.of<Data>(context).data['customerflatData'][flatIndex]['projectData']['projectUtilityType'] == 1001) ? 'Postpaid'
                                              : 'Prepaid-Postpaid',
                                        maxLines: 1,
                                        minFontSize: 2,
                                      ),
                                      SizedBox(height: 7.0,),
                                      // AutoSizeText('${Provider.of<Data>(context).dashboardData['meterdata']['${widget.short}Tarif']} INR/${widget.units}', maxLines: 1, minFontSize: 2,)
                                      AutoSizeText(' ', maxLines: 1, minFontSize: 2,)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(  //Graph
                          height: MediaQuery.of(context).size.height * 0.4,
                          // color: Colors.black,
                          child: SfCartesianChart(
                            backgroundColor: Color(0xFFf4f4f4),
                            borderWidth: 0,
                            plotAreaBorderWidth: 0,
                            margin: EdgeInsets.all(10.0),
                            legend: Legend(isVisible:false),

                            primaryXAxis: CategoryAxis(
                              visibleMaximum: 4,
                              // visibleMinimum: 4,
                              majorGridLines: MajorGridLines(width: 0),
                              minorGridLines: MinorGridLines(width: 0),
                              majorTickLines: MajorTickLines(width: 0),
                              minorTickLines: MinorTickLines(width: 0),
                              labelStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            primaryYAxis: NumericAxis(
                              isVisible: false,
                              majorGridLines: MajorGridLines(width: 0),
                              minorGridLines: MinorGridLines(width: 0),
                              labelFormat: '{value} ${widget.units}',
                            ),
                            zoomPanBehavior: ZoomPanBehavior(enablePanning: true),

                            onPointTapped: (PointTapArgs value){
                              Provider.of<Data>(context, listen: false).getBarData(value.pointIndex);
                              // scrollController.animateTo(scrollController.offset + 10, curve: Curves.linear, duration: Duration(milliseconds: 500));
                            },

                            series: [
                              ColumnSeries(
                                dataSource: Provider.of<Data>(context).chartData,

                                // xValueMapper: (SalesData sales, _) => sales.year + "\n${sales.units} ${widget.units}",
                                // yValueMapper: (SalesData sales, _) => sales.sales,

                                xValueMapper: (SalesData sales, _) => sales.year + "\n${sales.sales} INR",
                                yValueMapper: (SalesData sales, _) => sales.units,

                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                color: Color.fromRGBO(247, 123, 37, 1),
                                width: 0.35,

                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  showZeroValue: false,
                                  angle: 270,
                                  labelAlignment: ChartDataLabelAlignment.bottom,
                                  labelPosition: ChartDataLabelPosition.inside,
                                  offset: Offset(0, 10),
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  )
                                )
                              ),
                            ],

                          ),
                        ),
                        Container(  //Radio Buttons
                          margin: EdgeInsets.only(top: 10.0),
                          child: CustomRadioButton(
                            elevation: 0,
                            absoluteZeroSpacing: false,
                            width: MediaQuery.of(context).size.width * 0.27,
                            // defaultSelected: 'yearlySum',
                            defaultSelected: Provider.of<Data>(context).radioButtomValue,
                            unSelectedColor: Colors.transparent,
                            selectedColor: Color(0xFFF77C25),
                            selectedBorderColor: Color(0xFFF77C25),
                            unSelectedBorderColor: Colors.transparent,
                            enableShape: true,
                            buttonLables: [
                              'Week',
                              'Month',
                              'Year',
                              // 'Custom'
                            ],
                            buttonValues: [
                              'weeklySum',
                              'yearly',
                              'yearlySum',
                              // 'Custom'
                            ],
                            buttonTextStyle: ButtonTextStyle(
                                selectedColor: Colors.white,
                                unSelectedColor: Colors.black,
                                textStyle: TextStyle(fontSize: 16),
                            ),
                            radioButtonValue: (value) async{
                              Provider.of<Data>(context, listen: false).setBarData();
                              if(value != 'Custom'){
                                await Provider.of<Data>(context, listen: false).getGraphData(value, '${widget.short}');
                              }
                            },
                          )
                        ),
                        Container(    //Table
                          margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 0.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Table(
                              defaultVerticalAlignment: TableCellVerticalAlignment.middle,

                              children: getTableData(),
                            ),
                          )
                        )
                      ],
                    )
                  );
                }
            );
  }
}





class SalesData {
  SalesData(this.year, this.sales, this.units);

  final String year;
  final double sales;
  final double units;
}

class Maintenance extends StatelessWidget {
  const Maintenance({
    Key key,
    this.icon,
    this.cost,
  }) : super(key: key);

  final String icon;
  final cost;

  @override
  Widget build(BuildContext context) {
    var date = (DateTime.now().day).toString() + " " + Provider.of<Data>(context, listen: false).getMonthName((DateTime.now().month).toString()).substring(0, 3);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 20.0),
          child: Row(
            children: [
              SvgPicture.asset('assets/$icon', height: 55, width: 55,),
              SizedBox(width: 10.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Maintenance', style: TextStyle(color: const Color(0xFFF77C25)),),
                  SizedBox(height: 5.0,),
                  Text(date, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: const Color(0xFF262626)),),
                  SizedBox(height: 3.0,),
                ],
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: 10.0,),
              RichText(
                  text: TextSpan(
                      style: TextStyle(fontSize: 14.0, color: const Color(0xFF262626),),
                      children: [
                        TextSpan(text: '$cost', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: const Color(0xFF262626))),
                        TextSpan(text: ' INR')
                      ]
                  )
              ),
              SizedBox(height: 3.0,),
            ],
          ),
        ),
      ],
    );
  }
}
