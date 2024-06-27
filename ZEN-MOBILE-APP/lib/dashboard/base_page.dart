import 'dart:io';

import 'package:app_framework/app_framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mindcast/bloc/server.dart';
import 'package:mindcast/dashboard/profile.dart';
import 'package:mindcast/dashboard/resources.dart';
import 'package:mindcast/firebase_api.dart';
import 'package:mindcast/modals/allow_notifications_modal.dart';
import 'package:mindcast/modals/show_messages.dart';
import 'package:mindcast/models/urls.dart';
import 'package:mindcast/utils/app_actions.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/app_bloc.dart';
import 'downloads.dart';
import 'home_page.dart';
import 'player2/page_manager.dart';
import 'player2/services/service_locator.dart';

class BasePage extends StatefulWidget {
  final baseIndex;
  const BasePage({Key? key, this.baseIndex}) : super(key: key);

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  final GlobalKey<ScaffoldState> baseKey = GlobalKey();
  var currentIndex = 0;
  List<Widget>? pages;
  Widget? currentPage;
  var navigationIconSize = 28.0;

  //METHOD TWO
  final List<Widget> screens = [
    HomePage(),
    Resources(),
    Downloads(),
    Profile(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Resources();
  late AppBloc appBloc;
  bool firstTime = false;
  @override
  void initState() {
    pages = [
      HomePage(
        baseKey: baseKey,
      ),
      Resources(
        baseKey: baseKey,
      ),
      Downloads(
        baseKey: baseKey,
      ),
      Profile(
        baseKey: baseKey,
      )
    ];

    if (widget.baseIndex != null) {
      currentScreen = pages![widget.baseIndex];
    } else {
      currentScreen = HomePage(
        baseKey: baseKey,
      );
    }
    showNotificationDialog();
    //checkAppInfo();
    checkAppMessages();
    super.initState();
  }

  @override
  void dispose() {
    getIt<PageManager>().dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    if (!firstTime) {
      if (widget.baseIndex != null) {
        appBloc.pageIndex = widget.baseIndex;
        currentPage = pages![widget.baseIndex];
      }
      firstTime = true;
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      key: baseKey,
      // body: currentPage,
      body: currentScreen,

      // floatingActionButton: Container(
      //   height: 50,
      //   width: 50,
      //   decoration: BoxDecoration(
      //       color: Colors.deepPurple,
      //       borderRadius: BorderRadius.circular(100),
      //       border: Border.all(color: Colors.deepPurpleAccent.shade100)),
      //   child: InkWell(
      //     onTap: () {
      //       setState(() {
      //         currentScreen = const Podcast();
      //         currentTab = 4;
      //       });
      //
      //       //showJoinPodcastPrompt(context);
      //     },
      //     child: Icon(
      //       Icons.mic,
      //       size: 30,
      //       color: Colors.white,
      //     ),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: Container(
      //   child: BottomAppBar(
      //     color: Colors.black,
      //     shape: CircularNotchedRectangle(),
      //     notchMargin: 10,
      //     child: Container(
      //       height: 50,
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Row(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               MaterialButton(
      //                 minWidth: 40,
      //                 onPressed: () {
      //                   setState(() {
      //                     currentScreen = Index();
      //                     currentTab = 0;
      //                   });
      //                 },
      //                 child: Column(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     Icon(Icons.home,
      //                         size: 28,
      //                         color:
      //                             currentTab == 0 ? Colors.white : Colors.grey),
      //                     Text(
      //                       "Home",
      //                       style: TextStyle(
      //                           fontSize: 12,
      //                           color: currentTab == 0
      //                               ? Colors.white
      //                               : Colors.grey),
      //                     )
      //                   ],
      //                 ),
      //               ),
      //               MaterialButton(
      //                 minWidth: 40,
      //                 onPressed: () {
      //                   setState(() {
      //                     currentScreen = Resources();
      //                     currentTab = 1;
      //                   });
      //                 },
      //                 child: Column(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     Icon(FontAwesome.book,
      //                         size: 25,
      //                         color:
      //                             currentTab == 1 ? Colors.white : Colors.grey),
      //                     Text(
      //                       "Resources",
      //                       style: TextStyle(
      //                           fontSize: 12,
      //                           color: currentTab == 1
      //                               ? Colors.white
      //                               : Colors.grey),
      //                     )
      //                   ],
      //                 ),
      //               ),
      //             ],
      //           ),
      //           Row(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               MaterialButton(
      //                 minWidth: 40,
      //                 onPressed: () {
      //                   setState(() {
      //                     currentScreen = Downloads();
      //                     currentTab = 2;
      //                   });
      //                 },
      //                 child: Column(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     Icon(FontAwesome.heart,
      //                         size: 25,
      //                         color:
      //                             currentTab == 2 ? Colors.white : Colors.grey),
      //                     Text(
      //                       "Saved",
      //                       style: TextStyle(
      //                           fontSize: 12,
      //                           color: currentTab == 2
      //                               ? Colors.white
      //                               : Colors.grey),
      //                     )
      //                   ],
      //                 ),
      //               ),
      //               MaterialButton(
      //                 minWidth: 40,
      //                 onPressed: () {
      //                   setState(() {
      //                     currentScreen = Profile();
      //                     currentTab = 3;
      //                   });
      //                 },
      //                 child: Column(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     Icon(FontAwesome.user_circle_o,
      //                         size: 25,
      //                         color:
      //                             currentTab == 3 ? Colors.white : Colors.grey),
      //                     Text(
      //                       "Profile",
      //                       style: TextStyle(
      //                           fontSize: 12,
      //                           color: currentTab == 3
      //                               ? Colors.white
      //                               : Colors.grey),
      //                     )
      //                   ],
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        showSelectedLabels: true,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        elevation: 2.5,
        unselectedFontSize: 12,
        selectedFontSize: 14,
        type: BottomNavigationBarType.fixed,
        iconSize: navigationIconSize,
        onTap: (index) {
          setState(() {
            appBloc.pageIndex = index;
            currentScreen = pages![index];
          });
        },
        currentIndex: appBloc.pageIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Ionicons.ios_home,
                size: navigationIconSize,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesome.book,
                size: navigationIconSize,
              ),
              label: "Resources"),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesome.heart,
                size: navigationIconSize,
              ),
              label: "Favorites"),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesome.user_circle_o,
                size: navigationIconSize,
              ),
              label: "Profile"),
        ],
      ),
    );
  }

  checkAppInfo() {
    Future.delayed(Duration(seconds: 1), () async {
      var device = await DeviceInfo().getInfo(context);
      var app = await DeviceInfo().getPackageInfo();

      if (await Server().getAction(appBloc: appBloc, url: Urls.getAppUpdate)) {
        var info = appBloc.mapSuccess;
        print(info);
        if (info != null && info['v_code'] == app['v_code']) {
          print("App is up to date");
        } else if (info['v_code'] != app['v_code']) {
          AppActions().showAppDialog(context,
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/icons/update_icon.png",
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      "Please update to continue enjoying your resources",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
              title: "New Version Available",
              singlAction: true, okAction: () async {
            Navigator.pop(context);
            if (Platform.isAndroid) {
              await launch(
                  'https://play.google.com/store/apps/details?id=com.psyche.life');
            } else if (Platform.isIOS) {
              await launch(
                  'https://apps.apple.com/ng/app/mindacst/id6463614493');
            }
          }, okText: "Update");
        }
      }
    });
  }

  checkAppMessages() {
    Future.delayed(Duration(seconds: 1), () async {
      if (await Server().getAction(appBloc: appBloc, url: Urls.getAppMessage)) {
        var info = appBloc.mapSuccess;
        print(info);
        if (info != null && info["status"] == "active") {
          showModalBottomSheet(
              backgroundColor: Colors.white,
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return ShowMessages(
                  title: info["title"],
                  message: info["message"],
                  image: info["image"],
                );
              });
        }
      }
    });
  }

  void showNotificationDialog() async {
    if (await SharedStore().getData(type: 'bool', key: 'allowNotification') ==
        null) {
      Future.delayed(Duration(seconds: 1), () {
        showModalBottomSheet(
            backgroundColor: Colors.white,
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return AllowNotificationModal();
            });
      });
    } else {
      FirebaseApi().initNotifications(true);
    }
  }
}
