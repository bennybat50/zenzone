import 'package:app_framework/app_framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

import '../bloc/app_bloc.dart';
import '../bloc/server.dart';
import '../models/PublicVar.dart';
import '../models/urls.dart';
import '../utils/app_actions.dart';
import '../utils/next_page.dart';
import '../widgets/global_widgets.dart';
import 'login.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  AppBloc? appBloc;
  bool btnEnabled = true,
      completed = true,
      verify = false,
      _autoValidate = false,
      showLoading = false,
      showPassword = false;

  GlobalKey<ScaffoldState> buttonKey = new GlobalKey();
  var dataUser;
  TextEditingController emailController = TextEditingController();
  int state = 0, networkStatus = 0;
  TextEditingController verifyController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _verifyCode, _passField;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    emailController.text = PublicVar.userEmail ?? "";

    super.initState();
  }

  Widget FormUI() {
    return Column(
      children: <Widget>[
        //CREATE ACCOUNT TEXT
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 50, bottom: 10.0),
              child: Text(
                verify ? "Reset Your password" : "Forgot Password",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Text(
                verify
                    ? "A Verification code has been sent to ${PublicVar.userEmail}. Please type it in the verification field and then enter your new password."
                    : "Please provide your registered email address and a verification code will be sent to you",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        //CREATE ACCOUNT TEXT END

        formFields(),
        //CREATE ACCOUNT BTN
        Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: ButtonWidget(
              width: double.infinity,
              height: 50.0,
              loading: showLoading,
              onPress: () => validateFields(),
              txColor: Colors.white,
              bgColor: Color(PublicVar.primaryColor),
              text: verify ? 'Change Password' : 'Verify Email',
            )),

        //ALREADY HAVE ACC

        // //ALREADY HAVE ACC END
      ],
    );
  }

  Widget formFields() {
    if (verify) {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
          child: Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.number,
                autofocus: true,
                maxLength: 6,
                controller: verifyController,
                onEditingComplete: () => validateFields(),
                validator: Validation().validateCode,
                onSaved: (String? val) {
                  _verifyCode = val;
                },
                decoration: InputDecoration(
                    labelText: 'Enter verification code',
                    labelStyle: TextStyle(fontSize: 15.0),
                    hintText: "- - - - - -",
                    icon: Icon(
                      Feather.user_check,
                      size: 18.0,
                      color: Colors.black,
                    )),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      autofocus: false,
                      obscureText: showPassword,
                      onEditingComplete: () => validateFields(),
                      style: TextStyle(letterSpacing: 1),
                      validator: validatePass,
                      onSaved: (String? val) {
                        _passField = val;
                      },
                      decoration: InputDecoration(
                          labelText: 'Enter New Password',
                          labelStyle: TextStyle(letterSpacing: 0.1),
                          icon: Icon(
                            Feather.lock,
                            size: 18.0,
                            color: Colors.black,
                          )),
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
              )
            ],
          ));
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          controller: emailController,
          onEditingComplete: () => validateFields(),
          validator: Validation().email,
          decoration: InputDecoration(
              labelText: 'Enter Your Email Address',
              hintText: " Email ",
              icon: Icon(
                Feather.mail,
                size: 18.0,
                color: Colors.black,
              )),
        ),
      );
      //EMAIL TEXT END
    }
  }

  String? validatePass(value) => Validation().password(value, 8);

  validateFields() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (verify) {
        verifyAccount();
      } else {
        sendCodeToEmail();
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }

  sendCodeToEmail() async {
    AppActions().showLoadingToast(
      text: PublicVar.wait,
      context: context,
    );
    isLoading();
    Map data = {
      "email": "${emailController.text!.trim().toLowerCase()}",
    };

    if (await Server().postAction(
      bloc: appBloc,
      data: data,
      url: Urls.resendCode,
    )) {
      print(appBloc!.mapSuccess);
      verify = true;
      AppActions().showAppDialog(
        context,
        title: 'Verify Email',
        descp:
            'A Verification code has been sent to ${emailController.text}. Please enter the verification code and then your new password in the fields below.',
        singlAction: true,
        okText: 'Ok',
      );
      PublicVar.userEmail = emailController.text;
      await SharedStore()
          .setData(type: 'string', key: 'email', data: emailController.text);
      isLoading();
    } else {
      AppActions().showErrorToast(
        text: appBloc!.errorMsg,
        context: context,
      );
      isLoading();
    }
  }

  verifyAccount() async {
    isLoading();
    Map data = {
      "email": emailController.text!.toLowerCase(),
      "code": int.parse(_verifyCode!),
      "passwd": _passField
    };
    if (await Server().postAction(
      bloc: appBloc,
      data: data,
      url: Urls.resetPassword,
    )) {
      isLoading();
      print(appBloc!.mapSuccess);
      AppActions().showAppDialog(
        context,
        title: 'Verify Email',
        descp:
            'Your password has reset successful,\n Please login with the new password you just created',
        okText: 'OK',
        okAction: () async {
          NextPage().nextRoute(context, Login());
        },
        singlAction: true,
      );
    } else {
      isLoading();
      AppActions().showErrorToast(
        text: appBloc!.errorMsg,
        context: context,
      );
    }
  }

  isLoading() {
    setState(() {
      if (showLoading) {
        showLoading = false;
        btnEnabled = true;
      } else {
        showLoading = true;
        btnEnabled = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return WillPopScope(
      onWillPop: () async {
        return btnEnabled;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              if (!showLoading) {
                Navigator.pop(context);
              }
            },
            icon: Icon(
              Ionicons.ios_close,
              size: 30,
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    verify = false;
                  });
                },
                child: Text("Change Email"))
          ],
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: FormUI(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
