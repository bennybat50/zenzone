import 'dart:io';

import 'package:app_framework/app_framework.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc/app_bloc.dart';
import '../bloc/server.dart';
import '../models/PublicVar.dart';
import '../models/urls.dart';
import '../utils/app_actions.dart';
import '../widgets/global_widgets.dart';
import 'createContentSuccess.dart';

class CreateContentForm extends StatefulWidget {
  final bool update;
  final data;
  const CreateContentForm({Key? key, required this.update, this.data})
      : super(key: key);

  @override
  State<CreateContentForm> createState() => _CreateContentFormState();
}

class _CreateContentFormState extends State<CreateContentForm> {
  double downloadStatus = 0.81, _uploadingPercentage = 0.0;

  var acceptTerms = false,
      imageUrl = "",
      audioUrl = "",
      duration,
      interestId,
      resourceId;
  bool isUploading = false, loading = false, firstTime = false;
  List moods = ["Happy", "Sad", "Angry"];
  var selectedMood = "";
  var titleTxt = TextEditingController();
  var descpTxt = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var selectedValue;
  late File? videoFile, videoThumb, bannerFile = null;
  var cloudinary = CloudinaryPublic(
    'duxx9qnkl',
    'ml_default',
    cache: true,
  );
  late AppBloc appBloc;

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    if (!firstTime) {
      if (widget.update == true) {
        resourceId = widget.data["_id"];
        interestId = widget.data["interestID"];
        if (widget.data["moodType"] != null) {
          selectedMood = widget.data["moodType"];
        }
        titleTxt.text = widget.data["title"];
        descpTxt.text = widget.data["description"];
        imageUrl = widget.data["image"];
        audioUrl = widget.data["resourceUrl"];
        duration = widget.data["duration"];
      }
      firstTime = true;
    }

