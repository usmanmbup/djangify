import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends StatelessWidget {
  final String filePath;

  const PDFViewerScreen({required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD), // Secondary color
        title: Text(
          'Visionneuse PDF',
          style: TextStyle(color: Colors.white), // White text for contrast
        ),
        elevation: 0, // Remove shadow for a clean look
      ),
      body: SfPdfViewer.file(
        File(filePath),
        canShowScrollHead: true,
        canShowScrollStatus: true,
        enableDoubleTapZooming: true,
      ),
      backgroundColor: Color(0xFFFEFEFE), // Light background for contrast
    );
  }
}
