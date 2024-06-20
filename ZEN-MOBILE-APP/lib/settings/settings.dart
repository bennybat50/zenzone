import 'package:app_framework/utils/sharedStore.dart';
import 'package:flutter/material.dart';
import 'package:mindcast/bloc/app_bloc.dart';
import 'package:mindcast/dashboard/moods/moodBase.dart';
import 'package:mindcast/modals/allow_notifications_modal.dart';
import 'package:mindcast/settings/password.dart';
import 'package:mindcast/settings/updateProfile.dart';
import 'package:mindcast/splash_screen/terms_view.dart';
import 'package:provider/provider.dart';

import '../models/PublicVar.dart';
import '../splash_screen/splash_screen1.dart';
import '../utils/next_page.dart';
import 'support.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  var settingsList = [
    {
      "icon": "assets/images/icons/account.png",
      "title": "My Account",
    },
    {
      "icon": "assets/images/icons/mood_check.png",
      "title": "Mood check",
    },
    // {
    //   "icon": "assets/images/icons/host.png",
    //   "title": "Become a host",
    // },
    {
      "icon": "assets/images/icons/password.png",
      "title": "Change Password",
    },
    {
      "icon": "assets/images/icons/bell.png",
      "title": "Notification",
    },
    // {
    //   "icon": "assets/images/icons/rate.png",
    //   "title": "Rate & Review",
    // },
    {
      "icon": "assets/images/icons/help.png",
      "title": "Help",
    },
    {
      "icon": "assets/images/icons/help.png",
      "title": "Privacy Policy",
    },
  ];
  late AppBloc appBloc;
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return Container(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.withOpacity(0),
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 28.0, top: 30),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.close,
                size: 25,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: ListView(
          children: [
            FractionallySizedBox(
              alignment: Alignment.center,
              child: Text(
                "Settings",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 24),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appBloc.userDetails["status"] == "free"
                    ? Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 25),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Color(PublicVar.primaryDark),
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Unlock Premium Access",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Upgrade to get full access to all features and contents of mindcast.",
                                      style: TextStyle(
                                          color: Colors.white54, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
                const Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 15),
                  child: Text(
                    "Account",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                ),
                ListView.builder(
                    itemCount: settingsList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var settings = settingsList[index];
                      return InkWell(
                        onTap: () {
                          switch (index) {
                            case 0:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) =>
                                          const UpdateProfile()));
                              break;
                            case 1:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => const MoodBase()));
                              break;
                            // case 2:
                            //   Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (builder) =>
                            //               const BecomeHost()));
                            //   break;
                            case 2:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) =>
                                          const ChangePassword()));
                              break;

                            case 3:
                              showModalBottomSheet(
                                  backgroundColor: Colors.white,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) {
                                    return AllowNotificationModal();
                                  });
                              break;
                            // case 4:
                            //   AppActions().showSuccessToast(
                            //       text: "Coming soon", context: context);
                            //   break;
                            case 4:
                              NextPage().nextRoute(context, SupportView());
                              break;
                            case 5:
                              NextPage().nextRoute(context, TermsView());
                              break;
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
                          child: Row(
                            children: [
                              Container(
                                  width: 50,
                                  alignment: Alignment.centerLeft,
                                  child: Image.asset(
                                    settings["icon"]!,
                                  )),
                              Expanded(
                                  child: Text(
                                settings["title"]!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black.withOpacity(0.4),
                                ),
                              )),
                              Icon(Icons.chevron_right,
                                  color: Colors.black.withOpacity(0.7))
                            ],
                          ),
                        ),
                      );
                    })
              ],
            ),
            InkWell(
              onTap: () async {
                PublicVar.accountApproved = false;
                await SharedStore().removeData(key: 'accountApproved');
                PublicVar.userId = "";
                await SharedStore().removeData(
                  key: 'user_id',
                );
                NextPage().clearPages(context, SplashScreen1());
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(7)),
                child: const Text(
                  "Log out",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ));
  }
}
