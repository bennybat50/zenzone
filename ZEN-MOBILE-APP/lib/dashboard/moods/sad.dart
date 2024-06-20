import 'dart:ui';

import 'package:flutter/material.dart';

class Sad extends StatefulWidget {
  const Sad({Key? key}) : super(key: key);

  @override
  State<Sad> createState() => _SadState();
}

class _SadState extends State<Sad> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onHorizontalDragUpdate: (details) {
      //   var distance = details.delta.dx;
      //   if (distance > 0) {
      //     Navigator.of(context).pop();
      //   } else if (distance < 0) {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (builder) => const Angry()));
      //   }
      //   ;
      // },
      child: Scaffold(
        body: Stack(fit: StackFit.expand, children: [
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 7,
                sigmaY: 7), // Adjust the sigma values for more/less blur
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.77),
                  BlendMode.difference), // Adjust the color and opacity here
              child: Container(
                color: Colors.black.withOpacity(
                    0.77), // Set the color to transparent so it won't affect the background image directly
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
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  ],
                ),
                Image.asset("assets/images/sad.png"),
                const Text(
                  "SAD",
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
                      width: 15,
                      height: 10,
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 50,
                        height: 10,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    Container(
                      width: 15,
                      height: 10,
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
