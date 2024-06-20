import 'package:flutter/material.dart';
import 'package:mindcast/bloc/purchase_api.dart';
import 'package:mindcast/models/PublicVar.dart';
import 'package:provider/provider.dart';

import '../bloc/app_bloc.dart';
import '../bloc/server.dart';
import '../models/urls.dart';
import '../settings/settings.dart';
import '../widgets/global_widgets.dart';
import 'nowPlaying.dart';

class PopularResources extends StatefulWidget {
  final baseKey;

  const PopularResources({
    Key? key,
    this.baseKey,
  }) : super(key: key);

  @override
  State<PopularResources> createState() => _PopularResourcesState();
}

class _PopularResourcesState extends State<PopularResources>
    with SingleTickerProviderStateMixin<PopularResources> {
  late AppBloc appBloc;
  ScrollController? _scrollController;
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
                  "Popular Resources",
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
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                child: ResourceView(),
              ),
            )
          ],
        ),
      ],
    );
  }

  ResourceView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          GridView.builder(
            padding: EdgeInsets.all(0),
            itemCount: appBloc.popularResources.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var podcast = appBloc.popularResources[index];
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
                colorsTheme: Colors.black,
                title: podcast["title"],
                height: 120.0,
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
                crossAxisSpacing: 20,
                mainAxisSpacing: 10),
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

  loadResources() async {
    return await Server()
        .loadPopularResources(appBloc: appBloc, context: context);
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
