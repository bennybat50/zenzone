import 'dart:async';

import 'package:app_framework/app_framework.dart';
import 'package:flutter/material.dart';
import 'package:mindcast/dashboard/base_page.dart';
import 'package:mindcast/splash_screen/splash_screen2.dart';
import 'package:mindcast/utils/next_page.dart';
import 'package:provider/provider.dart';

import '../bloc/app_bloc.dart';
import '../bloc/server.dart';
import '../models/PublicVar.dart';

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({Key? key}) : super(key: key);

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  late AppBloc appBloc;
  @override
  void initState() {
    Timer(const Duration(microseconds: 1), () {
      loadInterest();
    });
    Timer(const Duration(seconds: 6), () {
      checkStore();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return GestureDetector(
      onDoubleTap: () {
        NextPage().nextRoute(context, SplashScreen2());
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Container(
            //   width: double.infinity,
            //   decoration: const BoxDecoration(
            //     image: DecorationImage(
            //       image: AssetImage('assets/images/background.png'),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            Stack(
              children: [
                Image.asset(
                  "assets/images/background.png",
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Lottie.asset(
                //   'assets/images/background.lottie.json',
                //   width: double.infinity,
                //   height: double.infinity,
                //   fit: BoxFit.cover,
                // ),
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.4),
                )
              ],
            ),

            Align(
                // alignment: Alignment.center,
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container(
                //   height: 100,
                //   child: Image.asset(
                //     "assets/images/logo.png",
                //     // width: 80,
                //   ),
                // ),
                Text(
                  "Zenzone",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }

  void loadInterest() async {
    await Server().loadInterest(appBloc: appBloc, context: context);
  }

  checkStore() async {
    if (await SharedStore().getData(type: 'bool', key: 'accountApproved') !=
        null) {
      PublicVar.accountApproved =
          await SharedStore().getData(type: 'bool', key: 'accountApproved');
    }
    if (await SharedStore().getData(key: 'user_id', type: "string") != null) {
      PublicVar.userId =
          await SharedStore().getData(key: 'user_id', type: "string");
    }

    if (PublicVar.accountApproved == false) {
      //NextPage().clearPages(context, Login());
      NextPage().nextRoute(context, SplashScreen2());
    } else {
      //extPage().clearPages(context, Login());
      //NextPage().clearPages(context, Base());
      NextPage().clearPages(context, BasePage());
      //NextPage().clearPages(context, Resources());
    }
  }
}
