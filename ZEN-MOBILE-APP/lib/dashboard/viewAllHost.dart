import 'package:flutter/material.dart';
import 'package:mindcast/dashboard/viewhostProfile.dart';
import 'package:mindcast/models/PublicVar.dart';
import 'package:provider/provider.dart';

import '../bloc/app_bloc.dart';
import '../bloc/server.dart';
import '../models/urls.dart';
import '../settings/settings.dart';
import '../utils/next_page.dart';
import '../widgets/global_widgets.dart';

class ViewAllHost extends StatefulWidget {
  final baseKey;

  const ViewAllHost({
    Key? key,
    this.baseKey,
  }) : super(key: key);

  @override
  State<ViewAllHost> createState() => _ViewAllHostState();
}

class _ViewAllHostState extends State<ViewAllHost>
    with SingleTickerProviderStateMixin<ViewAllHost> {
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
                  "All Host",
                  style: TextStyle(color: Colors.white, fontSize: 30),
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
        initialData: appBloc.resources,
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.0),
      child: ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: appBloc.userDashboard["allHost"].length,
          itemBuilder: (context, index) {
            var host = appBloc.userDashboard["allHost"][index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: HostCard(
                onTap: () {
                  NextPage()
                      .nextRoute(context, ViewHostProfile(hostDetails: host));
                },
                onBookMark: () {},
                color: Colors.black,
                background: Colors.deepPurple.shade100,
                imageUrl: host["image"],
                name: host["username"],
                bio: host["userBio"],
              ),
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
