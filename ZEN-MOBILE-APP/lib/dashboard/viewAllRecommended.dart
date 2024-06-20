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

class ViewAllRecommended extends StatefulWidget {
  final baseKey;

  const ViewAllRecommended({
    Key? key,
    this.baseKey,
  }) : super(key: key);

  @override
  State<ViewAllRecommended> createState() => _ViewAllRecommendedState();
}

class _ViewAllRecommendedState extends State<ViewAllRecommended>
    with SingleTickerProviderStateMixin<ViewAllRecommended> {
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
                  "Recommended Resources",
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
      child: ListView.builder(
          physics: ScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: appBloc.userDashboard["userRecommend"].length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var item = appBloc.userDashboard["userRecommend"][index];
            //print(item);
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
              background: Color(PublicVar.primaryBg),
              onBookMark: () {},
              isFree: appBloc.userDetails["status"] == "free",
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
            );
          }),
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
