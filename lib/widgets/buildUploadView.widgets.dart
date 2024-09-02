import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class BuildUploadView extends StatefulWidget {
  final Function openFileExplorer;
  final uploadStatus;

  const BuildUploadView({required this.openFileExplorer, required this.uploadStatus }); 

  @override
  _BuildUploadViewState createState() => _BuildUploadViewState();
}

class _BuildUploadViewState extends State<BuildUploadView> {

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
            style: TextStyle(color: Colors.white, fontSize: 20, decoration: TextDecoration.none),
          ),
          const SizedBox(
            height: 40,
          ),
          AvatarGlow(
            glowCount: 3,
            glowRadiusFactor: 0.2,
            animate: true,
            child: GestureDetector(
              onTap: () => widget.openFileExplorer(),
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
        ],
      ),
    );
  }
}