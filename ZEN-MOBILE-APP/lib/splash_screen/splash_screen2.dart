import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mindcast/splash_screen/choosePurpose.dart';
import 'package:mindcast/utils/app_actions.dart';
import 'package:mindcast/utils/next_page.dart';
import 'package:provider/provider.dart';

import '../bloc/app_bloc.dart';
import '../bloc/server.dart';
import 'terms_view.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({Key? key}) : super(key: key);

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  bool acceptTerms = false;
  late AppBloc appBloc;
  @override
  void initState() {
    Timer(const Duration(microseconds: 1), () {
      loadInterest();
    });
    super.initState();
  }

  void loadInterest() async {
    await Server().loadInterest(appBloc: appBloc, context: context);
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return Scaffold(
      body: Stack(
        children: [
          Stack(
            children: [
              Image.asset(
                "assets/images/background.png",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              // Lottie.asset('assets/images/background.lottie.json',
              //     width: double.infinity,
              //     height: double.infinity,
              //     fit: BoxFit.cover,
              //     frameRate: FrameRate(1000)),
              Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black.withOpacity(0.4),
              )
            ],
          ),
          Center(
            child: FractionallySizedBox(
                heightFactor: 0.8,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 170,
                            child: Column(
                              children: [
                                // Container(
                                //   height: 100,
                                //   child: Image.asset(
                                //     "assets/images/logo.png",
                                //     // fit: BoxFit.contain,
                                //     // width: 80,
                                //   ),
                                // ),
                                const Text(
                                  "Zenzone",
                                  style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            "Find mental health and wellness"
                            " resources, guided meditation, and stress "
                            "reduction techniques and discussions on"
                            " podcast",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white, fontSize: 14, height: 1.2),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 150,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  acceptTerms = !acceptTerms;
                                });
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: acceptTerms
                                              ? Colors.transparent
                                              : Colors.transparent,
                                          width: 2.0,
                                        ),
                                      ),
                                      width: 24.0,
                                      height: 24.0,
                                      alignment: Alignment.center,
                                      child: acceptTerms
                                          ? const Icon(
                                              Icons.radio_button_checked,
                                              size: 20.0,
                                              color: Colors.white,
                                            )
                                          : const Icon(
                                              Icons.radio_button_unchecked,
                                              size: 20.0,
                                              color: Colors.white,
                                            ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        NextPage()
                                            .nextRoute(context, TermsView());
                                      },
                                      child: RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                          text:
                                              'I agreed, have read and understood the',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' Privacy Policy',
                                          style: TextStyle(
                                            color: Colors.white,
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ])),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (!acceptTerms) {
                                AppActions().showErrorToast(
                                    context: context,
                                    text:
                                        "Please accept the terms of use before proceeding!");
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) =>
                                            const ChoosePurpose()));
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                "Continue",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 20),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }
}
