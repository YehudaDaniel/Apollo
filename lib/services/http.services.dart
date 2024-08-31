import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class HttpServices {
  static const bool _isDebug = true;
  static String _devUrl = 'http://10.0.0.5:3000';

  static String get serverURL {
    return _isDebug ?
      _devUrl
      :
      'https://your-production-server.com';
  }

  static Future<bool> sendFileToModel(String filePath, String fileName) async {
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
      request.files.add(
        await http.MultipartFile.fromPath('audio', filePath)
      );
      var res = await request.send();

      if (res.statusCode == 200) {
        // Handle successful file upload
        return true;
      } else {

      }
    } catch (e) {
      print('Error uploading file: $e');
    }
    return false;
  }


}
