import 'dart:typed_data';
import 'package:apollo_poc/widgets/buildDot.widgets.dart';
import 'package:apollo_poc/widgets/buildHistoryView.widgets.dart';
import 'package:apollo_poc/widgets/buildRecordView.widgets.dart';
import 'package:apollo_poc/widgets/buildUploadView.widgets.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:apollo_poc/services/http.services.dart';
import 'package:path/path.dart' as p;

class ApolloHome extends StatefulWidget {
  const ApolloHome({super.key});

  @override
  State<ApolloHome> createState() => _ApolloHomeState();
}

class _ApolloHomeState extends State<ApolloHome> {
  int currentIndex = 1;
  final PageController _controller = PageController(initialPage: 0); // Sets the initial page
  Uint8List? _fileBytes;
  String? _fileName; // Variable to hold the selected file name
  String? _uploadStatus; // Variable to hold the upload status

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // background Image for the whole application
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/photos/app_background.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        // ----------------------------------------------------------------
        // 3 Dots indicator
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).viewPadding.top, // height of the status bar for every phone separately
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (index) => buildDot(currentIndex, index, context)),
            ),
        // ----------------------------------------------------------------
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (int index) {
                  setState(() {
                    currentIndex = index;
                    if (index != 2) {
                      // If not on the "Upload File" page, reset the upload status
                      _uploadStatus = null;
                    }
                  });
                },
                children: [
                  // buildHistoryView(),
                  BuildRecordView(),
                  // ----------------------------------------------------------------
                  BuildUploadView(openFileExplorer: _openFileExplorer, uploadStatus: _uploadStatus,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFileExplorer() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav'],
      );

      if (result != null) {
        setState(() {
          String str = result.files[0].path.toString();
          _fileBytes = File(str).readAsBytesSync();
          _fileName = result.files[0].name;
          _uploadStatus = 'File Uploaded'; // Update the upload status here
        });

        //Read the file as a string
        // saveFileBytesAsExtensionSpecified(_fileBytes!, _fileName!, result.files[0].path.toString());

      } else {
        setState(() {
          _uploadStatus = 'No File Selected'; // Update the upload status here
        });
      }
    } catch (e) {
      setState(() {
        _uploadStatus = 'Error while picking the file: $e'; // Update the upload status here
      });
      print('Error while picking the file: $e');
    }
  }

  Future<void> saveFileBytesAsExtensionSpecified(Uint8List fileBytes, String fileName, String path) async {
    try{
      if(fileName.endsWith(".wav")) { //is wav file
        final file = File('${p.dirname(path)}/$fileName.wav');
        await file.writeAsBytes(fileBytes);
      }else { //is mp3 file
        final file = File('${p.dirname(path)}/$fileName.mp3');
        await file.writeAsBytes(fileBytes);
      }
    }catch(e) {
      print(e);
    }
  }

  void setUploadStatusState(String status) {
    setState(() {
      _uploadStatus = status;
    });
  }

  String getUploadStatus() {
    return _uploadStatus?? 'No File Selected';
  }
}
