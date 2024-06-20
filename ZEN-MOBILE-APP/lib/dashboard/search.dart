import 'package:flutter/material.dart';
import 'package:mindcast/bloc/purchase_api.dart';
import 'package:mindcast/dashboard/viewhostProfile.dart';
import 'package:mindcast/models/PublicVar.dart';
import 'package:provider/provider.dart';

import '../bloc/app_bloc.dart';
import '../bloc/server.dart';
import '../models/urls.dart';
import '../settings/settings.dart';
import '../utils/next_page.dart';
import '../widgets/global_widgets.dart';
import 'nowPlaying.dart';

class Search extends StatefulWidget {
  final baseKey;

  const Search({
    Key? key,
    this.baseKey,
  }) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search>
    with SingleTickerProviderStateMixin<Search> {
  ScrollController? _scrollController;
  var selected = {"meditation": false, "affirmations": false, "stories": false};
  var searchTxt = TextEditingController();
  bool canSearch = false;
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
              title: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: 1.0,
                curve: Curves.ease,
                child: Text(
                  "Search Resources",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              leading: BackBtn(
                onTap: () {
                  Navigator.pop(context);
                },
                icon: Icons.chevron_left,
                titleDark: true,
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
              elevation: 0.0,
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 40,
                                  width: 170,
                                  child: TextFormField(
                                    autofocus: false,
                                    controller: searchTxt,
                                    onEditingComplete: () {
                                      FocusScope.of(context).unfocus();
                                      if (canSearch) {
                                        loadResources();
                                      }
                                      canSearch = true;
                                    },
                                    onTapOutside: _handleTapInputOutside,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Search for topics, host",
                                        hintStyle:
                                            TextStyle(color: Colors.black38),
                                        contentPadding: EdgeInsets.only(
                                            left: 10, bottom: 10)),
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
                      canSearch ? checkResourceData() : SizedBox(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  checkResourceData() {
    if (!appBloc.hasSearchResult) {
      return FutureBuilder(
        // initialData: appBloc.searchResult,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appBloc.searchResult["resources"].length < 1
            ? SizedBox()
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: const Text(
                  "Resources",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 22),
                ),
              ),
        SizedBox(
          height: 10,
        ),
        appBloc.searchResult["resources"].length < 1
            ? SizedBox()
            : GridView.builder(
                padding: EdgeInsets.all(0),
                itemCount: appBloc.searchResult["resources"].length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var podcast = appBloc.searchResult["resources"][index];
                  return SmallResource(
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
                    height: 115.0,
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
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    // mainAxisExtent: double.infinity,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
              ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: MySeparator(color: Colors.grey),
        ),
        appBloc.searchResult["hosts"].length < 1
            ? SizedBox()
            : Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 5,
                ),
                child: const Text(
                  "Hosts",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 22),
                ),
              ),
        appBloc.searchResult["hosts"].length < 1
            ? SizedBox()
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  width: double.infinity,
                  child: Container(
                    height: 110,
                    width: double.infinity,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: ScrollPhysics(),
                        itemCount: appBloc.searchResult["hosts"].length,
                        itemBuilder: (context, index) {
                          var host = appBloc.searchResult["hosts"][index];
                          return HostCard(
                            onTap: () {
                              NextPage().nextRoute(
                                  context, ViewHostProfile(hostDetails: host));
                            },
                            onBookMark: () {},
                            color: Colors.black,
                            background: Colors.deepPurple.shade100,
                            imageUrl: host["image"],
                            name: host["username"],
                            bio: host["userBio"],
                          );
                        }),
                  ),
                ),
              ),
      ],
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
    appBloc.hasSearchResult = false;
    Map data = {
      "query": searchTxt.text,
    };
    await Server()
        .postAction(bloc: appBloc, data: data, url: Urls.searchResource);
    print(appBloc.searchResult);
    appBloc.searchResult = appBloc.mapSuccess;
    appBloc.hasSearchResult = true;
  }

  noNetwork() {
    return DisplayMessage(
      onPress: () => loadResources(),
      asset: 'assets/images/connection_icon.png',
      message: PublicVar.checkInternet,
      btnText: 'Reload',
    );
  }

  noResult() {
    return DisplayMessage(
      onPress: () => loadResources(),
      asset: 'assets/images/connection_icon.png',
      message: PublicVar.checkInternet,
      btnText: 'Reload',
    );
  }
}
