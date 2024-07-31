import 'package:apollo_poc/widgets/historyitem.widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ApolloHome extends StatefulWidget {
  const ApolloHome ({ super.key });
  @override
  State<ApolloHome> createState() => _ApolloHomeState();
}

class _ApolloHomeState extends State<ApolloHome> {
  int currentIndex = 1;
  final PageController _controller = PageController(initialPage: 1);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 89, 0, 89),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).viewPadding.top, //height of the status bar for every phone seperately
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3, 
              (index) => buildDot(index, context)
            )
          ),
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (int index){
                setState(() {
                  currentIndex = index;
                });
              },
              children: [ 
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
                                  )
                                )
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
                            ]
                        ),
                      ),
                    ]
                  )
                ),
                Container(
                  // color: const Color.fromARGB(255, 89, 0, 89),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Tap to Record',
                        style: TextStyle(color: Colors.white, fontSize: 20, decoration: TextDecoration.none)
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () => print("Yea"),
                        child: Material(
                          shape: const CircleBorder(),
                          elevation: 8,
                          child: Container(
                            padding: const EdgeInsets.all(40),
                            height: 200,
                            width: 200,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color.fromARGB(255, 140, 80, 182),
                            ),
                            child: const Icon(
                              Icons.mic,
                              color: Colors.white,
                              size: 100,
                            )
                          ),
                        ),
                      )
                    ],
                  )
                ),
                Container(
                  color: const Color.fromARGB(255, 89, 0, 89),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Upload File',
                        style: TextStyle(color: Colors.white, fontSize: 20, decoration: TextDecoration.none)
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () async {
                          final res = await FilePicker.platform.pickFiles();
                        },
                        child: Material(
                          shape: const CircleBorder(),
                          elevation: 8,
                          child: Container(
                            padding: const EdgeInsets.all(40),
                            height: 200,
                            width: 200,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color.fromARGB(255, 140, 80, 182),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 100
                            )
                          )
                        ),
                      )
                    ],
                  )
                ),
              ]
            ),
          ),
        ]
      ),
    );
  }

  //This method builds the dot for the 3 dots below the status bar
  Container buildDot(int index, BuildContext context) {
    return Container(
              height: 10,
              width: currentIndex == index ? 30 : 10,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              )
            );
  }
}