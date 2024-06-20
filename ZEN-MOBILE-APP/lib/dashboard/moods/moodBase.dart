import 'package:flutter/material.dart';
import 'package:mindcast/dashboard/moods/angry.dart';
import 'package:mindcast/dashboard/moods/happy.dart';
import 'package:mindcast/dashboard/moods/sad.dart';
import 'package:provider/provider.dart';

import '../../bloc/app_bloc.dart';
import '../../bloc/server.dart';
import '../../models/PublicVar.dart';
import '../../models/urls.dart';
import '../../utils/app_actions.dart';
import '../../widgets/global_widgets.dart';

class MoodBase extends StatefulWidget {
  const MoodBase({Key? key}) : super(key: key);
  @override
  _MoodBaseState createState() => _MoodBaseState();
}

class _MoodBaseState extends State<MoodBase> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  late AppBloc appBloc;
  bool loading = false;
  List moods = ["Happy", "Sad", "Angry"];
  var currentMood = "Happy";

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        Navigator.pop(context, true);
      },
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              physics: BouncingScrollPhysics(),
              pageSnapping: true,
              onPageChanged: (index) {
                currentMood = moods[index];
                setState(() {
                  _currentPageIndex = index;
                });
              },
              children: [Happy(), Sad(), Angry()],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 40),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                child: ButtonWidget(
                  onPress: () {
                    if (!loading) {
                      updateMood(currentMood);
                    }
                  },
                  width: double.infinity,
                  height: 50.0,
                  txColor: Colors.black,
                  bgColor: Colors.white,
                  loading: loading,
                  text: "Save Mood",
                  addIconBG: false,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  showLoading() {
    if (loading) {
      loading = false;
    } else {
      loading = true;
    }
    setState(() {});
  }

  void updateMood(mood) async {
    showLoading();
    if (await AppActions().checkInternetConnection()) {
      sendToServer(mood);
    } else {
      showLoading();
      AppActions().showErrorToast(
        text: PublicVar.checkInternet,
        context: context,
      );
    }
  }

  void sendToServer(mood) async {
    Map data = {
      "mood": mood,
    };
    print(Urls.userSettings + "/${PublicVar.userId}");

    if (await Server().putAction(
        url: Urls.userSettings + "/${PublicVar.userId}",
        data: data,
        bloc: appBloc)) {
      await Server().loadDashboard(appBloc: appBloc, context: context);
      await Server().loadUser(appBloc: appBloc, context: context);
      AppActions().showSuccessToast(context: context, text: "Mood updated");
      showLoading();
      Navigator.pop(context);
    } else {
      showLoading();
      AppActions().showErrorToast(
        text: "${appBloc.errorMsg}",
        context: context,
      );
    }
  }
}
