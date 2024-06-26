import 'package:app_framework/app_framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mindcast/models/PublicVar.dart';
import 'package:mindcast/onboarding/login.dart';
import 'package:mindcast/utils/next_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/app_bloc.dart';
import '../bloc/server.dart';
import '../dashboard/base_page.dart';
import '../models/urls.dart';
import '../utils/app_actions.dart';
import '../widgets/global_widgets.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool acceptTerms = false;
  var usernameTxt = TextEditingController(),
      emailTxt = TextEditingController(),
      passTxt = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool _autoValidate = false, showPassword = true, loading = false;
  late Map device, app;
  late SharedPreferences prefs;
  late AppBloc appBloc;
  ScrollController? _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.deepPurple));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 230,
                pinned: true,
                titleSpacing: 0.0,

                actions: <Widget>[],
//
                elevation: 0.0,
                forceElevated: true,
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        child: Container(
                          child: Stack(
                            children: [
                              Image.asset(
                                "assets/images/background.png",
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              // Lottie.asset(
                              //     'assets/images/background.lottie.json',
                              //     width: double.infinity,
                              //     height: double.infinity,
                              //     fit: BoxFit.cover,
                              //     frameRate: FrameRate(1000)),
                              Container(
                                height: double.infinity,
                                width: double.infinity,
                                color: Colors.black.withOpacity(0.4),
                              )
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Image.asset(
                              "assets/images/logo.png",
                              height: 60,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Text(
                              "Zenzone",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Color(0xff1C1232),
                  child: SingleChildScrollView(
                    child: HomeView(),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  HomeView() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  child: const Text(
                    "Create an account to proceed",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    // textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    validator: Validation().text,
                    onEditingComplete: () {
                      if (!loading) {
                        _validateFields();
                      }
                    },
                    controller: usernameTxt,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Name"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    validator: Validation().email,
                    controller: emailTxt,
                    onEditingComplete: () {
                      if (!loading) {
                        _validateFields();
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Email"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: passTxt,
                          onEditingComplete: () {
                            if (!loading) {
                              _validateFields();
                            }
                          },
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: showPassword,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: "Password"),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (showPassword) {
                              showPassword = false;
                            } else {
                              showPassword = true;
                            }
                          });
                        },
                        icon: showPassword
                            ? Icon(Feather.eye_off)
                            : Icon(Feather.eye),
                        color: showPassword
                            ? Colors.grey
                            : Color(PublicVar.primaryColor),
                        iconSize: 18.0,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    validator: confirmPass,
                    obscureText: true,
                    onEditingComplete: () {
                      if (!loading) {
                        _validateFields();
                      }
                    },
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Confirm password"),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                child: ButtonWidget(
                  onPress: () {
                    if (!loading) {
                      _validateFields();
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
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => const Login()));
                },
                child: RichText(
                    text: TextSpan(children: [
                  const TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(
                        color: Colors.black,
                      )),
                  TextSpan(
                      text: "Login",
                      style: TextStyle(
                          color: Color(PublicVar.primaryColor),
                          fontWeight: FontWeight.w700))
                ])),
              ),
              SizedBox(
                height: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validatePass(value) => Validation().password(value, 4);
  String? confirmPass(value) {
    if (value != passTxt.text) {
      return "Password did not match";
    }
    return null;
  }

  showLoading() {
    if (loading) {
      loading = false;
    } else {
      loading = true;
    }
    setState(() {});
  }

  _validateFields() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      showLoading();
      device = await DeviceInfo().getInfo(context);
      app = await DeviceInfo().getPackageInfo();
      if (await AppActions().checkInternetConnection()) {
        sendToServer();
      } else {
        showLoading();
        AppActions().showErrorToast(
          text: PublicVar.checkInternet,
          context: context,
        );
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }

  sendToServer() async {
    Map data = {
      "email": emailTxt.text.trim().toLowerCase(),
      "password": passTxt.text,
      "username": usernameTxt.text.trim(),
      // "device": device,
      // "app": app
    };
    print(data);
    if (await Server()
        .postAction(url: Urls.register, data: data, bloc: appBloc)) {
      await Server().getAction(
          appBloc: appBloc,
          url: "${Urls.aUser}/${appBloc.mapSuccess["user"]["_id"]}");
      var res = appBloc.mapSuccess;

      PublicVar.userId = res['_id'];
      PublicVar.userName = res['username'] ?? "";
      PublicVar.userEmail = res['email'] ?? "";
      PublicVar.isActive = res['active'] ?? "";
      PublicVar.enableNotification = res['notification'] ?? "";
      PublicVar.isHost = res['isHost'] ?? "";
      PublicVar.account_status = res['status'] ?? "";
      appBloc.userDetails = res;
      await SharedStore()
          .setData(type: 'bool', data: true, key: 'accountApproved');
      await SharedStore()
          .setData(type: 'string', data: PublicVar.userId, key: "user_id");

      nextPage(res: res);
    } else {
      showLoading();
      AppActions().showErrorToast(
        text: "${appBloc.errorMsg}",
        context: context,
      );
    }
  }

  nextPage({res}) {
    NextPage().nextRoute(context, BasePage());
  }
}
