import 'package:apollo_poc/widgets/historyitem.widgets.dart';
import 'package:flutter/material.dart';

Widget buildHistoryView() {
  // History View for the first page
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 30,
      vertical: 15,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'History',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.white.withOpacity(0.5),
              thickness: 1,
            ),
            itemCount: 10,
            itemBuilder: (context, index) => HistoryItem(songTitle: 'Song ${index + 1}'),
          ),
        ),
      ],
    ),
  );
}
