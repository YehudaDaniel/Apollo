import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart'; // הוספת חבילת PDF
import 'package:flutter/services.dart' show rootBundle; // לקרוא מה-assets

class HistoryItem extends StatelessWidget {
  final String songTitle;

  const HistoryItem({Key? key, required this.songTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        color: Colors.white.withOpacity(0.15), // Background color with transparency
        borderRadius: BorderRadius.circular(15),
        elevation: 5,
        child: ListTile(
          minTileHeight: 100,
          onTap: () async {
            // Load and display the PDF when tapped
            final pdfPath = 'assets/photos/score.pdf'; // נתיב לקובץ ה-PDF
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PDFViewerScreen(pdfPath: pdfPath),
              ),
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            songTitle,
            style: const TextStyle(
              color: Colors.black87, // Changed text color for better contrast
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: const Icon(
            Icons.file_open,
            color: Colors.black87, // Changed icon color for better contrast
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.1),
            child: Icon(
              Icons.music_note,
              color: Colors.black87, // Changed icon color for better contrast
            ),
          ),
        ),
      ),
    );
  }
}

// מסך חדש להצגת ה-PDF
class PDFViewerScreen extends StatelessWidget {
  final String pdfPath;

  const PDFViewerScreen({Key? key, required this.pdfPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: PDFView(
        filePath: pdfPath,
      ),
    );
  }
}
