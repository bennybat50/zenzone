import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/PublicVar.dart';
import '../widgets/global_widgets.dart';

class AppUpdate extends StatefulWidget {
  const AppUpdate({Key? key}) : super(key: key);

  @override
  State<AppUpdate> createState() => _AppUpdateState();
}

class _AppUpdateState extends State<AppUpdate> {
  late double deviceHeight, deviceWidth, deviceFont;
  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Material(
            color: Colors.white,
            elevation: 2.5,
            shadowColor: Colors.grey[200],
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: deviceHeight * 0.70,
              child: ListView(
                children: [
                  Image(
                    image: AssetImage(
                      "assets/images/update.jpg",
                    ),
                    height: deviceHeight * 0.417,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        const Text(
                          "Dear User",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Palm App you are using is too old and needs upgrade, please ckick the button below to upgrade to the lastest version",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  ButtonWidget(
                    onPress: () async {
                      if (Platform.isAndroid) {
                        await launch(
                            'https://play.google.com/store/apps/details?id=com.palmalliance');
                      } else {
                        await launch(
                          'https://play.google.com/store/apps/details?id=com.palmalliance',
                        );
                      }
                    },
                    width: double.infinity,
                    height: 50.0,
                    radius: 5.0,
                    txColor: Colors.white,
                    bgColor: Color(PublicVar.primaryDark),
                    loading: false,
                    text: "Click here to Update",
                    addIconBG: false,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
