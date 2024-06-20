import 'dart:io';

import 'package:app_framework/app_framework.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:mindcast/splash_screen/splash_screen1.dart';
import 'package:mindcast/utils/next_page.dart';
import 'package:provider/provider.dart';

import '../bloc/app_bloc.dart';
import '../bloc/server.dart';
import '../dashboard/base_page.dart';
import '../models/PublicVar.dart';
import '../models/urls.dart';
import '../utils/app_actions.dart';
import '../widgets/global_widgets.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  var acceptTerms = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String selectedValue = 'Please select';
  late bool loading = false, firstTime = false;
  var cloudinary = CloudinaryPublic('da1mxvbx2', 'ml_default', cache: false);
  var imageUrl = "", audioUrl = "", duration;
  var username = TextEditingController();
  var myBioTxt = TextEditingController();
  var experience = TextEditingController();
  late AppBloc appBloc;
  late File? videoFile, videoThumb, bannerFile = null;
  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    if (!firstTime) {
      username.text = appBloc.userDetails['username'] ?? "";
      myBioTxt.text = appBloc.userDetails['userBio'] ?? "";
      experience.text = appBloc.userDetails['experience'] ?? "";
      imageUrl = appBloc.userDetails["image"] ?? "";
      firstTime = true;
    }
    return Container(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.withOpacity(0),
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.close,
            size: 25,
            color: Colors.black,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Text(
            "Update Profile",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w800, fontSize: 24),
          ),
        ),
        actions: [
          InkWell(
            onTap: () async {
              AppActions().showAppDialog(
                context,
                title: "Request Account Delete",
                descp:
                    "Are you sure you want to delete your account... If so it takes 1 Month for your request to be confirmed",
                okText: "Okay",
                cancleText: "Cancel",
                danger: true,
                okAction: () async {
                  PublicVar.accountApproved = false;
                  await SharedStore().removeData(key: 'accountApproved');
                  PublicVar.userId = "";
                  await SharedStore().removeData(
                    key: 'user_id',
                  );
                  NextPage().clearPages(context, SplashScreen1());
                },
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(7)),
              child: Text(
                "Delete",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "These are the information's your subscribers are seeing, make sure its catchy ",
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Center(
                  child: InkWell(
                    onTap: () => pickImages(),
                    child: Container(
                      alignment: Alignment.center,
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green,
                          image: DecorationImage(
                              image: bannerImageView(), fit: BoxFit.cover)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "User Name",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: username,
                        validator: Validation().text,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "My Bio",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: myBioTxt,
                        minLines: 2,
                        maxLines: 20,
                        validator: Validation().text,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Your experiences",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: experience,
                        minLines: 2,
                        maxLines: 20,
                        validator: Validation().text,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                child: ButtonWidget(
                  onPress: () {
                    if (!loading) {
                      validateFields();
                    }
                  },
                  width: double.infinity,
                  height: 50.0,
                  txColor: Colors.white,
                  bgColor: Color(PublicVar.primaryColor),
                  loading: loading,
                  text: "Continue",
                  addIconBG: false,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  showLoading() {
    if (loading) {
      loading = false;
    } else {
      loading = true;
    }
    setState(() {});
  }

  validateFields() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      showLoading();
      if (await AppActions().checkInternetConnection()) {
        sendToServer();
      } else {
        showLoading();
        AppActions().showErrorToast(
          text: PublicVar.checkInternet,
          context: context,
        );
      }
    }
  }

  sendToServer() async {
    Map data = {
      "userID": PublicVar.userId,
      "username": username.text,
      "experience": experience.text,
      "myBioTxt": myBioTxt.text,
    };
    if (bannerFile != null) {
      var url = await uploadImageFile();
      print(url);
      data.addAll({"image": url});
    }
    setState(() {});
    if (await Server().putAction(
        url: Urls.userSettings + "/${PublicVar.userId}",
        data: data,
        bloc: appBloc)) {
      var res = appBloc.mapSuccess;
      print(res);
      await Server().loadDashboard(appBloc: appBloc, context: context);
      showLoading();
      AppActions().showAppDialog(context,
          title: 'Profile Update',
          descp: 'Your update was successful',
          okText: 'Okay',
          singlAction: true, okAction: () {
        Server().loadDashboard(appBloc: appBloc, context: context);
        setState(() {});
        NextPage().nextRoute(context, BasePage());
      });
    } else {
      showLoading();
      AppActions().showErrorToast(
        text: "${appBloc.errorMsg}",
        context: context,
      );
    }
  }

  pickImages() async {
    try {
      var path = await MediaPicker().selectOneImage(crop: true);
      if (path != null) {
        setState(() {
          bannerFile = File(path);
        });
      }
    } catch (e) {
      AppActions().showErrorToast(
        text: '${e.toString()}',
        context: context,
      );
    }
  }

  bannerImageView() {
    return bannerFile == null
        ? imageUrl == null
            ? AssetImage(PublicVar.defaultAppImage)
            : NetworkImage(
                imageUrl,
              )
        : FileImage(bannerFile!);
  }

  uploadImageFile() async {
    final res = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(
        bannerFile!.path,
        publicId: "mindcast" + DateTime.now().toIso8601String(),
        folder: 'mindcast-folder',
        context: {
          'alt': 'mindcast' + new DateTime.now().toIso8601String(),
          'caption': 'cast folder',
        },
      ),
    );
    return res.secureUrl;
  }
}
