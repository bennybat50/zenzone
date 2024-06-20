import 'package:app_framework/app_framework.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc/app_bloc.dart';
import '../bloc/server.dart';
import '../models/PublicVar.dart';
import '../models/urls.dart';
import '../utils/app_actions.dart';
import '../widgets/global_widgets.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var acceptTerms = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String selectedValue = 'Please select';
  late bool loading = false;
  var newPasswordTxt = TextEditingController();
  var oldPasswordTxt = TextEditingController();
  var confirmPasswordTxt = TextEditingController();
  late AppBloc appBloc;
  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return Container(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.withOpacity(0),
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Text(
            "Change Password",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w800, fontSize: 24),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 28.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.close,
                size: 25,
                color: Colors.black,
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
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Please provide your old password to update a new one",
                  style: TextStyle(color: Colors.grey, fontSize: 18),
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
                        "Old Password",
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
                        controller: oldPasswordTxt,
                        validator: validatePass,
                        obscureText: true,
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
                        "New Password",
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
                        controller: newPasswordTxt,
                        validator: validatePass,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
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
                        "Confirm Password",
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
                        controller: confirmPasswordTxt,
                        validator: confirmPass,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 30.0,
                ),
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
                  text: "Change Password",
                  addIconBG: false,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  String? validatePass(value) => Validation().password(value, 4);
  String? confirmPass(value) {
    if (value != newPasswordTxt.text) {
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
    } else {
      AppActions().showErrorToast(
        text: "Please accept our terms",
        context: context,
      );
    }
  }

  sendToServer() async {
    Map data = {
      "userID": PublicVar.userId,
      "password": oldPasswordTxt.text,
      "newPassword": newPasswordTxt.text,
    };
    if (await Server()
        .postAction(url: Urls.changePassword, data: data, bloc: appBloc)) {
      var res = appBloc.mapSuccess;
      await Server().loadDashboard(appBloc: appBloc, context: context);
      AppActions().showAppDialog(context,
          title: 'Password Updated',
          descp:
              'Please save your password somewhere safe, should incase you need to login again',
          okText: 'Ok', okAction: () {
        Navigator.pop(context);
      });
    } else {
      showLoading();
      AppActions().showErrorToast(
        text: "${appBloc.errorMsg}",
        context: context,
      );
    }
  }
}
