import 'package:flutter/material.dart';
import 'package:mindcast/bloc/purchase_api.dart';
import 'package:mindcast/dashboard/moods/moodBase.dart';
import 'package:mindcast/utils/next_page.dart';
import 'package:provider/provider.dart';

import '../bloc/app_bloc.dart';
import '../bloc/server.dart';
import '../models/PublicVar.dart';
import '../models/urls.dart';
import '../settings/updateProfile.dart';
import '../widgets/global_widgets.dart';
import 'charts.dart';
import 'nowPlaying.dart';
import 'player2/page_manager.dart';
import 'player2/services/service_locator.dart';

class Profile extends StatefulWidget {
  final baseKey;
  const Profile({Key? key, this.baseKey}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile>
    with SingleTickerProviderStateMixin<Profile> {
  @override
  late AppBloc appBloc;

  DateTime currentDate = new DateTime.now();
  ScrollController? _scrollController;
  // final GlobalKey<ScaffoldState> indexKey = GlobalKey();
  @override
  void initState() {
    _scrollController = ScrollController();
    // _scrollController!.addListener(listenToScrollChange);
    super.initState();
  }

  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);

    return Scaffold(
      body: TopView(),
    );
  }

  TopView() {
    return Stack(
      children: <Widget>[
        CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 270,
              pinned: true,
              titleSpacing: 0.0,
              title: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: 1.0,
                curve: Curves.ease,
                child: Text(
                  "My Profile",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              elevation: 1.0,
              forceElevated: true,
              backgroundColor: Color(0xff1C1232),
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
                          color: Colors.black.withOpacity(0.4),
                        )
                      ],
                    ),
                    Positioned(
                      bottom: 10,
                      right: 0,
                      left: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CircleImage(
                                      url: appBloc.userDetails['image'],
                                      size: 70,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    NextPage()
                                        .nextRoute(context, UpdateProfile());
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        // color: Colors.grey.withOpacity(0.4),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: const InkWell(
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                "${appBloc.userDetails['username'] ?? ""}",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 4.0),
                                    child: Text(
                                      "${appBloc.userDetails['experience'] ?? ""}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                // InkWell(
                                //   onTap: () {
                                //     showModalBottomSheet(
                                //         backgroundColor: Colors.transparent,
                                //         isScrollControlled: true,
                                //         context: context,
                                //         builder: (context) {
                                //           return CreateContentForm(
                                //             update: false,
                                //           );
                                //         });
                                //   },
                                //   child: const Icon(
                                //     Icons.add_circle,
                                //     size: 30,
                                //     color: Colors.white,
                                //   ),
                                // )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "${appBloc.userDetails['userBio'] ?? ""}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                child: Padding(
                  child: checkHomeData(),
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  checkHomeData() {
    if (!appBloc.hasDashboard) {
      return FutureBuilder(
        // initialData: appBloc.userDashboard,
        builder: (ctx, snap) {
          if (snap.data == false) {
            return noNetwork();
          }

          if (snap.connectionState == ConnectionState.waiting ||
              snap.connectionState == ConnectionState.active) {
            return ShowPageLoading();
          }
          return ProfileViews();
        },
        future: loadDashboard(),
      );
    } else {
      return ProfileViews();
    }
  }

  ProfileViews() {
    final pageManager = getIt<PageManager>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 20.0),
        //   child: Container(
        //     padding: EdgeInsets.symmetric(
        //       horizontal: 10,
        //     ),
        //     decoration: BoxDecoration(
        //         color: Color(0xff40176C).withOpacity(0.4),
        //         borderRadius: BorderRadius.circular(8)),
        //     width: double.infinity,
        //     height: 45,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Container(
        //           width: 130,
        //           child: Expanded(
        //             child: Stack(
        //               children: [
        //                 Positioned(
        //                   // left:0,
        //                   // padding: const EdgeInsets.only(right: 0.0),
        //                   child: Container(
        //                     alignment: Alignment.center,
        //                     width: 30,
        //                     height: 30,
        //                     decoration: BoxDecoration(
        //                         color: Colors.blue,
        //                         borderRadius: BorderRadius.circular(100)),
        //                     child: const Text(
        //                       "v",
        //                       style: TextStyle(
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.w800),
        //                     ),
        //                   ),
        //                 ),
        //                 Positioned(
        //                   left: 20,
        //                   // top: 10,
        //                   // padding: const EdgeInsets.only(left: 10.0),
        //                   child: Container(
        //                     alignment: Alignment.center,
        //                     width: 30,
        //                     height: 30,
        //                     decoration: BoxDecoration(
        //                         color: Colors.red,
        //                         borderRadius: BorderRadius.circular(100)),
        //                     child: const Text(
        //                       "s",
        //                       style: TextStyle(
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.w800),
        //                     ),
        //                   ),
        //                 ),
        //                 Positioned(
        //                   left: 40,
        //                   // top: 10,
        //                   // padding: const EdgeInsets.only(left: 10.0),
        //                   child: Container(
        //                     alignment: Alignment.center,
        //                     width: 30,
        //                     height: 30,
        //                     decoration: BoxDecoration(
        //                         color: Colors.orange,
        //                         borderRadius: BorderRadius.circular(100)),
        //                     child: const Text(
        //                       "o",
        //                       style: TextStyle(
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.w800),
        //                     ),
        //                   ),
        //                 ),
        //                 Positioned(
        //                   left: 60,
        //                   // top: 10,
        //                   // padding: const EdgeInsets.only(left: 10.0),
        //                   child: Container(
        //                     alignment: Alignment.center,
        //                     width: 30,
        //                     height: 30,
        //                     decoration: BoxDecoration(
        //                         color: Colors.green,
        //                         borderRadius: BorderRadius.circular(100)),
        //                     child: const Text(
        //                       "p",
        //                       style: TextStyle(
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.w800),
        //                     ),
        //                   ),
        //                 ),
        //                 Positioned(
        //                   left: 80,
        //                   // top: 10,
        //                   // padding: const EdgeInsets.only(left: 10.0),
        //                   child: Container(
        //                     alignment: Alignment.center,
        //                     width: 30,
        //                     height: 30,
        //                     decoration: BoxDecoration(
        //                         border: Border.all(color: Colors.white),
        //                         color: Colors.black.withOpacity(0.6),
        //                         borderRadius: BorderRadius.circular(100)),
        //                     child: const Text(
        //                       "+12",
        //                       style: TextStyle(
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.w800),
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //         const Text(
        //           "Live Podcast Now",
        //           textAlign: TextAlign.right,
        //           style: TextStyle(
        //               color: Colors.white,
        //               fontWeight: FontWeight.w700,
        //               fontSize: 14),
        //         ),
        //         const Icon(
        //           Icons.play_arrow_outlined,
        //           color: Colors.white,
        //           size: 16,
        //         )
        //       ],
        //     ),
        //   ),
        // ),
        appBloc.userDetails["hostStatus"] == "pending"
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8)),
                  width: double.infinity,
                  height: 45,
                  child: Text(
                    "Mincast Host Resuest Pending...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 14),
                  ),
                ),
              )
            : SizedBox(),

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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.black,
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
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: InkWell(
            onTap: () {
              NextPage().nextRoute(context, MoodBase());
            },
            child: findLargestMood(
                appBloc.userDashboard["allMoods"][0]["data"]
                    [currentDate.month - 1]["total"],
                appBloc.userDashboard["allMoods"][1]["data"]
                    [currentDate.month - 1]["total"],
                appBloc.userDashboard["allMoods"][2]["data"]
                    [currentDate.month - 1]["total"]),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: Colors.grey[200],
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1.02,
                    child: Stack(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const SizedBox(
                              height: 25,
                            ),
                            const Text(
                              'Mood Tracker',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 6, left: 6),
                                child: LineChartView(
                                  isShowingMainData: true,
                                  happyDays: appBloc.userDashboard["allMoods"]
                                      [0]["data"],
                                  sadDays: appBloc.userDashboard["allMoods"][1]
                                      ["data"],
                                  angryDays: appBloc.userDashboard["allMoods"]
                                      [2]["data"],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GetCircle(Color(PublicVar.happy), "Happy"),
                        GetCircle(Color(PublicVar.angry), "Anger"),
                        GetCircle(Color(PublicVar.sad), "Sad"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        ),

        const Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Text(
            "Recommended Resources",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w700, fontSize: 25),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: appBloc.userDashboard["userRecommend"].length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              var podcast =
                  appBloc.userDashboard["userRecommend"][index]["resource"];
              return Padding(
                padding: EdgeInsets.only(right: 18.0),
                child: SmallResource(
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
                              resourceData: podcast,
                            );
                          });
                    }
                  },
                  onBookMark: () {},
                  isFree: appBloc.userDetails["status"] == "free",
                  liked: Server().checkIfBookMarked(
                      appBloc: appBloc, resourceID: podcast["_id"]),
                  colorsTheme: Colors.white,
                  title: podcast["title"],
                  height: 120.0,
                  width: 130.0,
                  duration: podcast["duration"],
                  imageUrl: podcast["image"],
                  user: FutureBuilder(
                      future: loadUserData(podcast["userID"]),
                      builder: (context, snap) {
                        if (snap.hasData) {
                          return Text(
                            "${snap.data!["username"]}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                          );
                        }
                        return SizedBox();
                      }),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 150,
        )
      ],
    );
  }

  Widget GetCircle(color, text) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 20,
            height: 20,
            color: color,
          ),
        ),
        Text(
          text,
          style: TextStyle(color: Colors.black),
        )
      ],
    );
  }

  Widget findLargestMood(int num1, int num2, int num3) {
    if (num1 >= num2 && num1 >= num3) {
      return Container(
        child: Container(
          width: double.infinity,
          height: 210,
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
              color: Color(PublicVar.happy),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mood Check",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    "${num1}",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 70),
                  ),
                  Text(
                    "Days of happiness",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  )
                ],
              ),
              Expanded(
                  child: Image.asset(
                "assets/images/happy.png",
              ))
            ],
          ),
        ),
      );
    } else if (num2 >= num1 && num2 >= num3) {
      return Container(
        child: Container(
          width: double.infinity,
          height: 200,
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
              color: Color(PublicVar.sad),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mood Check",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    "${num2}",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 70),
                  ),
                  Text(
                    "Days of Sadness",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  )
                ],
              ),
              Expanded(
                  child: Image.asset(
                "assets/images/sad.png",
              ))
            ],
          ),
        ),
      );
    } else {
      return Container(
        child: Container(
          width: double.infinity,
          height: 200,
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
              color: Color(PublicVar.angry),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mood Check",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    "${num3}",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 70),
                  ),
                  Text(
                    "Days of Anger",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  )
                ],
              ),
              Expanded(
                  child: Image.asset(
                "assets/images/angry.png",
              ))
            ],
          ),
        ),
      );
    }
  }

  int findLargest(int num1, int num2, int num3) {
    if (num1 >= num2 && num1 >= num3) {
      return num1;
    } else if (num2 >= num1 && num2 >= num3) {
      return num2;
    } else {
      return num3;
    }
  }

  noNetwork() {
    return DisplayMessage(
      onPress: () => loadDashboard(),
      asset: 'assets/images/connection_icon.png',
      color: Colors.black,
      message: PublicVar.checkInternet,
      btnText: 'Reload',
    );
  }

  loadDashboard() async {
    return await Server().loadDashboard(appBloc: appBloc, context: context);
  }

  Future<Map> loadUserData(userID) async {
    return await Server()
        .loadAData(appBloc: appBloc, url: "${Urls.aUser}/${userID}");
  }
}
