import 'package:flutter/material.dart';
import 'package:mindcast/bloc/purchase_api.dart';
import 'package:mindcast/dashboard/search.dart';
import 'package:mindcast/models/PublicVar.dart';
import 'package:provider/provider.dart';

import '../bloc/app_bloc.dart';
import '../bloc/server.dart';
import '../models/urls.dart';
import '../settings/settings.dart';
import '../widgets/global_widgets.dart';
import 'nowPlaying.dart';
import 'player2/page_manager.dart';
import 'player2/services/service_locator.dart';

class Resources extends StatefulWidget {
  final baseKey;

  const Resources({
    Key? key,
    this.baseKey,
  }) : super(key: key);

  @override
  State<Resources> createState() => _ResourcesState();
}

class _ResourcesState extends State<Resources>
    with SingleTickerProviderStateMixin<Resources> {
  ScrollController? _scrollController;

  var selected = {"meditation": false, "affirmations": false, "stories": false};
  late AppBloc appBloc;
  // final GlobalKey<ScaffoldState> indexKey = GlobalKey();

  @override
  void initState() {
    _scrollController = ScrollController();
    // _scrollController!.addListener(listenToScrollChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    var noneSelected = !selected.containsValue(true);
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
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
              expandedHeight: 70,
              pinned: true,
              titleSpacing: 0.0,
              leading: SizedBox(),
              title: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: 1.0,
                curve: Curves.ease,
                child: Text(
                  "Resources",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.white,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Settings();
                        });
                  },
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                )
              ],
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
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                child: checkResourceData(),
              ),
            )
          ],
        ),
      ],
    );
  }

  checkResourceData() {
    if (!appBloc.hasResources) {
      return FutureBuilder(
        builder: (ctx, snap) {
          if (snap.data == false) {
            return noNetwork();
          }
          if (snap.connectionState == ConnectionState.waiting ||
              snap.connectionState == ConnectionState.active) {
            return ShowPageLoading(
              color: Color(PublicVar.textPrimaryDark),
            );
          }
          return ResourceView();
        },
        future: loadResources(),
      );
    } else {
      return ResourceView();
    }
  }

  ResourceView() {
    final pageManager = getIt<PageManager>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      spreadRadius: 1,
                      color: Colors.grey.shade400,
                    )
                  ],
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const Search()));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 40,
                        width: 170,
                        child: TextFormField(
                          autofocus: false,
                          enabled: false,
                          onTapOutside: _handleTapInputOutside,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search for topics",
                              hintStyle: TextStyle(color: Colors.black38),
                              contentPadding:
                                  EdgeInsets.only(left: 10, bottom: 10)),
                        ),
                      ),
                      Container(
                        width: 20,
                        // height: 40,
                        child: const Icon(
                          Icons.search,
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Container(
              width: double.infinity,
              height: 50,
              padding: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black))),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: appBloc.resources.length,
                itemBuilder: (ctx, i) {
                  if (appBloc.resources[i]["resource"].length == 0) {
                    return SizedBox();
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Theme(
                      data: ThemeData(canvasColor: Colors.transparent),
                      child: FilterChip(
                        label: Text(
                            appBloc.resources[i]["interest"]['name'] ?? ''),
                        onSelected: (bool value) {
                          appBloc.selectedInterestResourceIndex = i;
                          appBloc.selectedInterestResource =
                              appBloc.resources[i];
                          appBloc.selectedInterestId =
                              '${appBloc.resources[i]["interest"]["_id"]}';
                          setState(() {});
                        },
                        showCheckmark: false,
                        tooltip: 'Select from list of Interest',
                        selected: appBloc.selectedInterestId.contains(
                            '${appBloc.resources[i]["interest"]["_id"]}'),
                        selectedColor: Color(PublicVar.primaryColor),
                        labelStyle: TextStyle(
                            color: appBloc.selectedInterestId.contains(
                                    '${appBloc.resources[i]["interest"]["_id"]}')
                                ? Colors.white
                                : Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          ResourceItem(
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
                        resourceData:
                            appBloc.selectedInterestResource["resource"][0],
                      );
                    });
              }
            },
            onBookMark: () {},
            isFree: appBloc.userDetails["status"] == "free",
            liked: Server().checkIfBookMarked(
                appBloc: appBloc,
                resourceID: appBloc.selectedInterestResource["resource"][0]
                    ["_id"]),
            background: Color(PublicVar.primaryColor),
            resourceImage: appBloc.selectedInterestResource["resource"][0]
                ["image"],
            interest: appBloc.selectedInterestResource["interest"]["name"],
            title: appBloc.selectedInterestResource["resource"][0]["title"],
            descp: appBloc.selectedInterestResource["resource"][0]
                ["description"],
            user: FutureBuilder(
                future: loadUserData(
                    appBloc.selectedInterestResource["resource"][0]["userID"]),
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
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
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
          GridView.builder(
            padding: EdgeInsets.zero,
            itemCount: appBloc.selectedInterestResource["resource"].length <= 8
                ? appBloc.selectedInterestResource["resource"].length
                : 8,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var length = appBloc.selectedInterestResource["resource"].length;
              var podcast;
              var resindex = index + 1;
              if (resindex < length) {
                podcast =
                    appBloc.selectedInterestResource["resource"][resindex];
              }
              return podcast != null
                  ? SmallResource(
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
                      colorsTheme: Colors.black54,
                      title: podcast["title"],
                      height: 100.0,
                      width: double.infinity,
                      duration: podcast["duration"],
                      imageUrl: podcast["image"],
                      user: FutureBuilder(
                          future: loadUserData(podcast["userID"]),
                          builder: (context, snap) {
                            if (snap.hasData) {
                              return Text(
                                "${snap.data!["username"]}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14),
                              );
                            }
                            return SizedBox();
                          }),
                    )
                  : ButtonWidget(
                      loading: false,
                      bgColor: Color(PublicVar.primaryLight),
                      text: "View More",
                      fontSize: 20.0,
                      icon: Icons.arrow_right_alt_rounded,
                      iconColor: Colors.white,
                      txColor: Colors.white,
                    );
            },
            primary: false,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                // mainAxisExtent: double.infinity,
                childAspectRatio: 1.0,
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 10),
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: 20.0),
          //   child: MySeparator(color: Colors.grey),
          // ),
          // Padding(
          //   padding: EdgeInsets.symmetric(
          //     vertical: 5,
          //   ),
          //   child: const Text(
          //     "Recommended Hosts",
          //     style: TextStyle(
          //         color: Colors.black,
          //         fontWeight: FontWeight.w800,
          //         fontSize: 22),
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: 5),
          //   child: Container(
          //     width: double.infinity,
          //     child: Container(
          //       height: 111,
          //       width: double.infinity,
          //       child: ListView.builder(
          //           shrinkWrap: true,
          //           scrollDirection: Axis.horizontal,
          //           physics: ScrollPhysics(),
          //           itemCount: appBloc.userDashboard["allHost"].length,
          //           itemBuilder: (context, index) {
          //             var host = appBloc.userDashboard["allHost"][index];
          //             return Padding(
          //               padding: EdgeInsets.only(right: 8.0),
          //               child: HostCard(
          //                 onTap: () {
          //                   NextPage().nextRoute(
          //                       context, ViewHostProfile(hostDetails: host));
          //                 },
          //                 onBookMark: () {},
          //                 color: Colors.black,
          //                 background: Colors.deepPurple.shade100,
          //                 imageUrl: host["image"],
          //                 name: host["username"],
          //                 bio: host["userBio"],
          //               ),
          //             );
          //           }),
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: 20.0),
          //   child: MySeparator(color: Colors.grey),
          // ),
          SizedBox(
            height: 200,
          )
        ],
      ),
    );
  }

  void _handleTapInputOutside(PointerDownEvent e) {
    FocusScope.of(context).unfocus();
    setState(() {
      // isSearching = false;
    });
  }

  Future<Map> loadUserData(userID) async {
    return await Server()
        .loadAData(appBloc: appBloc, url: "${Urls.aUser}/${userID}");
  }

  void updateSelected(String key) {
    setState(() {
      selected.forEach((k, _) {
        selected[k] = (k == key);
      });
    });
  }

  loadResources() async {
    return await Server().loadResources(appBloc: appBloc, context: context);
  }

  noNetwork() {
    return DisplayMessage(
      onPress: () => loadResources(),
      asset: 'assets/images/connection_icon.png',
      message: PublicVar.checkInternet,
      btnText: 'Reload',
    );
  }
}
