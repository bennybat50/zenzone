import 'package:assets_audio_player/assets_audio_player.dart';

class PublicVar {
  static late int userPin, basePage = 0;

  static late AssetsAudioPlayer assetsAudioPlayer =
      AssetsAudioPlayer.newPlayer();

  static late bool hasLogin,
      onProduction = false,
      hasData = false,
      isVerified = false,
      isRegistred,
      isHost = false,
      enableNotification = false,
      isActive = false,
      accountApproved = false;

  //Defaults
  static int primaryColor = 0xFF40176C,
      primaryDark = 0xFF321254,
      primaryBg = 0xff1C1232,
      primaryLight = 0xFF7D2DD2,
      textPrimaryDark = 0xFF303E67,
      white = 0xFFFFFFFF,
      nameColor = 0xff333636,
      black = 0xFF000000,
      happy = 0xFFF8D664,
      sad = 0xFF121212,
      angry = 0xFFea3a3a;

  static String userEmail = "",
      userName = "",
      userPhone = "",
      userGender = "",
      userId = "",
      account_status = "",
      getToken = "",
      defaultLogo = "assets/images/logo.png",
      defaultAppImage = "assets/images/imageDefault.jpg",
      defaultOnlineImage =
          "https://images.unsplash.com/photo-1508717272800-9fff97da7e8f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=751&q=80",
      noImage = "No Moment's yet,\nShare a moment or Reload",
      selectVideo = "You have not selected a video ",
      noNotification = "No Notifications ",
      noComment = "No Comments yet,\nSend a Comments or Reload",
      noMessage = "No Messages yet,\nSend a message or Reload",
      checkInternet = "Please check your internet connection",
      serverError = 'something went wrong,\n please try again',
      wait = 'One moment please....',
      zeroValues = 'Please make sure all fields has a default value of zero',
      requestErrorString = "Something went wrong!!\n please try again";
}
