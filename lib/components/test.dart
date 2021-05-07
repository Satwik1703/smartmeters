// DraggableScrollableSheet(
//                 initialChildSize: 0.65, //set this as you want
//                 maxChildSize: 1, //set this as you want
//                 minChildSize: 0.5, //set this as you want
//                 expand: false,
//                 builder: (context, scrollController) {
//                   return Container(
//                     child: ListView(
//                       controller: scrollController,
//                       children: [
//                         Container( //Header Container
//                           margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Container(  //Left Container
//                                 child: Row(
//                                   children: [
//                                     SvgPicture.asset('assets/$icon', height: 55, width: 55,),
//                                     SizedBox(width: 10.0,),
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         AutoSizeText('$name', maxLines: 1, maxFontSize: 24.0, minFontSize: 20.0, style: TextStyle(fontWeight: FontWeight.bold),),
//                                         SizedBox(height: 5.0,),
//                                         AutoSizeText('$currentUnits  $updTime')
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Container(  //Right Container
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     children: [
//                                       AutoSizeText(
//                                           (Provider.of<Data>(context, listen: true).data['customerflatData'][flatIndex]['projectData']['projectUtilityType'] == 1000) ? 'Prepaid'
//                                               : (Provider.of<Data>(context).data['customerflatData'][flatIndex]['projectData']['projectUtilityType'] == 1001) ? 'Postpaid'
//                                               : 'Prepaid-Postpaid',
//                                         maxLines: 1,
//                                       ),
//                                       SizedBox(height: 7.0,),
//                                       AutoSizeText('${Provider.of<Data>(context).dashboardData['meterdata']['${short}Tarif']} INR/$units')
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(  //Graph
//                           height: MediaQuery.of(context).size.height * 0.4,
//                           // color: Colors.black,
//                           child: SfCartesianChart(
//                             backgroundColor: Color(0xFFf4f4f4),
//                             borderWidth: 0,
//                             plotAreaBorderWidth: 0,
//                             margin: EdgeInsets.all(10.0),
//                             legend: Legend(isVisible:false),
//
//                             primaryXAxis: CategoryAxis(
//                               visibleMaximum: 4,
//                               // visibleMinimum: 4,
//                               majorGridLines: MajorGridLines(width: 0),
//                               minorGridLines: MinorGridLines(width: 0),
//                               majorTickLines: MajorTickLines(width: 0),
//                               minorTickLines: MinorTickLines(width: 0),
//                               labelStyle: TextStyle(
//                                 fontFamily: 'Poppins',
//                                 fontWeight: FontWeight.bold
//                               )
//                             ),
//                             primaryYAxis: NumericAxis(
//                               isVisible: false,
//                               majorGridLines: MajorGridLines(width: 0),
//                               minorGridLines: MinorGridLines(width: 0),
//                               labelFormat: '{value} INR',
//                             ),
//                             zoomPanBehavior: ZoomPanBehavior(enablePanning: true),
//
//                             onPointTapped: (PointTapArgs value){
//                               Provider.of<Data>(context, listen: false).getBarData(value.pointIndex);
//                               // scrollController.animateTo(scrollController.offset + 200.0, curve: Curves.linear, duration: Duration(milliseconds: 500));
//                             },
//
//                             series: [
//                               ColumnSeries(
//                                 dataSource: Provider.of<Data>(context).chartData,
//
//                                 xValueMapper: (SalesData sales, _) => sales.year + "\n${sales.units} $units",
//                                 yValueMapper: (SalesData sales, _) => sales.sales,
//
//                                 borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                                 color: Color.fromRGBO(247, 123, 37, 1),
//                                 width: 0.35,
//
//                                 dataLabelSettings: DataLabelSettings(
//                                   isVisible: true,
//                                   showZeroValue: false,
//                                   angle: 270,
//                                   labelAlignment: ChartDataLabelAlignment.bottom,
//                                   labelPosition: ChartDataLabelPosition.inside,
//                                   offset: Offset(0, 10),
//                                   textStyle: TextStyle(
//                                     color: Colors.white,
//                                     fontFamily: 'Poppins',
//                                     fontWeight: FontWeight.bold,
//                                   )
//                                 )
//                               ),
//                             ],
//
//                           ),
//                         ),
//                         Container(  //Radio Buttons
//                           margin: EdgeInsets.only(top: 10.0),
//                           child: CustomRadioButton(
//                             elevation: 0,
//                             absoluteZeroSpacing: false,
//                             width: MediaQuery.of(context).size.width * 0.27,
//                             // defaultSelected: 'yearlySum',
//                             defaultSelected: Provider.of<Data>(context).radioButtomValue,
//                             unSelectedColor: Colors.transparent,
//                             selectedColor: Color(0xFFF77C25),
//                             selectedBorderColor: Color(0xFFF77C25),
//                             unSelectedBorderColor: Colors.transparent,
//                             enableShape: true,
//                             buttonLables: [
//                               'Week',
//                               'Month',
//                               'Year',
//                               // 'Custom'
//                             ],
//                             buttonValues: [
//                               'weeklySum',
//                               'yearly',
//                               'yearlySum',
//                               // 'Custom'
//                             ],
//                             buttonTextStyle: ButtonTextStyle(
//                                 selectedColor: Colors.white,
//                                 unSelectedColor: Colors.black,
//                                 textStyle: TextStyle(fontSize: 16),
//                             ),
//                             radioButtonValue: (value) async{
//                               Provider.of<Data>(context, listen: false).setBarData();
//                               if(value != 'Custom'){
//                                 await Provider.of<Data>(context, listen: false).getGraphData(value, '$short');
//                               }
//                             },
//                           )
//                         ),
//                         Container(    //Table
//                           margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 0.0),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Table(
//                               defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//
//                               children: getTableData(),
//                             ),
//                           )
//                         )
//                       ],
//                     )
//                   );
//                 }
//             );