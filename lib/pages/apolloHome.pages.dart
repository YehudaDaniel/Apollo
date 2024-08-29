import 'package:apollo_poc/widgets/buildDot.widgets.dart';
import 'package:apollo_poc/widgets/buildHistoryView.widgets.dart';
import 'package:apollo_poc/widgets/buildRecordView.widgets.dart';
import 'package:apollo_poc/widgets/buildUploadView.widgets.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class ApolloHome extends StatefulWidget {
  const ApolloHome({super.key});

  @override
  State<ApolloHome> createState() => _ApolloHomeState();
}

class _ApolloHomeState extends State<ApolloHome> {
  int currentIndex = 1;
  final PageController _controller = PageController(initialPage: 1); // Sets the initial page
  Uint8List? _fileBytes; // Variable to hold the selected file bytes
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
              children: List.generate(3, (index) => buildDot(currentIndex, index, context)),
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
                  buildHistoryView(),
                  BuildRecordView(),
                  // ----------------------------------------------------------------
                  BuildUploadView(openFileExplorer: _openFileExplorer, uploadStatus: _uploadStatus,),
                ],
              ),
            ),
            const Text('safasfasfasfasfsafs'),
          ],
        ),
      ),
    );
  }

  void _openFileExplorer() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav'],
      );

      if (result != null) {
        setState(() {
          _fileBytes = result.files.first.bytes; // Access bytes directly
          _fileName = result.files.first.name;
          _uploadStatus = 'File Uploaded'; // Update the upload status here
        });
        print('File picked: $_fileName');
        _saveFileBytesAsMP3(_fileBytes!, _fileName!);
      } else {
        setState(() {
          _uploadStatus = 'No File Selected'; // Update the upload status here
        });
        print('User canceled the picker');
      }
    } catch (e) {
      setState(() {
        _uploadStatus = 'Error while picking the file: $e'; // Update the upload status here
      });
      print('Error while picking the file: $e');
    }
  }

  void _saveFileBytesAsMP3(Uint8List fileBytes, String fileName) {
    // Save the file bytes to a variable for later use
    // You can use this variable to pass the file to another program
    print('File saved as $fileName.');
  }

  void setUploadStatusState(String status) {
    setState(() {
      _uploadStatus = status;
    });
  }

  String getUploadStatus() {
    return _uploadStatus ?? 'No File Selected';
  }
}
