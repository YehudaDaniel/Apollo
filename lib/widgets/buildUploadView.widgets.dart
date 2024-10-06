import 'package:apollo_poc/screens/pdf_viewer_screen.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart';

class BuildUploadView extends StatefulWidget {
  final Function openFileExplorer;
  final String? uploadStatus;

  const BuildUploadView({
    required this.openFileExplorer,
    required this.uploadStatus,
  });

  @override
  _BuildUploadViewState createState() => _BuildUploadViewState();
}

class _BuildUploadViewState extends State<BuildUploadView> {
  bool _isLoading = false;
  String? _midiFilePath;
  bool _downloadedSuccessfully = false;

  Future<void> _sendFileToServer(Uint8List fileBytes, String fileName) async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('http://localhost:3000/sendFileToModel');
    final request = http.MultipartRequest('POST', url);
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      fileBytes,
      filename: fileName,
      contentType: MediaType('audio', 'm4a'),
    ));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final bytes = await response.stream.toBytes();
        var midiFilePath = '${Directory.systemTemp.path}/output.pdf';

        final file = File(midiFilePath);
        await file.writeAsBytes(bytes);

        print('MIDI file downloaded to: $midiFilePath');

        setState(() {
          _midiFilePath = midiFilePath;
          _isLoading = false;
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PDFViewerScreen(pdfPath: midiFilePath),
          ),
        );
      } else {
        print('Failed to download MIDI file.');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      // On the web, use bytes and fileName
      Uint8List? fileBytes = result.files.first.bytes;
      String? fileName = result.files.first.name;

      if (fileBytes != null && fileName != null) {
        await _sendFileToServer(fileBytes, fileName);
      }
    } else {
      // User canceled the picker
      print('User canceled the picker');
    }
  }

  Future<void> _downloadMidiFile() async {
    if (_midiFilePath != null) {
      print('Downloading MIDI file from: $_midiFilePath');

      setState(() {
        _downloadedSuccessfully = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Downloaded successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.uploadStatus != null) ...[
            Text(
              widget.uploadStatus!,
              style: const TextStyle(
                color: Color.fromARGB(255, 243, 244, 243),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
          ],
          const Text(
            'Upload File',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              decoration: TextDecoration.none,
            ),
          ),
          AvatarGlow(
            glowCount: 3,
            glowRadiusFactor: 0.2,
            animate: true,
            child: GestureDetector(
              onTap: () => _pickFile(),
              child: Material(
                shape: const CircleBorder(),
                elevation: 8,
                child: Container(
                  padding: const EdgeInsets.all(40),
                  height: 200,
                  width: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/photos/main_btn.png'),
                      fit: BoxFit.fill,
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
          ),
          if (_isLoading) const CircularProgressIndicator(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _midiFilePath != null && !_isLoading ? _downloadMidiFile : null,
            child: const Text('Download MIDI File'),
          ),
          const SizedBox(height: 20),
          if (_downloadedSuccessfully)
            const Text(
              'Downloaded successfully!',
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
        ],
      ),
    );
  }
}
