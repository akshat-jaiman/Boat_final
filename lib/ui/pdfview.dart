import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class PdfView extends StatefulWidget {
  @override
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  String pdffile = 'assets/irws.pdf';
  PDFDocument _doc;

  @override
  void initState() {
    super.initState();
    _initPdf();
  }

  _initPdf() async {
    final doc = await PDFDocument.fromAsset(pdffile);
    setState(() {
      _doc = doc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pdf'),
        centerTitle: true,
      ),
      body: PDFViewer(document: _doc),
    );
  }
}
