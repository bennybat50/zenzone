import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mindcast/bloc/server.dart';
import 'package:mindcast/modals/showpaymentwidget.dart';
import 'package:mindcast/models/PublicVar.dart';
import 'package:mindcast/models/urls.dart';
import 'package:mindcast/utils/app_actions.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseApi {
  static Future init() async {
    await Purchases.setLogLevel(LogLevel.debug);

    late PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration =
          PurchasesConfiguration("${dotenv.env['ANDROIND_API_KEY']}")
            ..appUserID = null
            ..observerMode = false;
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration("${dotenv.env['IOS_API_KEY']}")
        ..appUserID = null
        ..observerMode = false;
    }
    await Purchases.configure(configuration);
  }

  static Future<List<Offering>> fetchOffers() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      return current == null ? [] : [current];
    } on PlatformException catch (e) {
      return [];
    }
  }

  static Future trailOffers(StoreProduct product) async {
    try {
      final offerings =
          await Purchases.getPromotionalOffer(product, product.discounts![0]);

      return offerings;
    } on PlatformException catch (e) {
      return null;
    }
  }

  static Future<bool> purchasePackage(StoreProduct package, appBloc) async {
    try {
      print("Processing payment.....");
      var data = await Purchases.purchaseProduct(package.identifier);
      print("Payment response $data");
      var endDate = "";
      if (package.identifier == "submindcasts_999_1m") {
        var currentDate = DateTime.now();
        endDate =
            "${currentDate.year}-${currentDate.month + 1}-${currentDate.day}";
      } else if (package.identifier == "submindcast_3797_1y") {
        var currentDate = DateTime.now();
        endDate =
            "${currentDate.year + 1}-${currentDate.month}-${currentDate.day}";
      }
      var updateData = {
        "status": "paid",
        "subscription_product": package.identifier,
        "subscription_end_date": endDate
      };
      await Server().putAction(
          bloc: appBloc,
          url: Urls.userSettings + "/${PublicVar.userId}",
          data: updateData);
      await Server().loadDashboard(appBloc: appBloc);
      print(data);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void showPackages(context, appBloc) async {
    final offering = await PurchaseApi.fetchOffers();
    if (offering.isEmpty) {
      AppActions().showAppToast(context: context, text: "No plans found");
    } else {
      final packages = offering
          .map((offer) => offer.availablePackages)
          .expand((pair) => pair)
          .toList();

      showModalBottomSheet(
          backgroundColor: Colors.white,
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return ShowPaymentWidget(
              onClickedPackage: (package) async {
                await PurchaseApi.purchasePackage(package, appBloc);
                Navigator.pop(context);
              },
              packages: packages,
            );
          });
    }
  }
}
