import 'package:flutter/material.dart';
import 'package:mindcast/utils/app_actions.dart';
import 'package:provider/provider.dart';

import '../bloc/app_bloc.dart';
import '../bloc/server.dart';
import '../models/PublicVar.dart';
import '../models/urls.dart';
import '../settings/settings.dart';
import '../widgets/global_widgets.dart';
import 'nowPlaying.dart';
import 'player2/page_manager.dart';
import 'player2/services/service_locator.dart';

class Downloads extends StatefulWidget {
  final baseKey;
  const Downloads({Key? key, this.baseKey}) : super(key: key);

  @override
  State<Downloads> createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  var viewing = "podcast";
  var downloadsList = [
    {
      "thumbnail": "assets/images/night_whisper.jpg",
      "title": "The Night Whispers",
      "duration": 87,
      "playing": false
    },
    {
      "thumbnail": "assets/images/card0.jpg",
      "title": "The Business Project",
      "duration": 56,
      "playing": false
    },
    {
      "thumbnail": "assets/images/card1.jpg",
      "title": "Living Color",
      "duration": 40,
      "playing": false
    },
    {
      "thumbnail": "assets/images/sports.jpg",
      "title": "The Sportscaster",
      "duration": 120,
      "playing": false
    },
  ];
  late AppBloc appBloc;
  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    final pageManager = getIt<PageManager>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "Saved Content",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 24),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (builder) => const Settings()));
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: [
                // Row(
                //   children: [
                //     InkWell(
                //       onTap: () {
                //         setState(() {
                //           viewing = "files";
                //         });
                //       },
                //       child: Container(
                //         width: 100,
                //         padding: EdgeInsets.all(10),
                //         decoration: BoxDecoration(
                //             color: viewing == "files" ? Colors.green : null,
                //             borderRadius: BorderRadius.circular(7)),
                //         child: Text(
                //           "Files",
                //           textAlign: TextAlign.center,
                //           style: TextStyle(
                //               fontSize: 18,
                //               color: viewing == "files"
                //                   ? Colors.white
                //                   : Colors.black),
                //         ),
                //       ),
                //     ),
                //     InkWell(
                //       onTap: () {
                //         setState(() {
                //           viewing = "podcast";
                //         });
                //       },
                //       child: Container(
                //         width: 100,
                //         padding: EdgeInsets.all(10),
                //         decoration: BoxDecoration(
                //             color: viewing == "podcast" ? Colors.green : null,
                //             borderRadius: BorderRadius.circular(7)),
                //         child: Text("Podcast",
                //             textAlign: TextAlign.center,
                //             style: TextStyle(
                //                 fontSize: 18,
                //                 color: viewing == "podcast"
                //                     ? Colors.white
                //                     : Colors.black)),
                //       ),
                //     )
                //   ],
                // ),
                // SizedBox(
                //   height: 10,
                // ),
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
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
                                          resourceData:
                                              appBloc.selectedResourceData,
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
                checkHomeData()
              ],
            ),
          ),
          SizedBox(
            height: 300,
          )
        ],
      ),
    );
  }

  checkHomeData() {
    if (!appBloc.hasDashboard) {
      return FutureBuilder(
        builder: (ctx, snap) {
          if (snap.data == false) {
            return noNetwork();
          }

          if (snap.connectionState == ConnectionState.waiting ||
              snap.connectionState == ConnectionState.active) {
            return ShowPageLoading();
          }
          return SavedViews();
        },
        future: loadDashboard(),
      );
    } else {
      return SavedViews();
    }
  }

  SavedViews() {
    if (appBloc.userDashboard["userBookmarks"] == null) {
      return SizedBox();
    }
    return ListView.builder(
      itemCount: appBloc.userDashboard["userBookmarks"].length,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) {
        return InkWell(
          onLongPress: () {
            deleteSaved(appBloc.userDashboard["userBookmarks"][index], index);
          },
          onTap: () {
            showModalBottomSheet(
                backgroundColor: Colors.white,
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return NowPlaying(
                    canPlay: true,
                    resourceData: appBloc.userDashboard["userBookmarks"][index]
                        ["resource"],
                  );
                });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Container(
                    width: 70,
                    height: 70,
                    color: Colors.green,
                    child: Image.network(
                      appBloc.userDashboard["userBookmarks"][index]["resource"]
                          ["image"] as String,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 25,
                        child: Text(
                          appBloc.userDashboard["userBookmarks"][index]
                              ["resource"]["title"] as String,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                      Text(
                          "${appBloc.userDashboard["userBookmarks"][index]["resource"]["duration"]}"),
                    ],
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(100)),
                  child: Icon(
                    Icons.arrow_right,
                    size: 35,
                  ),
                )
                // InkWell(
                //   onTap: () {
                //     //play or pause
                //
                //     if (appBloc.userDashboard["userBookmarks"][index]
                //             ["playing"] ==
                //         true) {
                //       setState(() {
                //         appBloc.userDashboard["userBookmarks"][index]
                //             ['playing'] = false;
                //       });
                //     } else {
                //       updatePlayingStatus(index);
                //     }
                //   },
                //   child: Container(
                //     width: 50,
                //     height: 50,
                //     decoration: BoxDecoration(
                //         color: Colors.grey.shade200,
                //         borderRadius: BorderRadius.circular(100)),
                //     child: Icon(
                //       appBloc.userDashboard["userBookmarks"][index]
                //                   ["playing"] ==
                //               true
                //           ? Icons.pause
                //           : Icons.play_arrow_outlined,
                //       size: 35,
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        );
      },
    );
  }

  void updatePlayingStatus(int index) {
    for (int i = 0; i < appBloc.userDashboard["userBookmarks"].length; i++) {
      if (i == index) {
        setState(() {
          appBloc.userDashboard["userBookmarks"][i]['playing'] = true;
        });
      } else {
        setState(() {
          appBloc.userDashboard["userBookmarks"][i]['playing'] = false;
        });
      }
    }
  }

  String formatDuration(int minutes) {
    int hours = minutes ~/ 60;
    int remainingMinutes = minutes % 60;

    String formattedDuration = '';

    if (hours > 0 && hours < 2) {
      formattedDuration = '$hours hour';
    } else if (hours > 0 && hours >= 2) {
      formattedDuration = '$hours hours';
    }

    if (remainingMinutes > 0) {
      if (formattedDuration.isNotEmpty) {
        formattedDuration += ' ';
      }
      formattedDuration += '$remainingMinutes minutes';
    }

    return formattedDuration;
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

  void deleteSaved(savedItem, index) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Text(
                  "Remove Item",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  "Are you sure you want to remove this item from your list",
                  style: TextStyle(fontSize: 15),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.0),
                  child: ButtonWidget(
                    onPress: () {
                      Navigator.pop(context);
                      deleteItem(savedItem["_id"]);
                    },
                    width: double.infinity,
                    height: 50.0,
                    txColor: Colors.white,
                    bgColor: Color(PublicVar.primaryColor),
                    loading: false,
                    text: "Remove Item",
                    addIconBG: false,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"))
              ],
            ),
          );
        });
  }

  deleteItem(itemId) async {
    Map data = {"id": itemId};
    if (await Server().deleteAction(
        appBloc: appBloc, url: Urls.deleteBookmarks, data: data)) {
      AppActions().showSuccessToast(context: context, text: "Item removed");
    }
  }
}
