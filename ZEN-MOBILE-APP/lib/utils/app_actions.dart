import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class AppActions {
  showSuccessToast({String? text, BuildContext? context}) {
    showAppToast(context: context, color: Colors.black, text: text);
  }

  showErrorToast({String? text, BuildContext? context}) {
    showAppToast(context: context, color: Colors.redAccent, text: text);
  }

  showLoadingToast({String? text, BuildContext? context}) {
    showAppToast(context: context, color: Colors.black, text: text);
  }

  showAppToast({color, String? text, BuildContext? context}) {
    try {
      showToast(text,
          context: context,
          axis: Axis.horizontal,
          alignment: Alignment.center,
          position: StyledToastPosition.bottom,
          backgroundColor: color,
          toastHorizontalMargin: 20,
          duration: Duration(seconds: 5),
          curve: Curves.bounceInOut,
          reverseCurve: Curves.easeInOutCubic);
    } catch (e) {}
  }

  Future<bool> checkInternetConnection() async {
    bool internet = false;
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(Duration(seconds: 10));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        internet = true;
      }
    } on SocketException catch (e) {
      internet = false;
    }
    return internet;
  }

  convertDate({data}) {
    var date = DateTime.fromMillisecondsSinceEpoch(data);
    var month, day;
    if (date.month < 10) {
      month = "0${date.month}";
    } else {
      month = date.month;
    }

    if (date.day < 10) {
      day = "0${date.day}";
    } else {
      day = date.day;
    }
    print("${date.year}-$month-$day");
    return "${date.year}-$month-$day";
  }

  showAppDialog(context,
      {okAction,
      cancleAction,
      editAction,
      String? title,
      descp,
      cancleText,
      okText,
      bool? singlAction,
      danger,
      normal,
      topClose,
      topEdit,
      Widget? child}) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceFont = deviceHeight * 0.01;
    if (singlAction == null) {
      singlAction = false;
    }
    if (danger == null) {
      danger = false;
    }
    if (normal == null) {
      normal = false;
    }
    if (topClose == null) {
      topClose = false;
    }
    if (topEdit == null) {
      topEdit = false;
    }
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 50,
                    height: MediaQuery.of(context).size.height * 0.70,
                    child: Center(
                        child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 38.0),
                      child: Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(20)),
                        child: SingleChildScrollView(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    topClose
                                        ? InkWell(
                                            onTap: () => Navigator.pop(context),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                                child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.black,
                                                    child: Icon(Icons.close,
                                                        size: 15,
                                                        color: Colors.white)),
                                              ),
                                            ))
                                        : SizedBox(),
                                    Expanded(
                                        child: Text(title ?? "",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 2.2 * deviceFont,
                                                fontWeight: FontWeight.bold))),
                                    topEdit
                                        ? InkWell(
                                            onTap: editAction,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(Icons.edit,
                                                  size: 20,
                                                  color: Colors.black),
                                            ))
                                        : SizedBox()
                                  ],
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.01,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: deviceWidth * 0.03),
                                  child: Text(
                                    "${descp ?? ""}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black87.withOpacity(0.8)),
                                  ),
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.01,
                                ),
                                child == null ? SizedBox() : child,
                                Divider(),
                                singlAction == true
                                    ? TextButton(
                                        onPressed: okAction ??
                                            () => Navigator.pop(context),
                                        child: Text(
                                          okText ?? "",
                                          style: TextStyle(
                                              color: danger
                                                  ? Colors.redAccent
                                                  : Colors.black,
                                              fontSize: 2.2 * deviceFont,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          TextButton(
                                            onPressed: cancleAction ??
                                                () => Navigator.pop(context),
                                            child: Text(
                                              cancleText ?? "",
                                              style: TextStyle(
                                                  color: danger
                                                      ? Colors.black
                                                      : normal
                                                          ? Colors.black
                                                          : Colors.redAccent,
                                                  fontSize: 2.2 * deviceFont,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: okAction ??
                                                () => Navigator.pop(context),
                                            child: Text(
                                              okText ?? "",
                                              style: TextStyle(
                                                  color: danger
                                                      ? Colors.redAccent
                                                      : Colors.black,
                                                  fontSize: 2.2 * deviceFont,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ],
                                      )
                              ]),
                        ),
                      ),
                    )),
                  ),
                ),
              );
            },
          );
        });
  }
}
