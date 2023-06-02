import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../../../Data/DbProvider.dart';

class PDFViewerPage extends StatefulWidget {
  int? kullanici_id;

  PDFViewerPage({required this.kullanici_id});

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  int pageNumber = 1;
  bool pdfReady = false;
  List<Uint8List> pdfBytesList = [];
  var dbHelper = DatabaseProvider();

  @override
  void initState() {
    super.initState();
    loadPDF();
  }

  void loadPDF() async {
    List<Uint8List>? pdfs = await dbHelper.loadPDFsByUserId(widget.kullanici_id!);
    if (pdfs != null && pdfs.isNotEmpty && pdfs[0] != null) {
      setState(() {
        pdfBytesList = pdfs;
        pdfReady = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: pdfReady
          ? PDFView(
        pdfData: pdfBytesList[0]!,
        onPageChanged: (int? page, int? total) {
          setState(() {
            pageNumber = page!;
          });
        },
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
