import 'dart:async';
import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mindcast/models/PublicVar.dart';
import 'package:mindcast/utils/app_actions.dart';
import 'package:mindcast/utils/next_page.dart';
import 'package:mindcast/widgets/global_widgets.dart';
import 'package:provider/provider.dart';

import '../bloc/app_bloc.dart';
import '../bloc/server.dart';
import '../models/urls.dart';
import 'player2/notifiers/play_button_notifier.dart';
import 'player2/notifiers/progress_notifier.dart';
import 'player2/notifiers/repeat_button_notifier.dart';
import 'player2/page_manager.dart';
import 'player2/services/service_locator.dart';
import 'viewhostProfile.dart';

class NowPlaying extends StatefulWidget {
  final baseKey, resourceData, userData;
  final bool canPlay;

  const NowPlaying(
      {Key? key,
      this.baseKey,
      this.resourceData,
      this.userData,
      required this.canPlay})
      : super(key: key);

  @override
  State<NowPlaying> createState() => _ResourcesState();
}

class _ResourcesState extends State<NowPlaying>
    with SingleTickerProviderStateMixin<NowPlaying> {
  late AppBloc appBloc;
  bool firstTime = false, saved = false, isHost = false, canPlay = false;

  ScrollController? _scrollController;
  // final GlobalKey<ScaffoldState> indexKey = GlobalKey();
  @override
  void initState() {
    _scrollController = ScrollController();
    // _scrollController!.addListener(listenToScrollChange);
    checkLiked();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);

    Timer(const Duration(microseconds: 1), () {
      if (!firstTime) {
        appBloc.selectedResourceData = widget.resourceData;
        if (widget.resourceData["userID"] == PublicVar.userId) {
          isHost = true;
        }
        openPlayer();
        firstTime = true;
      }
    });

    return Scaffold(
        backgroundColor: Colors.white.withOpacity(0.9),
        body: Stack(
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
                        sigmaX: .2,
                        sigmaY: .2,
                      ),
                      child: Container(
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "${widget.resourceData["title"]}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    Text(
                      "${widget.resourceData["description"]}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FutureBuilder(
                        future: loadUserData(widget.resourceData["userID"]),
                        builder: (context, snap) {
                          if (snap.hasData) {
                            return InkWell(
                              onTap: () {
                                NextPage().nextRoute(context,
                                    ViewHostProfile(hostDetails: snap.data));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Author",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "${snap.data!["username"]}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            );
                          }
                          return SizedBox();
                        }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 30),
              child: ListView(
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Container(
                              width: 40,
                              height: 40,
                              color: Color(PublicVar.primaryColor),
                              child: const Icon(
                                Icons.expand_more_rounded,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
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

                        FutureBuilder(
                            future: loadUserData(widget.resourceData["userID"]),
                            builder: (context, snap) {
                              if (snap.hasData) {
                                return InkWell(
                                  onTap: () {
                                    NextPage().nextRoute(
                                        context,
                                        ViewHostProfile(
                                            hostDetails: snap.data));
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                      "${snap.data!["image"]}",
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
                                    ),
                                  ),
                                );
                              }
                              return SizedBox();
                            })
                        // appBloc.userDetails["isHost"] == true
                        //     ? InkWell(
                        //         onTap: () {
                        //           showModalBottomSheet(
                        //               backgroundColor: Colors.transparent,
                        //               isScrollControlled: true,
                        //               context: context,
                        //               builder: (context) {
                        //                 return CreateContentForm(
                        //                     update: true,
                        //                     data: widget.resourceData);
                        //               });
                        //         },
                        //         child: Icon(
                        //           Icons.edit,
                        //           color: Colors.white,
                        //         ),
                        //       )
                        //     : SizedBox()
                      ],
                    ),
                  ),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "Reviews",
                  //       style: TextStyle(
                  //           color: Colors.black,
                  //           fontWeight: FontWeight.w700,
                  //           fontSize: 22),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 350,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    AudioProgressBar(
                      textColor: Colors.white,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              saveResource();
                            },
                            icon: Icon(
                              saved ? Ionicons.heart : Ionicons.heart_outline,
                              size: 30,
                              color: saved ? Colors.red : Colors.white,
                            )),
                        AudioControlButtons(),
                        Row(
                          children: [
                            Icon(
                              Icons.headphones,
                              color: Colors.white,
                            ),
                            Text(
                              "${widget.resourceData["no_plays"] ?? ""}",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  void openPlayer() async {
    var musicData = {
      "title": widget.resourceData["title"],
      "url": widget.resourceData["resourceUrl"],
      "image": widget.resourceData["image"],
      "author": ""
    };
    if (widget.canPlay) {
      increaseCount();

      getIt<PageManager>().init(data: musicData);
    }
  }

  void checkLiked() async {
    Timer(const Duration(milliseconds: 1), () async {
      var data = await Server().loadAData(
          appBloc: appBloc,
          url:
              "${Urls.saveBookmark}/user/${PublicVar.userId}/${widget.resourceData["_id"]}");

      if (data != null) {
        setState(() {
          saved = true;
        });
      }
    });
  }

  @override
  void dispose() {
    //getIt<PageManager>().dispose();
    super.dispose();
  }

  Future<Map> loadUserData(userID) async {
    return await Server()
        .loadAData(appBloc: appBloc, url: "${Urls.aUser}/${userID}");
  }

  void increaseCount() async {
    await Server().loadAData(
        appBloc: appBloc,
        url: "${Urls.resource}/count/${widget.resourceData["_id"]}");
    await Server().loadDashboard(appBloc: appBloc, context: context);
    await Server().loadResources(appBloc: appBloc, context: context);
  }

  void saveResource() async {
    setState(() {
      if (saved) {
        saved = false;
      } else {
        saved = true;
      }
    });
    Map data = {
      "resourceID": widget.resourceData["_id"],
      "type": "resource",
      "userID": PublicVar.userId
    };
    if (await Server()
        .postAction(bloc: appBloc, data: data, url: Urls.saveBookmark)) {
      if (appBloc.mapSuccess["userID"] != null) {
        AppActions()
            .showSuccessToast(context: context, text: "Saved to Favorites");
      } else {
        AppActions()
            .showSuccessToast(context: context, text: "Removed from Favorites");
      }
      checkLiked();
      await Server().loadDashboard(appBloc: appBloc, context: context);
    }
  }
}

class AudioProgressBar extends StatelessWidget {
  final Color textColor;
  const AudioProgressBar({Key? key, required this.textColor}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: pageManager.progressNotifier,
      builder: (_, value, __) {
        return ProgressBar(
          timeLabelTextStyle: TextStyle(color: textColor),
          progress: value.current,
          buffered: value.buffered,
          total: value.total,
          baseBarColor: Colors.white,
          onSeek: pageManager.seek,
        );
      },
    );
  }
}

class CurrentSongTitle extends StatelessWidget {
  final Color textColor;
  const CurrentSongTitle({Key? key, required this.textColor}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<String>(
      valueListenable: pageManager.currentSongTitleNotifier,
      builder: (_, title, __) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(title, style: TextStyle(fontSize: 20, color: textColor)),
        );
      },
    );
  }
}

