import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class ShowPdf extends StatefulWidget {
  final String remotePDFURL;
  const ShowPdf({required this.remotePDFURL, super.key});

  @override
  State<ShowPdf> createState() => _ShowPdfState();
}

class _ShowPdfState extends State<ShowPdf> {
  // String? remotePDFPath;
  // bool isReady = false;

  @override
  void initState() {
    super.initState();
    // createFileOfPdfUrl().then((f) {
    //   setState(() {
    //     remotePDFPath = f.path;
    //   });
    // });
  }

  // Future<File> createFileOfPdfUrl() async {
  //   Completer<File> completer = Completer();
  //   print("Start download file from internet!");
  //   try {
  //     // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
  //     // final url = "https://pdfkit.org/docs/guide.pdf";
  //     final url = widget.remotePDFURL;
  //     final filename = url.substring(url.lastIndexOf("/") + 1);
  //     var request = await HttpClient().getUrl(Uri.parse(url));
  //     var response = await request.close();
  //     var bytes = await consolidateHttpClientResponseBytes(response);
  //     var dir = await getApplicationDocumentsDirectory();
  //     print("Download files");
  //     print("${dir.path}/$filename");
  //     File file = File("${dir.path}/$filename");

  //     await file.writeAsBytes(bytes, flush: true);
  //     completer.complete(file);
  //   } catch (e) {
  //     throw Exception('Error parsing asset file!');
  //   }

  //   return completer.future;
  // }

  @override
  Widget build(BuildContext context) {
    return PDFView(
      // filePath: remotePDFPath,
      // onRender: (_pages) {
      //   setState(() {
      //     isReady = true;
      //   });
      // },
      onError: (error) {
        print("Error loading PDF: $error");
      }, // Set the path of the PDF file

      filePath:
          "https://assets.kpmg.com/content/dam/kpmg/pk/pdf/2022/06/Pakistan-Economic-Brief-2022.pdf",
      enableSwipe: true, // Allow swipe gestures to change pages
      swipeHorizontal: true, // Swipe horizontally to change pages
    );
  }
}
    