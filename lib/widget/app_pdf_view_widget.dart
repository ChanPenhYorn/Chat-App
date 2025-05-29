import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatelessWidget {
  final String filePath; // Can be a local path or URL

  const PdfViewerScreen({super.key, required this.filePath});

  bool _isNetworkUrl(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    final isNetwork = _isNetworkUrl(filePath);

    return Scaffold(
      appBar: AppBar(title: const Text("PDF Viewer")),
      body: isNetwork
          ? SfPdfViewer.network(filePath)
          : SfPdfViewer.file(File(filePath)),
    );
  }
}
