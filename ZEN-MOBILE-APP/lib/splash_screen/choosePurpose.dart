import 'package:flutter/material.dart';
import 'package:mindcast/models/PublicVar.dart';
import 'package:mindcast/onboarding/signup.dart';
import 'package:mindcast/utils/app_actions.dart';
import 'package:mindcast/widgets/global_widgets.dart';
import 'package:provider/provider.dart';

import '../bloc/app_bloc.dart';
import '../utils/next_page.dart';

class ChoosePurpose extends StatefulWidget {
  const ChoosePurpose({Key? key}) : super(key: key);

  @override
  State<ChoosePurpose> createState() => _ChoosePurposeState();
}

class _ChoosePurposeState extends State<ChoosePurpose> {
  @override
  bool isChecked = false;
  int interestCount = 0;

  late AppBloc appBloc;
  @override
  void initState() {
    super.initState();
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
          // Container(
          //   width: double.infinity,
          //   decoration: const BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage('assets/images/background.png'),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          ListView(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: 80,
                      ),
                      Container(
                        height: 70,
                        child: const Text(
                          "What would you like to do on Zenzone?",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 25),
                        ),
                      ),
                      Container(
                        child: const Text(
                          "This will help us recommend curated resources for your well-being.",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 450,
                        child: ListView.builder(
                            itemCount: appBloc.interests.length,
                            physics: AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: InkWell(
                                  onTap: () {
                                    selectInterest(index,
                                        appBloc.interests[index]["selected"]);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              Container(
                                                  width: 30,
                                                  child: GetImageProvider(
                                                    url:
                                                        appBloc.interests[index]
                                                            ["icon"],
                                                    placeHolder: PublicVar
                                                        .defaultAppImage,
                                                  )),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(left: 20),
                                                width: 200,
                                                child: Text(
                                                  "${appBloc.interests[index]["name"]}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          // padding: EdgeInsets.all(2),
                                          width: 20,
                                          height: 20,

                                          decoration: BoxDecoration(
                                              // color: Colors.white,

                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              border: Border.all(
                                                  width: appBloc
                                                              .interests[index]
                                                          ["selected"] as bool
                                                      ? 2
                                                      : 0,
                                                  color: appBloc
                                                              .interests[index]
                                                          ["selected"] as bool
                                                      ? Colors.white
                                                      : Colors.grey)),
                                          child: Checkbox(
                                              activeColor: Colors.transparent,
                                              checkColor: Colors.white,
                                              value: appBloc.interests[index]
                                                  ["selected"] as bool,
                                              onChanged: (value) {
                                                selectInterest(
                                                    index,
                                                    appBloc.interests[index]
                                                        ["selected"]);
                                              }),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          validateChecked();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 80),
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                              interestCount > 0
                                  ? "Continue (${countSelectedItems()})"
                                  : "${countSelectedItems()} selected",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  int countSelectedItems() {
    int count = 0;
    for (var item in appBloc.interests) {
      if (item["selected"] == true) {
        count++;
        setState(() {
          interestCount = count;
        });
      }
    }
    return count;
  }

  void selectInterest(int index, bool value) {
    setState(() {
      if (value == false) {
        appBloc.interests[index]["selected"] = true;
      } else {
        appBloc.interests[index]["selected"] = false;
      }
    });
  }

  void validateChecked() {
    if (interestCount > 0) {
      NextPage().nextRoute(context, SignUp());
    } else {
      AppActions().showErrorToast(
          context: context,
          text: "Please select an area of interest before signing up");
    }
  }
}