class GlobalAudioProgressBar extends StatelessWidget {
  const GlobalAudioProgressBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    final appBloc = Provider.of<AppBloc>(context);

    return ValueListenableBuilder<List<String>>(
      valueListenable: pageManager.playlistNotifier,
      builder: (context, playlistTitles, _) {
        if (playlistTitles.length > 0) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40,
                    child: CircleAvatar(
                        backgroundImage: NetworkImage(
                      appBloc.selectedResourceData?["image"] ??
                          PublicVar.defaultOnlineImage,
                    )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(appBloc.selectedResourceData["title"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                  IconButton(
                      onPressed: () {
                        getIt<PageManager>().remove();

                        //getIt<PageManager>().dispose();
                      },
                      icon: Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.white,
                      ))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: AudioProgressBar(
                    textColor: Colors.white,
                  )),
                  SinglePlayButton(
                    color: Colors.white,
                  ),
                ],
              )
            ],
          );
        }
        return SizedBox();
      },
    );
  }
}

class AudioControlButtons extends StatelessWidget {
  const AudioControlButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //RepeatButton(),
          //PreviousSongButton(),
          PlayButton(
            color: Colors.white,
          ),
          //NextSongButton(),
          //ShuffleButton(),
        ],
      ),
    );
  }
}

class RepeatButton extends StatelessWidget {
  const RepeatButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<RepeatState>(
      valueListenable: pageManager.repeatButtonNotifier,
      builder: (context, value, child) {
        Icon icon;
        switch (value) {
          case RepeatState.off:
            icon = const Icon(Icons.repeat, color: Colors.grey);
            break;
          case RepeatState.repeatSong:
            icon = const Icon(Icons.repeat_one);
            break;
          case RepeatState.repeatPlaylist:
            icon = const Icon(Icons.repeat);
            break;
        }
        return IconButton(
          icon: icon,
          onPressed: pageManager.repeat,
        );
      },
    );
  }
}

