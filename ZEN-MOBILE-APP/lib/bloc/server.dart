import 'dart:convert';

import 'package:app_framework/app_framework.dart';
import 'package:http/http.dart' as http;

import '../models/PublicVar.dart';
import '../models/error_messages.dart';
import '../models/urls.dart';
import 'app_bloc.dart';

class Server {
  PubRequest _request = PubRequest();

  loadDashboard({AppBloc? appBloc, context}) async {
    await loadUser(appBloc: appBloc, context: context);
    var hasResult = false;
    print("${Urls.dashboard}/${PublicVar.userId}");
    if (await Server().getAction(
        url: "${Urls.dashboard}/${PublicVar.userId}", appBloc: appBloc)) {
      var res = appBloc!.mapSuccess;

      loadInterest(appBloc: appBloc, context: context);
      loadResources(appBloc: appBloc, context: context);
      loadPopularResources(appBloc: appBloc, context: context);

      appBloc.userDashboard = res;
      appBloc.hasDashboard = true;
      appBloc.selectedHomeInterestIndex = 0;
      appBloc.selectedHomeInterest =
          appBloc.userDashboard["userInterest"][0]["interestedResources"];
      appBloc.selectedHomeInterestId =
          '${res["userInterest"][0]["interest"]["_id"]}';

      hasResult = true;
    } else {
      print(appBloc!.errorMsg);
    }
    return hasResult;
  }

  loadUserDashboard({AppBloc? appBloc, context}) async {
    await loadUser(appBloc: appBloc, context: context);
    var hasResult = false;
    print("${Urls.dashboard}/${PublicVar.userId}");
    if (await Server().getAction(
        url: "${Urls.dashboard}/${PublicVar.userId}", appBloc: appBloc)) {
      var res = appBloc!.mapSuccess;

      appBloc.userDashboard = res;
      appBloc.hasDashboard = true;
      appBloc.selectedHomeInterestIndex = 0;
      appBloc.selectedHomeInterest =
          appBloc.userDashboard["userInterest"][0]["interestedResources"];
      appBloc.selectedHomeInterestId =
          '${res["userInterest"][0]["interest"]["_id"]}';

      hasResult = true;
    } else {
      print(appBloc!.errorMsg);
    }
    return hasResult;
  }

  loadHost({AppBloc? appBloc, context}) async {
    var hasResult = false;
    if (await Server().getAction(
        url: "${Urls.hostProfile}/${PublicVar.userId}", appBloc: appBloc)) {
      var res = appBloc!.mapSuccess;

      appBloc.hostDashboard = res;
      appBloc.hasHostData = true;
      appBloc.selectedHostInterestIndex = 0;
      appBloc.selectedHostInterest =
          appBloc.hostDashboard["hostedResources"][0]["interestedResources"];
      appBloc.selectedHostInterestId =
          '${res["hostedResources"][0]["interest"]["_id"]}';

      if (!PublicVar.onProduction) print(appBloc.selectedHostInterestId);
      hasResult = true;
    } else {
      print(appBloc!.errorMsg);
    }
    return hasResult;
  }

  checkIfBookMarked({AppBloc? appBloc, resourceID}) {
    var hasData = false;
    if (appBloc!.userDashboard["userBookmarks"] != null) {
      for (var i = 0; i < appBloc!.userDashboard["userBookmarks"].length; i++) {
        if (appBloc!.userDashboard["userBookmarks"][i]["resource"]["_id"] ==
            resourceID) {
          hasData = true;
        }
      }
    }
    return hasData;
  }

  loadAHostProfile({AppBloc? appBloc, context, userId}) async {
    var hasResult = false;

    if (await Server()
        .getAction(url: "${Urls.hostProfile}/$userId", appBloc: appBloc)) {
      var res = appBloc!.mapSuccess;

      appBloc.hostDashboard = res;
      appBloc.hasAHostData = true;
      appBloc.selectedHostInterestIndex = 0;
      appBloc.selectedHostInterest =
          appBloc.hostDashboard["hostedResources"][0]["interestedResources"];
      appBloc.selectedHostInterestId =
          '${res["hostedResources"][0]["interest"]["_id"]}';

      if (!PublicVar.onProduction) print(appBloc.selectedHostInterestId);
      hasResult = true;
    } else {
      print(appBloc!.errorMsg);
    }
    return hasResult;
  }

  loadInterest({AppBloc? appBloc, context}) async {
    var hasResult = false;
    if (await Server()
        .getAction(url: "${Urls.getInterest}", appBloc: appBloc)) {
      var res = appBloc!.mapSuccess;
      for (var i = 0; i < res.length; i++) {
        res[i]["selected"] = false;
      }
      appBloc.interests = res;
      hasResult = true;
    } else {}
    return hasResult;
  }

  loadResources({AppBloc? appBloc, context}) async {
    var hasResult = false;
    print("${Urls.getResourcesInterest}");
    if (await Server()
        .getAction(url: "${Urls.getResourcesInterest}", appBloc: appBloc)) {
      var res = appBloc!.mapSuccess;
      // for (var i = 0; i < res.length; i++) {
      //   res[i]["selected"] = false;
      // }
      appBloc.resources = res;
      appBloc.selectedInterestResourceIndex = 0;
      appBloc.selectedInterestResource = res[0];
      appBloc.selectedInterestId = '${res[0]["interest"]["_id"]}';
      appBloc.hasResources = true;
      hasResult = true;
    } else {
      print(appBloc!.errorMsg);
    }
    return hasResult;
  }

