import 'dart:ui';

import 'package:flutter/material.dart';

class Happy extends StatefulWidget {
  const Happy({Key? key}) : super(key: key);

  @override
  State<Happy> createState() => _HappyState();
}

class _HappyState extends State<Happy> {
  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: [
        GestureDetector(
          // onHorizontalDragUpdate: (details) {
          //   var distance = details.delta.dx;
          //   if (distance > 0) {
          //     Navigator.of(context).pop();
          //   } else if (distance < 0) {
          //     Navigator.push(
          //         context, MaterialPageRoute(builder: (builder) => const Sad()));
          //   }
          //   ;
          // },
          child: Scaffold(
            // backgroundColor: Colors.green,

            body: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/background.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.centerRight,
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: 5,
                      sigmaY: 5), // Adjust the sigma values for more/less blur
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                        Colors.yellow.withOpacity(0.7),
                        BlendMode
                            .difference), // Adjust the color and opacity here
                    child: Container(
                      color: Colors.yellow.withOpacity(
                          0.7), // Set the color to transparent so it won't affect the background image directly
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: const [
                          Text(
                            "Mood check",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 28,
                            ),
                          ),
                          Text(
                            "How are you feeling today?",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 18),
                          ),
                        ],
                      ),
                      Image.asset("assets/images/happy.png"),
                      const Text(
                        "HAPPY",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 45,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 10,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 15,
                              height: 10,
                              decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          InkWell(
                            // onTap: (){
                            //   Navigator.push(context, MaterialPageRoute(builder: (builder)=>Sad()));
                            // },
                            child: Container(
                              width: 15,
                              height: 10,
                              decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
