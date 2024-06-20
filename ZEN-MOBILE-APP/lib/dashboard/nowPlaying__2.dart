import 'dart:async';
import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:mindcast/models/PublicVar.dart';
import 'package:mindcast/utils/app_actions.dart';
import 'package:mindcast/utils/next_page.dart';
import 'package:provider/provider.dart';

import '../bloc/app_bloc.dart';
import '../bloc/server.dart';
import '../modals/createContentForm.dart';
import '../models/urls.dart';
import '../widgets/global_widgets.dart';
import 'player/PlayingControls.dart';
import 'player/PositionSeekWidget.dart';
import 'viewhostProfile.dart';

class NowPlaying__2 extends StatefulWidget {
  final baseKey, resourceData, userData;

  const NowPlaying__2(
      {Key? key, this.baseKey, this.resourceData, this.userData})
      : super(key: key);

  @override
  State<NowPlaying__2> createState() => _ResourcesState();
}

class _ResourcesState extends State<NowPlaying__2>
    with SingleTickerProviderStateMixin<NowPlaying__2> {
  late AppBloc appBloc;
  bool firstTime = false, saved = false, isHost = false, canPlay = false;

  ScrollController? _scrollController;
  // final GlobalKey<ScaffoldState> indexKey = GlobalKey();
  @override
  void initState() {
    _scrollController = ScrollController();
    // _scrollController!.addListener(listenToScrollChange);
    Timer.periodic(new Duration(microseconds: 1), (_) async {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    if (!firstTime) {
      if (widget.resourceData["userID"] == PublicVar.userId) {
        isHost = true;
      }
      openPlayer();
      firstTime = true;
    }
    return Scaffold(
        backgroundColor: Colors.white.withOpacity(0.9),
        appBar: AppBar(
          toolbarHeight: 400,
          leadingWidth: double.infinity,
          automaticallyImplyLeading: false,
          leading: Stack(
            children: [
              Stack(
                children: [
                  Image.network(
                    "${widget.resourceData["image"]}",
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                  ),
                  Positioned.fill(
                    child: Center(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10.0,
                          sigmaY: 10.0,
                        ),
                        child: Container(
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Icons.expand_more_rounded,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Now playing",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700),
                          ),
                          appBloc.userDetails["isHost"] == true
                              ? InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) {
                                          return CreateContentForm(
                                              update: true,
                                              data: widget.resourceData);
                                        });
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                )
                              : SizedBox()
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.0),
                      child: Container(
                        height: 270,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            "${widget.resourceData["image"]}",
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "${widget.resourceData["title"]}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${widget.resourceData["description"]}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                    future: loadUserData(widget.resourceData["userID"]),
                    builder: (context, snap) {
                      if (snap.hasData) {
                        return ListTile(
                          onTap: () {
                            NextPage().nextRoute(context,
                                ViewHostProfile(hostDetails: snap.data));
                          },
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              "${snap.data!["image"]}",
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                          title: Text(
                            "${snap.data!["username"]}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Author",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Icon(Icons.chevron_right),
                        );
                      }
                      return SizedBox();
                    }),
                canPlay
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20),
                        child: Column(
                          children: [
                            PlayerBuilder.currentPosition(
                                player: appBloc.assetsAudioPlayer,
                                builder: (context, duration) {
                                  //_assetsAudioPlayer.isPlaying
                                  return PositionSeekWidget(
                                    currentPosition: appBloc.assetsAudioPlayer
                                        .currentPosition.value,
                                    duration: appBloc.assetsAudioPlayer.current
                                        .value.audio.duration,
                                    seekTo: (to) {
                                      appBloc.assetsAudioPlayer.seek(to);
                                    },
                                  );
                                }),
                            SizedBox(
                              height: 20,
                            ),
                            appBloc.assetsAudioPlayer == null
                                ? SizedBox()
                                : PlayerBuilder.isPlaying(
                                    player: appBloc.assetsAudioPlayer,
                                    builder: (context, isPlaying) {
                                      return PlayingControls(
                                        isPlaying: isPlaying,
                                        saved: saved,
                                        isPlaylist: false,
                                        onStop: () {
                                          saveResource();
                                          //appBloc.assetsAudioPlayer.stop();
                                        },
                                        toggleLoop: () {
                                          appBloc.assetsAudioPlayer
                                              .toggleLoop();
                                        },
                                        onPlay: () {
                                          appBloc.assetsAudioPlayer
                                              .playOrPause();
                                        },
                                        onNext: () {
                                          //_assetsAudioPlayer.forward(Duration(seconds: 10));
                                          appBloc.assetsAudioPlayer.next(
                                              keepLoopMode:
                                                  true /*keepLoopMode: false*/);
                                        },
                                        onPrevious: () {
                                          appBloc.assetsAudioPlayer.previous(
                                              /*keepLoopMode: false*/);
                                        },
                                      );
                                    }),
                          ],
                        ),
                      )
                    : ShowPageLoading()
              ],
            ),
          ),
        ));
  }

  // TopView() {
  //   return Stack(
  //     children: <Widget>[
  //       CustomScrollView(
  //         controller: _scrollController,
  //         slivers: <Widget>[
  //           SliverAppBar(
  //             expandedHeight: 370,
  //             pinned: true,
  //             titleSpacing: 0.0,
  //             title: AnimatedOpacity(
  //               duration: Duration(milliseconds: 300),
  //               opacity: 1.0,
  //               curve: Curves.ease,
  //               child: Text(
  //                 "Now Playing",
  //                 style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //             leading: InkWell(
  //               onTap: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: const Icon(
  //                 Icons.expand_more_rounded,
  //                 size: 30,
  //               ),
  //             ),
  //             actions: [
  //               IconButton(
  //                 onPressed: () {
  //                   Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (builder) => const Settings()));
  //                 },
  //                 icon: const Icon(
  //                   Icons.settings,
  //                   color: Colors.white,
  //                 ),
  //               )
  //             ],
  //             elevation: 1.0,
  //             forceElevated: true,
  //             backgroundColor: Color(0xff1C1232),
  //             flexibleSpace: FlexibleSpaceBar(
  //               collapseMode: CollapseMode.parallax,
  //               background: Stack(
  //                 alignment: Alignment.bottomCenter,
  //                 children: <Widget>[
  //                   Stack(
  //                     children: [
  //                       Image.network(
  //                         "${widget.resourceData["image"]}",
  //                         fit: BoxFit.cover,
  //                         height: double.infinity,
  //                         width: double.infinity,
  //                         alignment: Alignment.center,
  //                       ),
  //                       Positioned.fill(
  //                         child: Center(
  //                           child: BackdropFilter(
  //                             filter: ImageFilter.blur(
  //                               sigmaX: 10.0,
  //                               sigmaY: 10.0,
  //                             ),
  //                             child: Container(
  //                               color: Colors.black.withOpacity(0.4),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Padding(
  //                     padding:
  //                         EdgeInsets.symmetric(horizontal: 18.0, vertical: 40),
  //                     child: Container(
  //                       height: 270,
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(20)),
  //                       child: ClipRRect(
  //                         borderRadius: BorderRadius.circular(20),
  //                         child: Image.network(
  //                           "${widget.resourceData["image"]}",
  //                           fit: BoxFit.cover,
  //                           alignment: Alignment.topCenter,
  //                         ),
  //                       ),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //           SliverToBoxAdapter(
  //             child: Container(
  //               constraints: BoxConstraints(minHeight: 400),
  //               child: Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 18.0),
  //                 child: Column(
  //                   children: [
  //                     SizedBox(
  //                       height: 20,
  //                     ),
  //                     Text(
  //                       "${widget.resourceData["title"]}",
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(
  //                           fontSize: 24, fontWeight: FontWeight.w700),
  //                     ),
  //                     Text(
  //                       "${widget.resourceData["description"]}",
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(
  //                           fontSize: 16, fontWeight: FontWeight.w500),
  //                     ),
  //                     SizedBox(
  //                       height: 20,
  //                     ),
  //                     FutureBuilder(
  //                         future: loadUserData(widget.resourceData["userID"]),
  //                         builder: (context, snap) {
  //                           if (snap.hasData) {
  //                             return ListTile(
  //                               onTap: () {
  //                                 NextPage().nextRoute(context,
  //                                     ViewHostProfile(hostDetails: snap.data));
  //                               },
  //                               leading: ClipRRect(
  //                                 borderRadius: BorderRadius.circular(100),
  //                                 child: Image.network(
  //                                   "${snap.data!["image"]}",
  //                                   width: 50,
  //                                   height: 50,
  //                                   fit: BoxFit.cover,
  //                                   alignment: Alignment.topCenter,
  //                                 ),
  //                               ),
  //                               title: Text(
  //                                 "${snap.data!["username"]}",
  //                                 style: TextStyle(
  //                                     color: Colors.black,
  //                                     fontSize: 18,
  //                                     fontWeight: FontWeight.bold),
  //                               ),
  //                               subtitle: Text(
  //                                 "Author",
  //                                 style: TextStyle(
  //                                   color: Colors.black54,
  //                                   fontSize: 14,
  //                                   fontWeight: FontWeight.w500,
  //                                 ),
  //                               ),
  //                               trailing: Icon(Icons.chevron_right),
  //                             );
  //                           }
  //                           return SizedBox();
  //                         }),
  //                     canPlay
  //                         ? Padding(
  //                             padding: const EdgeInsets.symmetric(
  //                                 horizontal: 20.0, vertical: 20),
  //                             child: Column(
  //                               children: [
  //                                 PlayerBuilder.currentPosition(
  //                                     player: appBloc.assetsAudioPlayer,
  //                                     builder: (context, duration) {
  //                                       //_assetsAudioPlayer.isPlaying
  //                                       return PositionSeekWidget(
  //                                         currentPosition: appBloc
  //                                             .assetsAudioPlayer
  //                                             .currentPosition
  //                                             .value,
  //                                         duration: appBloc.assetsAudioPlayer
  //                                             .current.value.audio.duration,
  //                                         seekTo: (to) {
  //                                           appBloc.assetsAudioPlayer.seek(to);
  //                                         },
  //                                       );
  //                                     }),
  //                                 SizedBox(
  //                                   height: 20,
  //                                 ),
  //                                 appBloc.assetsAudioPlayer == null
  //                                     ? SizedBox()
  //                                     : PlayerBuilder.isPlaying(
  //                                         player: appBloc.assetsAudioPlayer,
  //                                         builder: (context, isPlaying) {
  //                                           return PlayingControls(
  //                                             isPlaying: isPlaying,
  //                                             saved: saved,
  //                                             isPlaylist: false,
  //                                             onStop: () {
  //                                               saveResource();
  //                                               //appBloc.assetsAudioPlayer.stop();
  //                                             },
  //                                             toggleLoop: () {
  //                                               appBloc.assetsAudioPlayer
  //                                                   .toggleLoop();
  //                                             },
  //                                             onPlay: () {
  //                                               appBloc.assetsAudioPlayer
  //                                                   .playOrPause();
  //                                             },
  //                                             onNext: () {
  //                                               //_assetsAudioPlayer.forward(Duration(seconds: 10));
  //                                               appBloc.assetsAudioPlayer.next(
  //                                                   keepLoopMode:
  //                                                       true /*keepLoopMode: false*/);
  //                                             },
  //                                             onPrevious: () {
  //                                               appBloc.assetsAudioPlayer
  //                                                   .previous(
  //                                                       /*keepLoopMode: false*/);
  //                                             },
  //                                           );
  //                                         }),
  //                                 Column(
  //                                   children: <Widget>[
  //                                     // appBloc.assetsAudioPlayer
  //                                     //     .builderRealtimePlayingInfos(builder:
  //                                     //         (context, RealtimePlayingInfos? infos) {
  //                                     //   if (infos == null) {
  //                                     //     return SizedBox();
  //                                     //   }
  //                                     //   //print('infos: $infos');
  //                                     //   return Column(
  //                                     //     children: [
  //                                     //       PositionSeekWidget(
  //                                     //         currentPosition: infos.currentPosition,
  //                                     //         duration: infos.duration,
  //                                     //         seekTo: (to) {
  //                                     //           appBloc.assetsAudioPlayer.seek(to);
  //                                     //         },
  //                                     //       ),
  //                                     //       Row(
  //                                     //         mainAxisAlignment:
  //                                     //             MainAxisAlignment.center,
  //                                     //         children: [
  //                                     //           NeumorphicButton(
  //                                     //             onPressed: () {
  //                                     //               appBloc.assetsAudioPlayer.seekBy(
  //                                     //                   Duration(seconds: -10));
  //                                     //             },
  //                                     //             child: Text('-10'),
  //                                     //           ),
  //                                     //           SizedBox(
  //                                     //             width: 12,
  //                                     //           ),
  //                                     //           NeumorphicButton(
  //                                     //             onPressed: () {
  //                                     //               appBloc.assetsAudioPlayer.seekBy(
  //                                     //                   Duration(seconds: 10));
  //                                     //             },
  //                                     //             child: Text('+10'),
  //                                     //           ),
  //                                     //         ],
  //                                     //       )
  //                                     //     ],
  //                                     //   );
  //                                     // }),
  //                                   ],
  //                                 ),
  //                               ],
  //                             ),
  //                           )
  //                         : ShowPageLoading()
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           )
  //         ],
  //       ),
  //     ],
  //   );
  // }

  void openPlayer() async {
    // print("Player playing ${appBloc.assetsAudioPlayer.isPlaying.value} ${_assetsAudioPlayer.isPlaying.value}");
    print(PublicVar.assetsAudioPlayer.isPlaying.value);
    if (PublicVar.assetsAudioPlayer.isPlaying.value == false) {
      print("Has old player ooo");
      PublicVar.assetsAudioPlayer.stop();
      PublicVar.assetsAudioPlayer.dispose();
      PublicVar.assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
    }
    PublicVar.assetsAudioPlayer
        .open(
      showNotification: true,
      autoStart: false,
      Audio.network(
        "${widget.resourceData["resourceUrl"]}",
        cached: true,
      ),
    )
        .whenComplete(() {
      print("Locading is completed");
    }).then((value) {
      setState(() {
        appBloc.assetsAudioPlayer = PublicVar.assetsAudioPlayer;
        canPlay = true;
        print("Done loading oooo.........");
      });
    });

    // await appBloc.assetsAudioPlayer
    //     .open(
    //   showNotification: true,
    //   autoStart: false,
    //   Audio.network(
    //     "${widget.resourceData["resourceUrl"]}",
    //     cached: true,
    //   ),
    // )
    //     .then((value) {
    //   setState(() {
    //     canPlay = true;
    //     print("Done loading Globally oooo.........");
    //   });
    // });
  }

  Future<Map> loadUserData(userID) async {
    return await Server()
        .loadAData(appBloc: appBloc, url: "${Urls.aUser}/${userID}");
  }

  void saveResource() async {
    setState(() {
      saved = true;
    });
    Map data = {
      "resourceID": widget.resourceData["_id"],
      "userID": PublicVar.userId
    };
    if (await Server()
        .postAction(bloc: appBloc, data: data, url: Urls.saveBookmark)) {
      AppActions()
          .showSuccessToast(context: context, text: "Saved to Favorites");
      await Server().loadDashboard(appBloc: appBloc, context: context);
    }
  }
}
