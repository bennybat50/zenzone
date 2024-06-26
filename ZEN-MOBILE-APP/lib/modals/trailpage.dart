import 'package:app_framework/app_framework.dart';
import 'package:flutter/material.dart';
import 'package:mindcast/bloc/app_bloc.dart';
import 'package:mindcast/bloc/purchase_api.dart';
import 'package:mindcast/bloc/server.dart';
import 'package:mindcast/dashboard/moods/moodBase.dart';
import 'package:mindcast/dashboard/nowPlaying.dart';
import 'package:mindcast/dashboard/player2/page_manager.dart';
import 'package:mindcast/dashboard/player2/services/service_locator.dart';
import 'package:mindcast/dashboard/profile.dart';
import 'package:mindcast/dashboard/viewAllRecommended.dart';
import 'package:mindcast/models/PublicVar.dart';
import 'package:mindcast/models/urls.dart';
import 'package:mindcast/settings/appupdate.dart';
import 'package:mindcast/settings/settings.dart';
import 'package:mindcast/utils/app_actions.dart';
import 'package:mindcast/utils/next_page.dart';
import 'package:mindcast/widgets/global_widgets.dart';
import 'package:provider/provider.dart';

import 'showpaymentwidget.dart';

class TrialPage extends StatefulWidget {
  final baseKey;
  const TrialPage({
    Key? key,
    this.baseKey,
  }) : super(key: key);

  @override
  State<TrialPage> createState() => _TrialPageState();
}