class PreviousSongButton extends StatelessWidget {
  const PreviousSongButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isFirstSongNotifier,
      builder: (_, isFirst, __) {
        return IconButton(
          icon: const Icon(Icons.skip_previous),
          onPressed: (isFirst) ? null : pageManager.previous,
        );
      },
    );
  }
}

class PlayButton extends StatelessWidget {
  final Color color;
  const PlayButton({Key? key, required this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();

    return ValueListenableBuilder<ButtonState>(
      valueListenable: pageManager.playButtonNotifier,
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return ButtonWidget(
              width: 60.0,
              height: 60.0,
              loading: true,
              radius: 100.0,
              bgColor: Color(PublicVar.primaryColor),
            );
          case ButtonState.paused:
            return ButtonWidget(
              onPress: pageManager.play,
              bgColor: Color(PublicVar.primaryColor),
              width: 60.0,
              height: 60.0,
              loading: false,
              icon: Icons.play_arrow,
              addIconBG: false,
              iconColor: color,
              iconSize: 32.0,
              radius: 100.0,
            );
          case ButtonState.playing:
            return ButtonWidget(
              onPress: pageManager.pause,
              bgColor: Color(PublicVar.primaryColor),
              width: 60.0,
              height: 60.0,
              loading: false,
              icon: Icons.pause,
              addIconBG: false,
              iconColor: color,
              iconSize: 32.0,
              radius: 100.0,
            );
        }
      },
    );
  }
}

class SinglePlayButton extends StatelessWidget {
  final Color color;
  const SinglePlayButton({Key? key, required this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<ButtonState>(
      valueListenable: pageManager.playButtonNotifier,
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return Container(
              margin: const EdgeInsets.all(8.0),
              width: 32.0,
              height: 32.0,
              child: const CircularProgressIndicator(),
            );
          case ButtonState.paused:
            return IconButton(
              icon: Icon(
                Icons.play_arrow,
                color: color,
              ),
              iconSize: 32.0,
              onPressed: pageManager.play,
            );
          case ButtonState.playing:
            return IconButton(
              icon: Icon(
                Icons.pause,
                color: color,
              ),
              iconSize: 32.0,
              onPressed: pageManager.pause,
            );
        }
      },
    );
  }
}

class NextSongButton extends StatelessWidget {
  const NextSongButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isLastSongNotifier,
      builder: (_, isLast, __) {
        return IconButton(
          icon: const Icon(Icons.skip_next),
          onPressed: (isLast) ? null : pageManager.next,
        );
      },
    );
  }
}

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isShuffleModeEnabledNotifier,
      builder: (context, isEnabled, child) {
        return IconButton(
          icon: (isEnabled)
              ? const Icon(Icons.shuffle)
              : const Icon(Icons.shuffle, color: Colors.grey),
          onPressed: pageManager.shuffle,
        );
      },
    );
  }
}
