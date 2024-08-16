import 'package:apollo_poc/widgets/buildDot.widgets.dart';
import 'package:apollo_poc/widgets/historyitem.widgets.dart';
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
  final PageController _controller = PageController(initialPage: 1); //Sets the initial page
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
          image: DecorationImage(image: AssetImage('assets/photos/app_background.jpeg'),
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
                  });
                },
                children: [
                  // History View for the first page
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 50,
                                  bottom: 20,
                                ),
                                child: const Text(
                                  'History',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              HistoryItem(),
                              HistoryItem(),
                              HistoryItem(),
                              HistoryItem(),
                              HistoryItem(),
                              HistoryItem(),
                              HistoryItem(),
                              HistoryItem(),
                              HistoryItem(),
                              HistoryItem(),
                              HistoryItem(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ----------------------------------------------------------------
                  //Record View for the second page
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Tap to Record',
                          style: TextStyle(color: Colors.white, fontSize: 20, decoration: TextDecoration.none),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: () => print("Yea!"),
                          child: Material(
                            shape: const CircleBorder(),
                            elevation: 8,
                            child: Container(
                              padding: const EdgeInsets.all(40),
                              height: 200,
                              width: 200,
                              decoration: const BoxDecoration(
                                image: DecorationImage(image: AssetImage('assets/photos/main_btn.png'), 
                                fit: BoxFit.fill
                                ),
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 140, 80, 182),
                              ),
                              child: const Icon(
                                Icons.mic,
                                color: Colors.white,
                                size: 100,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ----------------------------------------------------------------
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (_uploadStatus != null) ...[
                          Text(
                            _uploadStatus!,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 242, 245, 242),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                        const Text(
                          'Upload File',
                          style: TextStyle(color: Colors.white, fontSize: 20, decoration: TextDecoration.none),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: _openFileExplorer,
                          child: Material(
                            shape: const CircleBorder(),
                            elevation: 8,
                            child: Container(
                              padding: const EdgeInsets.all(40),
                              height: 200,
                              width: 200,
                              decoration: const BoxDecoration(
                                image: DecorationImage(image: AssetImage('assets/photos/main_btn.png'), 
                                  fit: BoxFit.fill
                                ),
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 140, 80, 182),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 100,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
        allowedExtensions: ['mp3'],
      );

      if (result != null) {
        setState(() {
          _fileBytes = result.files.single.bytes;
          _fileName = result.files.single.name;
          _uploadStatus = 'File uploaded'; // Update the upload status here
        });
        print('File picked: $_fileName');
        _saveFileBytesAsMP3(_fileBytes!, _fileName!);
      } else {
        setState(() {
          _uploadStatus = 'No file selected'; // Update the upload status here
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
    final mp3File = fileBytes;
    print('File saved as $fileName with ${mp3File.lengthInBytes} bytes.');
  }
}