class _TrialPageState extends State<TrialPage>
    with SingleTickerProviderStateMixin<TrialPage> {
  bool isSearching = false;
  late AppBloc appBloc;
  bool firstTime = false;
  ScrollController? _scrollController;
  final scrollDirection = Axis.vertical;
  bool titleDark = false, preview = false, bookmarked = false;

  @override
  void initState() {
    _scrollController = ScrollController();
    // _scrollController!.addListener(listenToScrollChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    if (!firstTime) {
      firstTime = true;
      //Server().loadDashboard(appBloc: appBloc, context: context);
      //Server().loadUser(appBloc: appBloc, context: context);
      //checkAppVersion();
    }
    return TopView();
  }

  TopView() {
    return Stack(
      children: <Widget>[
        CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 50,
              pinned: true,
              titleSpacing: 0.0,
              title: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: 1.0,
                curve: Curves.ease,
                child: InkWell(
                  onTap: () {
                    NextPage().nextRoute(context, Profile());
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello ${appBloc.userDetails["username"] ?? ""}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        "How are you doing?",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleImage(
                    url: appBloc.userDetails['image'],
                    size: 30,
                  ),
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 18.0),
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.white,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return Settings();
                          });
                    },
                    child: const Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
              elevation: 1.0,
              forceElevated: true,
              backgroundColor: Color(PublicVar.primaryBg),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Stack(
                      children: [
                        Image.asset(
                          "assets/images/background.png",
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: Colors.black.withOpacity(0.6),
                        )
                      ],
                    ),
                    // Container(
                    //   height: double.infinity,
                    //   width: double.infinity,
                    //   child: Image.asset(
                    //     'assets/images/background.png',
                    //     fit: BoxFit.cover,
                    //     width: double.infinity,
                    //   ),
                    // ),
                    // Container(
                    //   height: 70,
                    //   width: double.infinity,
                    //   child: Column(
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.symmetric(vertical: 10.0),
                    //         child: Container(
                    //           padding: EdgeInsets.symmetric(
                    //             horizontal: 10,
                    //           ),
                    //           decoration: BoxDecoration(
                    //               color: Colors.black.withOpacity(0.4),
                    //               borderRadius: BorderRadius.circular(8)),
                    //           width: double.infinity,
                    //           height: 45,
                    //           child: InkWell(
                    //             onTap: () {
                    //               Navigator.push(
                    //                   context,
                    //                   MaterialPageRoute(
                    //                       builder: (builder) =>
                    //                           const AnonymousPrompt()));
                    //             },
                    //             child: Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Container(
                    //                   width: 130,
                    //                   child: Stack(
                    //                     children: [
                    //                       Positioned(
                    //                         // left:0,
                    //                         // padding: const EdgeInsets.only(right: 0.0),
                    //                         child: Container(
                    //                           alignment: Alignment.center,
                    //                           width: 30,
                    //                           height: 30,
                    //                           decoration: BoxDecoration(
                    //                               color: Colors.blue,
                    //                               borderRadius:
                    //                                   BorderRadius.circular(
                    //                                       100)),
                    //                           child: const Text(
                    //                             "v",
                    //                             style: TextStyle(
                    //                                 color: Colors.white,
                    //                                 fontWeight:
                    //                                     FontWeight.w800),
                    //                           ),
                    //                         ),
                    //                       ),
                    //                       Positioned(
                    //                         left: 20,
                    //                         // top: 10,
                    //                         // padding: const EdgeInsets.only(left: 10.0),
                    //                         child: Container(
                    //                           alignment: Alignment.center,
                    //                           width: 30,
                    //                           height: 30,
                    //                           decoration: BoxDecoration(
                    //                               color: Colors.red,
                    //                               borderRadius:
                    //                                   BorderRadius.circular(
                    //                                       100)),
                    //                           child: const Text(
                    //                             "s",
                    //                             style: TextStyle(
                    //                                 color: Colors.white,
                    //                                 fontWeight:
                    //                                     FontWeight.w800),
                    //                           ),
                    //                         ),
                    //                       ),
                    //                       Positioned(
                    //                         left: 40,
                    //                         // top: 10,
                    //                         // padding: const EdgeInsets.only(left: 10.0),
                    //                         child: Container(
                    //                           alignment: Alignment.center,
                    //                           width: 30,
                    //                           height: 30,
                    //                           decoration: BoxDecoration(
                    //                               color: Colors.orange,
                    //                               borderRadius:
                    //                                   BorderRadius.circular(
                    //                                       100)),
                    //                           child: const Text(
                    //                             "o",
                    //                             style: TextStyle(
                    //                                 color: Colors.white,
                    //                                 fontWeight:
                    //                                     FontWeight.w800),
                    //                           ),
                    //                         ),
                    //                       ),
                    //                       Positioned(
                    //                         left: 60,
                    //                         // top: 10,
                    //                         // padding: const EdgeInsets.only(left: 10.0),
                    //                         child: Container(
                    //                           alignment: Alignment.center,
                    //                           width: 30,
                    //                           height: 30,
                    //                           decoration: BoxDecoration(
                    //                               color: Colors.green,
                    //                               borderRadius:
                    //                                   BorderRadius.circular(
                    //                                       100)),
                    //                           child: const Text(
                    //                             "p",
                    //                             style: TextStyle(
                    //                                 color: Colors.white,
                    //                                 fontWeight:
                    //                                     FontWeight.w800),
                    //                           ),
                    //                         ),
                    //                       ),
                    //                       Positioned(
                    //                         left: 80,
                    //                         // top: 10,
                    //                         // padding: const EdgeInsets.only(left: 10.0),
                    //                         child: Container(
                    //                           alignment: Alignment.center,
                    //                           width: 30,
                    //                           height: 30,
                    //                           decoration: BoxDecoration(
                    //                               border: Border.all(
                    //                                   color: Colors.white),
                    //                               color: Colors.black
                    //                                   .withOpacity(0.6),
                    //                               borderRadius:
                    //                                   BorderRadius.circular(
                    //                                       100)),
                    //                           child: const Text(
                    //                             "+12",
                    //                             style: TextStyle(
                    //                                 color: Colors.white,
                    //                                 fontWeight:
                    //                                     FontWeight.w800),
                    //                           ),
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //                 const Text(
                    //                   "Live Podcast Now",
                    //                   textAlign: TextAlign.right,
                    //                   style: TextStyle(
                    //                       color: Colors.white,
                    //                       fontWeight: FontWeight.w700,
                    //                       fontSize: 16),
                    //                 ),
                    //                 const Icon(
                    //                   Icons.play_arrow_outlined,
                    //                   color: Colors.white,
                    //                   size: 23,
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Color(PublicVar.primaryBg),
                child: SingleChildScrollView(
                  child: HomeView(),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  HomeView() {
    final pageManager = getIt<PageManager>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              fetchOffers();
            },
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
                          style: TextStyle(color: Colors.white54, fontSize: 13),
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
          ),
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(10),
          //   child: Container(
          //     width: double.infinity,
          //     color: Color(PublicVar.primaryColor).withOpacity(0.6),
          //     child: ListTile(
          //       onTap: () {
          //
          //       },
          //       title: Text(
          //         "Unlock Premium Access",
          //         style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 20,
          //             fontWeight: FontWeight.bold),
          //       ),
          //       subtitle: Text(
          //         "Upgrade to get full access to all features and contents of mindcast.",
          //         style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 14,
          //             fontWeight: FontWeight.w500),
          //       ),
          //       trailing: Container(
          //         width: 30,
          //         height: 30,
          //         alignment: Alignment.center,
          //         decoration: BoxDecoration(
          //             color: Colors.deepPurpleAccent,
          //             borderRadius: BorderRadius.circular(100)),
          //         child: Icon(
          //           Icons.chevron_right,
          //           color: Colors.white,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 20,
          ),
          ResourceItem(
            onTap: () {
              showModalBottomSheet(
                  backgroundColor: Colors.white,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return NowPlaying(
                      canPlay: true,
                      resourceData: appBloc.selectedHomeInterest[0],
                    );
                  });
            },
            onBookMark: () {},
            isFree: false,
            liked: Server().checkIfBookMarked(
                appBloc: appBloc,
                resourceID: appBloc.selectedHomeInterest[0]["_id"]),
            resourceImage: appBloc.selectedHomeInterest[0]["image"],
            interest: "Stories",
            title: appBloc.selectedHomeInterest[0]["title"],
            descp: appBloc.selectedHomeInterest[0]["description"],
            user: FutureBuilder(
                future: loadUserData(appBloc.selectedHomeInterest[0]["userID"]),
                builder: (ctx, snap) {
                  if (snap.hasData) {
                    return Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              width: 25,
                              height: 25,
                              child: GetImageProvider(
                                url: snap.data!["image"],
                                height: 25.0,
                                placeHolder: PublicVar.defaultAppImage,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          snap.data!["username"] as String,
                          style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    );
                  }
                  return SizedBox();
                }),
          ),
          SizedBox(
            height: 20,
          ),
          ValueListenableBuilder<List<String>>(
            valueListenable: pageManager.playlistNotifier,
            builder: (context, playlistTitles, _) {
              if (playlistTitles.length > 0) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: MySeparator(color: Colors.grey),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(12.5)),
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                backgroundColor: Colors.white,
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return NowPlaying(
                                    canPlay: false,
                                    resourceData: appBloc.selectedResourceData,
                                  );
                                });
                          },
                          child: GlobalAudioProgressBar(),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return SizedBox();
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: MySeparator(color: Colors.grey),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Container(
              padding: EdgeInsets.only(right: 18, top: 9, bottom: 9),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12.5)),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const MoodBase()));
                },
                child: SwitchMoodNotice(appBloc.userDetails["mood"]),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: MySeparator(color: Colors.grey),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recommended",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 22),
              ),
              InkWell(
                onTap: () {
                  NextPage().nextRoute(context, ViewAllRecommended());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    "View all",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 10),
                  ),
                ),
              )
            ],
          ),
          appBloc.userDashboard["userRecommend"] != null
              ? Column(
                  children: List<ResourceItem>.generate(2, (index) {
                    var item = appBloc.userDashboard["userRecommend"][index];
                    return ResourceItem(
                      onTap: () {
                        if (appBloc.userDetails["status"] == "free") {
                          PurchaseApi().showPackages(context, appBloc);
                        } else {
                          showModalBottomSheet(
                              backgroundColor: Colors.white,
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return NowPlaying(
                                  canPlay: true,
                                  resourceData: item["resource"],
                                );
                              });
                        }
                      },
                      onBookMark: () {},
                      isFree: appBloc.userDetails["status"] == "free",
                      liked: Server().checkIfBookMarked(
                          appBloc: appBloc,
                          resourceID: item["resource"]["_id"]),
                      resourceImage: item["resource"]["image"],
                      interest: item["interestName"],
                      title: item["resource"]["title"],
                      descp: item["resource"]["description"],
                      user: FutureBuilder(
                          future: loadUserData(item["resource"]["userID"]),
                          builder: (ctx, snap) {
                            if (snap.hasData) {
                              return Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        child: GetImageProvider(
                                          url: snap.data!["image"],
                                          height: 25.0,
                                          placeHolder:
                                              PublicVar.defaultAppImage,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    snap.data!["username"] as String,
                                    style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              );
                            }
                            return SizedBox();
                          }),
                    );
                  }).toList(),
                )
              : SizedBox(),
          SizedBox(
            height: 200,
          )
        ],
      ),
    );
  }

  loadDashboard() async {
    return await Server().loadDashboard(appBloc: appBloc, context: context);
  }

  Future<Map> loadUserData(userID) async {
    return await Server()
        .loadAData(appBloc: appBloc, url: "${Urls.aUser}/${userID}");
  }

  void _handleTapInputOutside(PointerDownEvent e) {
    FocusScope.of(context).unfocus();
    setState(() {
      isSearching = false;
    });
  }

  SwitchMoodNotice(mood) {
    switch (mood) {
      case "Happy":
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 50,
              child: Image.asset(
                "assets/images/happy_mood.png",
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: 230,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mood Check",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                  Text(
                    "Feeling Great? Take a quick check survey",
                    style: TextStyle(
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                  )
                ],
              ),
            ),
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(100)),
              child: Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
            )
          ],
        );
      case "Sad":
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 50,
              child: Image.asset(
                "assets/images/sad_mood.png",
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: 230,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mood Check",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                  Text(
                    "Feeling Under? Take a quick check survey",
                    style: TextStyle(
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                  )
                ],
              ),
            ),
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(100)),
              child: Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
            )
          ],
        );
      case "Angry":
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 50,
              child: Image.asset(
                "assets/images/angry_mood.png",
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: 230,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mood Check",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                  Text(
                    "Feeling Great? Take a quick check survey",
                    style: TextStyle(
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                  )
                ],
              ),
            ),
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(100)),
              child: Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
            )
          ],
        );
      default:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 50,
              child: Image.asset(
                "assets/images/icons/question-mark.png",
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: 230,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mood Check",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                  Text(
                    "Feeling Great? Take a quick check survey",
                    style: TextStyle(
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                  )
                ],
              ),
            ),
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(100)),
              child: Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
            )
          ],
        );
    }
  }

  void checkAppVersion() async {
    var app = await DeviceInfo().getPackageInfo();
    print(appBloc.appVersion['app_version']);
    if ("${app['v_name']}" != "${appBloc.appVersion["app_version"]}") {
      NextPage().nextRoute(context, AppUpdate());
    }
  }

  noNetwork() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.0),
      child: DisplayMessage(
        onPress: () => loadDashboard(),
        asset: 'assets/images/connection_icon.png',
        color: Colors.white,
        message: PublicVar.checkInternet,
        btnText: 'Reload',
      ),
    );
  }

  void fetchOffers() async {
    print("enter ehere");
    final offering = await PurchaseApi.fetchOffers();
    if (offering.isEmpty) {
      AppActions().showAppToast(context: context, text: "No plans found");
    } else {
      final packages = offering
          .map((offer) => offer.availablePackages)
          .expand((pair) => pair)
          .toList();

      showModalBottomSheet(
          backgroundColor: Colors.white,
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return ShowPaymentWidget(
              onClickedPackage: (package) async {
                print("Showing here >>>${package}");

                await PurchaseApi.purchasePackage(package, appBloc);
                Navigator.pop(context);
              },
              packages: packages,
            );
          });
    }
  }
}
