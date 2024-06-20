import 'package:flutter/material.dart';
import 'package:mindcast/bloc/purchase_api.dart';
import 'package:mindcast/modals/createContentForm.dart';
import 'package:provider/provider.dart';

import '../bloc/app_bloc.dart';
import '../bloc/server.dart';
import '../models/PublicVar.dart';
import '../settings/settings.dart';
import '../widgets/global_widgets.dart';
import 'nowPlaying.dart';

class HostingProfile extends StatefulWidget {
  final baseKey;

  const HostingProfile({
    Key? key,
    this.baseKey,
  }) : super(key: key);

  @override
  State<HostingProfile> createState() => _ResourcesState();
}

class _ResourcesState extends State<HostingProfile>
    with SingleTickerProviderStateMixin<HostingProfile> {
  var popularResources = [
    {
      "title": "Daily mood",
      "author": "VOO Onoja",
      "duration": "34",
      "thumbnail": "assets/images/clock.webp",
      "like": false,
    },
    {
      "title": "Tribal sounds",
      "author": "Roman Collins",
      "duration": "20",
      "thumbnail": "assets/images/zebra.jpg",
      "like": true,
    },
    {
      "title": "chaotic MINDS",
      "author": "Sarah Williams",
      "duration": "20",
      "thumbnail": "assets/images/card2.jpg",
      "like": false,
    },
    {
      "title": "Soul & MINDS",
      "author": "Onoja VOO",
      "duration": "25",
      "thumbnail": "assets/images/card3.jpg",
      "like": false,
    },
  ];
  var newRelease = [
    {
      "genre": "Stories",
      "title": "Under the sea",
      "prompt": "Feeling under? Take a quick check survey",
      "playProgress": 0.4,
      "isPlaying": false,
      "author_name": "Jessica J.",
      "thumbnail": "assets/images/card4.jpg",
      "favorite": false
    },
    {
      "genre": "Stories",
      "title": "Focus therapy",
      "prompt": "For self discovery and self improvement",
      "playProgress": 0.7,
      "isPlaying": false,
      "author_name": "Jessica J.",
      "thumbnail": "assets/images/card0.jpg",
      "favorite": false
    },
    {
      "genre": "Stories",
      "title": "Speech therapy",
      "prompt": "Feeling under? Take a quick check survey",
      "playProgress": 0.2,
      "isPlaying": false,
      "author_name": "Jessica J.",
      "thumbnail": "assets/images/card1.jpg",
      "favorite": false
    },
  ];

  var selected = {
    "new": true,
    "mood": false,
    "relationship": false,
    "stories": false
  };
  late AppBloc appBloc;
  bool firstTime = false;

  ScrollController? _scrollController;
  // final GlobalKey<ScaffoldState> indexKey = GlobalKey();
  @override
  void initState() {
    _scrollController = ScrollController();
    // _scrollController!.addListener(listenToScrollChange);
    super.initState();
  }

  // final GlobalKey<ScaffoldState> indexKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    if (!firstTime) {
      appBloc.hasHostData = false;
      firstTime = true;
    }
    return Scaffold(backgroundColor: Colors.white, body: TopView());
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const Settings()));
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
                    Positioned(
                      bottom: 0,
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
                                Container(
                                  alignment: Alignment.center,
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      // color: Colors.grey.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(100)),
                                  child: const InkWell(
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                "${appBloc.userDetails['username'].toString().toUpperCase() ?? ""}",
                                style: TextStyle(
                                    fontSize: 25,
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
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) {
                                          return CreateContentForm(
                                            update: false,
                                          );
                                        });
                                  },
                                  child: const Icon(
                                    Icons.add_circle,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "${appBloc.userDetails['userBio'] ?? ""}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: TextStyle(
                                    fontSize: 13,
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
                child: checkHomeData(),
              ),
            )
          ],
        ),
      ],
    );
  }

  checkHomeData() {
    if (!appBloc.hasHostData) {
      return FutureBuilder(
        builder: (ctx, snap) {
          if (snap.data == false) {
            return noNetwork();
          }
          if (snap.connectionState == ConnectionState.waiting ||
              snap.connectionState == ConnectionState.active) {
            return ShowPageLoading();
          }
          return HomeView();
        },
        future: loadHost(),
      );
    } else {
      return HomeView();
    }
  }

  HomeView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
            ),
            child: Container(
              width: double.infinity,
              height: 50,
              padding: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white))),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (ctx, i) {
                  //return Text("Hello");
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Theme(
                      data: ThemeData(canvasColor: Colors.transparent),
                      child: FilterChip(
                        label: Text(appBloc.hostDashboard["hostedResources"][i]
                                ["interest"]['name'] ??
                            ''),
                        onSelected: (bool value) {
                          appBloc.selectedHostInterestIndex = i;
                          appBloc.selectedHostInterest =
                              appBloc.hostDashboard["hostedResources"][i]
                                  ["interestedResources"];
                          appBloc.selectedHostInterestId =
                              '${appBloc.hostDashboard["hostedResources"][i]["interest"]["_id"]}';
                        },
                        showCheckmark: false,
                        tooltip: 'Select from list of Interest',
                        selected: appBloc.selectedHostInterestId.contains(
                            '${appBloc.hostDashboard["hostedResources"][i]["interest"]["_id"]}'),
                        selectedColor: Color(PublicVar.primaryColor),
                        labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                      ),
                    ),
                  );
                },
                itemCount: appBloc.hostDashboard["hostedResources"].length,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: GridView.builder(
              itemCount: appBloc.selectedHostInterest.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var podcast = appBloc.selectedHostInterest[index];
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
                  colorsTheme: Colors.black54,
                  title: podcast["title"],
                  height: 115.0,
                  width: double.infinity,
                  duration: podcast["duration"],
                  imageUrl: podcast["image"],
                  user: Container(
                    width: double.infinity,
                    child: Text(
                      "${podcast["description"]}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  // mainAxisExtent: double.infinity,
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
            ),
          ),
        ],
      ),
    );
  }

  loadHost() async {
    return await Server().loadHost(appBloc: appBloc, context: context);
  }

  oldView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
      child: ListView(
        children: [
          Container(
            // width: 800,
            padding: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black))),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                constraints: BoxConstraints(minWidth: 350),
                // height: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: selected["new"]!
                              ? (Color(0xff40176C))
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6)),
                      // width: 80,
                      child: InkWell(
                        onTap: () {
                          //updateSelected("new");
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: selected["new"]!
                                  ? Colors.white
                                  : Colors.black,
                              size: 16,
                            ),
                            Text(
                              " New",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: selected["new"]!
                                      ? Colors.white
                                      : Colors.black38,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: selected["relationship"]!
                              ? (Color(0xff40176C))
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6)),
                      child: InkWell(
                        onTap: () {
                          //updateSelected("relationship");
                        },
                        child: Text(
                          "Relationship",
                          style: TextStyle(
                              color: selected["relationship"]!
                                  ? Colors.white
                                  : Colors.black38,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: selected["stories"]!
                              ? (Color(0xff40176C))
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6)),
                      child: InkWell(
                        onTap: () {
                          //updateSelected("stories");
                        },
                        child: Text(
                          "Stories",
                          style: TextStyle(
                              color: selected["stories"]!
                                  ? Colors.white
                                  : Colors.black38,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 30, bottom: 10),
                child: const Text(
                  "Recommended hosts",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 25),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Container(
                            width: 300,
                            decoration: BoxDecoration(
                                color: Colors.pink.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 130,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)),
                                    child: Image.asset(
                                      "assets/images/avatar.jpg",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 35,
                                          child: Text(
                                            "Sigmund Owen",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 25),
                                          ),
                                        ),
                                        Container(
                                          height: 50,
                                          child: Text(
                                            "Relationship, moodswings, self development",
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Text(
                                          "540 Subscribers",
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.4),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Container(
                            width: 300,
                            decoration: BoxDecoration(
                                color: Colors.greenAccent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 130,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)),
                                    child: Image.asset(
                                      "assets/images/dorcas.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 35,
                                          child: Text(
                                            "Sigmund Owen",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 25),
                                          ),
                                        ),
                                        Container(
                                          height: 50,
                                          child: Text(
                                            "Relationship, moodswings, self development",
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Text(
                                          "540 Subscribers",
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.4),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30, bottom: 10),
                child: const Text(
                  "Popular PodcasterProfile",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 25),
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: popularResources.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var resource = popularResources[index];
                    return Container(
                      padding: EdgeInsets.only(left: index == 0 ? 0 : 20),
                      child: Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  // color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          '${resource["thumbnail"]}'),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(
                                  "${resource["title"]}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                child: Text(
                                  "${resource["duration"]} MIN",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          if (selected["stories"]!)
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: GridView.builder(
                itemCount: popularResources.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var podcast = popularResources[index];
                  return SizedBox(
                    // padding: EdgeInsets.only(left: index == 0 ? 0 : 20),
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 135,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: AssetImage(
                                            '${podcast["thumbnail"]}'),
                                        fit: BoxFit.cover,
                                        alignment: Alignment.center),
                                  ),
                                ),
                                Positioned(
                                  right: 5,
                                  top: 5,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        podcast["like"] =
                                            !(podcast["like"] as bool);
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.4),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: InkWell(
                                        child: Icon(
                                          podcast["like"] == true
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 65,
                                  child: Container(
                                      // height: 70,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Text(
                                        "${podcast["title"]}".toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Text(
                                "${podcast["author"]}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0),
                              child: Text(
                                "${podcast["duration"]} MIN",
                                style: TextStyle(
                                    color: Colors.grey.withOpacity(0.7),
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    // mainAxisExtent: double.infinity,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
              ),
            ),
          if (selected["new"]!)
            ListView.builder(
                itemCount: newRelease.length,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) {
                  Map item = newRelease[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.2),
                          // color: Color(0xffEBE0FD),
                          // color: Color(0xff734F96).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Container(
                            width: 120,
                            height: 130,
                            padding: EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                item["thumbnail"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    item["title"],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Text(
                                    item["prompt"],
                                    style: const TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                ),
                                LinearProgressIndicator(
                                  value: item["playProgress"],
                                  backgroundColor: Colors.grey,
                                  color: Colors.black,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Color(0xff40176C),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.play_arrow_outlined,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
        ],
      ),
    );
  }

  noNetwork() {
    return DisplayMessage(
      onPress: () => loadHost(),
      asset: 'assets/images/connection_icon.png',
      color: Colors.black,
      message: PublicVar.checkInternet,
      btnText: 'Reload',
    );
  }
}
