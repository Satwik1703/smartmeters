import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_meter/data.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatelessWidget {
  PdfViewer({this.invoiceNo});
  final invoiceNo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$invoiceNo.pdf'),
        backgroundColor: Color(0xFFF77C25),
      ),
      body: Container(
        child: SfPdfViewer.network(
          '${Provider.of<Data>(context, listen: false).url}/containers/invoice/download/$invoiceNo.pdf',
        ),
      )
    );
  }
}