  loadPopularResources({AppBloc? appBloc, context}) async {
    var hasResult = false;

    if (await Server()
        .getAction(url: "${Urls.getResourcesPopular}", appBloc: appBloc)) {
      var res = appBloc!.mapSuccess;
      appBloc.popularResources = res;
      appBloc.hasPopular = true;
      hasResult = true;
    } else {
      print(appBloc!.errorMsg);
    }
    return hasResult;
  }

  loadUser({AppBloc? appBloc, context}) async {
    var hasResult = false;

    if (await Server().getAction(
        url: "${Urls.aUser}/${PublicVar.userId}", appBloc: appBloc)) {
      var res = appBloc!.mapSuccess;
      appBloc.userDetails = res;
      appBloc.userDetails = appBloc.userDetails;
      hasResult = true;
    } else {
      print(appBloc!.errorMsg);
    }
    return hasResult;
  }

  loadAData({AppBloc? appBloc, url}) async {
    var data =
        await _request.getRoute("${url}"!).timeout(Duration(seconds: 15));

    return data["data"];
  }

  Future<bool> postAction({AppBloc? bloc, String? url, var data}) async {
    bool sent = false;
    try {
      await _request.post(url!, data, (res) {
        if (!PublicVar.onProduction) print(res);
        if (res["status"] == false) {
          bloc!.errorMsg = res["message"];
          sent = false;
        } else {
          bloc!.mapSuccess = res["data"];
          sent = true;
        }
      }).timeout(Duration(seconds: 15));
    } catch (e) {
      if (!PublicVar.onProduction)
        print('===========>>Post error ${e.toString()} url$url');
      bloc!.errorMsg = PublicVar.serverError;
      sent = false;
    }
    return sent;
  }

  Future<bool> putAction({AppBloc? bloc, String? url, var data}) async {
    bool sent = false;
    try {
      await _request.put(url!, data, (res) {
        if (!PublicVar.onProduction) print(res);
        if (res["status"] == false) {
          sent = false;
          bloc!.errorMsg = res["message"];
        } else {
          bloc!.mapSuccess = res["data"];
          sent = true;
        }
      }).timeout(Duration(seconds: 15));
    } catch (e) {
      if (!PublicVar.onProduction)
        print('=========>>Put error ${e.toString()}');
      bloc!.errorMsg = PublicVar.serverError;
      sent = false;
    }

    return sent;
  }

  getDataType(data) {
    var has = false;
    if (data.runtimeType.toString() ==
        "_InternalLinkedHashMap<String, dynamic>") {
      has = true;
    }
    return has;
  }

  Future<bool> getAction({AppBloc? appBloc, String? url}) async {
    bool sent = false;
    try {
      var data = await _request.getRoute(url!).timeout(Duration(seconds: 15));

      if (data["status"] == false) {
        sent = false;
        appBloc!.errorMsg = data["message"];
      } else {
        appBloc!.mapSuccess = data["data"];
        sent = true;
      }
    } catch (e) {
      if (!PublicVar.onProduction) print('get error ${e.toString()}');
      appBloc!.errorMsg = PublicVar.serverError;
      sent = false;
    }
    return sent;
  }

  uploadImg<bool>({AppBloc? appBloc, url, required Map data}) async {
    bool sent = false as bool;
    try {
      List fields = data.keys.toList();
      List files = data.values.toList();
      var request = http.MultipartRequest("POST", Uri.parse(url));
      for (var i = 0; i < fields.length; i++) {
        if (fields[i] == "image" || fields[i] == "kyc") {
          var pic = await http.MultipartFile.fromPath(
            fields[i],
            files[i].path,
          );
          request.files.add(pic);
        } else {
          request.fields.addAll({fields[i]: files[i]});
        }
      }

      var response = await request.send();
      var responseData =
          await response.stream.toBytes().timeout(Duration(seconds: 30));
      var responseString = String.fromCharCodes(responseData);
      var res = jsonDecode(responseString);
      if (getDataType(res) && ErrorMessages().getStatus(status: res["type"])) {
        sent = false as bool;
        appBloc!.errorMsg = res["msg"];
      } else {
        appBloc!.mapSuccess = res;
        sent = true as bool;
      }
      if (!PublicVar.onProduction) print(responseString);
      return sent;
    } catch (e) {
      appBloc!.errorMsg = e.toString();
      if (!PublicVar.onProduction) print('Upload error ${e.toString()}');
      return sent;
    }
  }

  Future<bool> deleteAction({AppBloc? appBloc, var url, var data}) async {
    bool sent = false;
    try {
      await _request.delete(url, data, (res) {
        if (!PublicVar.onProduction) print(res);
        if (res["status"] == false) {
          sent = false;
          appBloc!.errorMsg = res["message"];
        } else {
          appBloc!.mapSuccess = res["data"];
          sent = true;
        }
      }).timeout(Duration(seconds: 15));
    } catch (e) {
      if (!PublicVar.onProduction)
        print('=========>>delete error ${e.toString()}');
      appBloc!.errorMsg = PublicVar.serverError;
      sent = false;
    }
    return sent;
  }
}
