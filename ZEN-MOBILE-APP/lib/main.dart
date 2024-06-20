import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mindcast/bloc/purchase_api.dart';
import 'package:mindcast/firebase_api.dart';
import 'package:mindcast/firebase_options.dart';
import 'package:mindcast/splash_screen/splash_screen1.dart';
import 'package:provider/provider.dart';

import 'bloc/app_bloc.dart';
import 'dashboard/player2/services/service_locator.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();

  await setupServiceLocator();
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    return true;
  });
  await PurchaseApi.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications(false);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppBloc>.value(value: AppBloc()),
      ],
      child: MaterialApp(
        title: 'Zenzone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: const SplashScreen1(),
      ),
    );
  }
}