    return Scaffold(
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          physics: ScrollPhysics(),
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40))),
              child: ListView(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.update == true
                              ? "Update Content"
                              : "Create content",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 24),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              size: 30,
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Center(
                      child: InkWell(
                        onTap: () => chooseImageSource(name: 'banner'),
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
                            "Title",
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
                            controller: titleTxt,
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
                            "Description",
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
                            controller: descpTxt,
                            keyboardType: TextInputType.text,
                            minLines: 3,
                            maxLines: 20,
                            validator: Validation().text,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter description of the content",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Specific For What Mood?",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.white))),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (ctx, i) {
                          //return Text("Hello");
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Theme(
                              data: ThemeData(canvasColor: Colors.transparent),
                              child: FilterChip(
                                label: Text(moods[i]),
                                onSelected: (bool value) {
                                  setState(() {
                                    selectedMood = moods[i];
                                  });
                                },
                                showCheckmark: false,
                                tooltip: 'Select from list of stages',
                                selected: selectedMood.contains(moods[i]),
                                selectedColor: Color(PublicVar.primaryColor),
                                labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                                backgroundColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                              ),
                            ),
                          );
                        },
                        itemCount: moods.length,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return ViewInterest();
                              });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 18),
                          child: Text(
                            "${appBloc.selectedUploadInterest["name"] ?? "Select Category"}",
                            style: TextStyle(
                                fontWeight:
                                    appBloc.selectedUploadInterest["name"] ==
                                            null
                                        ? FontWeight.w400
                                        : FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: "Upload file ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18)),
                              TextSpan(
                                  text: "(audio mp3 format)",
                                  style: TextStyle(
                                    color: Colors.black,
                                  )),
                            ]))),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                          width: double.infinity,
                          constraints: BoxConstraints(
                            minHeight: 100,
                            maxHeight: 150,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _uploadingPercentage == 100
                              ? Center(
                                  child: Text(
                                  "Audio Uploaded",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ))
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          selectAudioFile();
                                        },
                                        child: const Icon(
                                          Icons.file_upload_outlined,
                                          size: 40,
                                        )),
                                    if (isUploading)
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Uploading file",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                Container(
                                                    // width: 30,
                                                    child: Text(
                                                  "${_uploadingPercentage.toStringAsFixed(2)}%",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700),
                                                )),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            child: LinearProgressIndicator(
                                              value: _uploadingPercentage,
                                              color: Colors.green,
                                              backgroundColor:
                                                  Colors.grey.withOpacity(0.2),
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (!isUploading)
                                      const Text(
                                        "Browse and choose the files you want to upload from your device",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                    child: ButtonWidget(
                      onPress: () {
                        if (!loading) {
                          checkFileSelected();
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
          ],
        ),
      ),
    );
  }

  chooseImageSource({required String name}) async {
    try {
      var imgFile;
      var img = await MediaPicker().selectFromPickers();
      if (img != null)
        imgFile = await CompressImage().compressAndGetFile(
            file: File(img), name: "upload_image", extention: ".jpg");
      bannerFile = File(imgFile.path);
      setState(() {});
    } catch (e) {
      AppActions().showErrorToast(
        text: '${e.toString()}',
        context: context,
      );
    }
  }

  showLoading() {
    if (loading) {
      loading = false;
    } else {
      loading = true;
    }
    setState(() {});
  }

  checkFileSelected() {
    if (audioUrl == null) {
      AppActions().showErrorToast(
          context: context, text: "Please Select the audio you want to cast");
    } else if (bannerFile == null && imageUrl == "") {
      AppActions().showErrorToast(
          context: context, text: "Please Select the image  you want to cast");
    } else {
      _validateFields();
    }
  }

  _validateFields() async {
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
    var imageFileUrl = imageUrl;
    if (bannerFile != null) {
      imageFileUrl = await uploadImageFile();
    }
    Map data = {
      "title": titleTxt.text,
      "description": descpTxt.text,
      "image": imageFileUrl,
      "userID": PublicVar.userId,
      "duration": "$duration",
      "moodType": selectedMood,
      "interestID": appBloc.selectedUploadInterest["_id"],
      "resourceUrl": audioUrl
    };

    print(data);
    if (widget.update == true
        ? await Server().putAction(
            url: "${Urls.resource}/${resourceId}", data: data, bloc: appBloc)
        : await Server()
            .postAction(url: Urls.resource, data: data, bloc: appBloc)) {
      var res = appBloc.mapSuccess;
      print(res);
      await Server().loadUser(appBloc: appBloc, context: context);
      await Server().loadHost(appBloc: appBloc, context: context);
      showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return CreateContentSuccess(
              update: widget.update,
            );
          });
    } else {
      showLoading();
      AppActions().showErrorToast(
        text: "${appBloc.errorMsg}",
        context: context,
      );
    }
  }

  bannerImageView() {
    return bannerFile == null
        ? imageUrl == ""
            ? AssetImage(PublicVar.defaultAppImage)
            : NetworkImage(imageUrl)
        : FileImage(bannerFile!);
  }

  void selectInterest(int index, bool value) {
    setState(() {
      if (value == false) {
        appBloc.interests[index]["selected"] = true;
      } else {
        appBloc.interests[index]["selected"] = false;
      }
    });
  }

  void selectAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    late File file;
    if (result != null) {
      final assetsAudioPlayer = AssetsAudioPlayer();

      assetsAudioPlayer.open(
        Audio.file(result.files.single.path!),
        autoStart: false,
      );

      assetsAudioPlayer.current.listen((playingAudio) {
        final songDuration = playingAudio?.audio.duration.inMinutes;
        setState(() {
          duration = songDuration;
        });
      });
      assetsAudioPlayer.stop();
      AppActions().showAppDialog(context,
          title: "Confirm File?",
          descp: "Are you sure this is the file you want to upload?",
          okText: "Upload",
          cancleText: "Cancel", okAction: () async {
        Navigator.pop(context);
        file = File(result.files.single.path!);

        final res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            file!.path,
            publicId: "mindcast" + DateTime.now().toIso8601String(),
            folder: 'mindcast-folder',
            context: {
              'alt': 'mindcast' + new DateTime.now().toIso8601String(),
              'caption': 'cast folder',
            },
          ),
          onProgress: (count, total) {
            setState(() {
              _uploadingPercentage = (count / total) * 100;
              if (_uploadingPercentage < 100) {
                isUploading = true;
              } else {
                isUploading = false;
              }
              print(_uploadingPercentage);
            });
          },
        );
        audioUrl = res.secureUrl;
        print(res.secureUrl);
        setState(() {});
      });
    }
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
    imageUrl = res.secureUrl;
    setState(() {});
    return res.secureUrl;
  }
}

class ViewInterest extends StatefulWidget {
  const ViewInterest({Key? key}) : super(key: key);

  @override
  State<ViewInterest> createState() => _ViewInterestState();
}

class _ViewInterestState extends State<ViewInterest> {
  late AppBloc appBloc;
  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
          height: 600,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: Text(
                    "Choose Category",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                ListView.builder(
                    itemCount: appBloc.interests.length,
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: InkWell(
                          onTap: () {
                            appBloc.selectedUploadInterest =
                                appBloc.interests[index];
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.9),
                                border: Border.all(width: 2),
                                borderRadius: BorderRadius.circular(40)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                          width: 30,
                                          child: GetImageProvider(
                                            url: appBloc.interests[index]
                                                ["icon"],
                                            placeHolder:
                                                PublicVar.defaultAppImage,
                                          )),
                                      Container(
                                        padding: EdgeInsets.only(left: 20),
                                        width: 200,
                                        child: Text(
                                          appBloc.interests[index]["name"]
                                              as String,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
              ],
            ),
          )),
    );
  }
}
