import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class HttpServices {
  static const bool _isDebug = true;
  static String _devUrl = 'http://localhost:3000';

  static String get serverURL {
    return _isDebug ?
      _devUrl
      :
      'https://your-production-server.com';
  }

  static Future<String> sendFileToModel(String filePath, String fileName) async {
    try {
      // Replace 'your_server_url' with the actual URL of your server endpoint
      final url = Uri.parse('$serverURL/sendFileToModel');

      // Create a POST request with the file contents
      // final res = await http.post(
      //   url,
      //   headers: {'Content-Type' : 'multipart/form-data'},
      //   body: {'file': fileBytes, 'fileName': fileName},
      // );
      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        filePath,
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

          return midiFilePath;
        } else {
          return 'error';
        }
      } catch (e) {
        print('Error: $e');
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
    return 'error';
  }


}
