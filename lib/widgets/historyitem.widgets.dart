import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        minTileHeight: 100,
        onTap: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        tileColor: Color.fromARGB(255, 145, 15, 145),
        title: const Text(
          'Song 1',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25
          )
        ),
        trailing: const Icon(
          Icons.file_open,
          color: Colors.white,
        ),
      )
    );
  }
}