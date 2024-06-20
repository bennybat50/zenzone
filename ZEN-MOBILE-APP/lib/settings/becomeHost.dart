import 'package:app_framework/app_framework.dart';
import 'package:flutter/material.dart';
import 'package:mindcast/dashboard/base_page.dart';
import 'package:mindcast/utils/next_page.dart';
import 'package:provider/provider.dart';

import '../bloc/app_bloc.dart';
import '../bloc/server.dart';
import '../models/PublicVar.dart';
import '../models/urls.dart';
import '../utils/app_actions.dart';
import '../widgets/global_widgets.dart';

class BecomeHost extends StatefulWidget {
  const BecomeHost({Key? key}) : super(key: key);

  @override
  State<BecomeHost> createState() => _BecomeHostState();
}

class _BecomeHostState extends State<BecomeHost> {
  var acceptTerms = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String selectedValue = 'Please select';
  late bool loading = false;
  var reason = TextEditingController();
  var experience = TextEditingController();
  var community = TextEditingController();
  List<String> dropdownItems = ['Please select', 'Option 2', 'Option 3'];
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
            "Become a host",
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
        child: appBloc.userDashboard["user"]["hostStatus"] == "pending"
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/app_logo.png",
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Host request is pending approval from Admin, You will get a mail once it is approved",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )
                ],
              ))
            : Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        "We just need few information to make you a host, creating content, podcast, and getting subscribers",
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
                              "Why do you want to be a host",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 4),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                              controller: reason,
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
                              "Any previous experience",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 4),
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
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              "Are you willing to build to a community",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 4),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                              controller: community,
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
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Container(
                        // height: 150,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              acceptTerms = !acceptTerms;
                            });
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: acceptTerms
                                        ? Colors.transparent
                                        : Colors.transparent,
                                    width: 2.0,
                                  ),
                                ),
                                width: 24.0,
                                height: 24.0,
                                alignment: Alignment.center,
                                child: acceptTerms
                                    ? const Icon(
                                        Icons.radio_button_checked,
                                        size: 20.0,
                                        color: Colors.black,
                                      )
                                    : const Icon(
                                        Icons.radio_button_unchecked,
                                        size: 20.0,
                                        color: Colors.black,
                                      ),
                              ),
                              const Expanded(
                                child: Text(
                                  'I agree to the Terms of Use & acknowledge I have read the Privacy Policy',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
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

      if (acceptTerms) {
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
  }

  sendToServer() async {
    Map data = {
      "userID": PublicVar.userId,
      "experience": experience.text,
      "reason": reason.text,
      "buildCommunity": community.text
    };
    if (await Server()
        .postAction(url: Urls.becomeHost, data: data, bloc: appBloc)) {
      var res = appBloc.mapSuccess;
      await Server().loadDashboard(appBloc: appBloc, context: context);
      AppActions().showAppDialog(context,
          title: 'Host Request',
          descp:
              'Your request to become a host has been sent successfully, you will get an email once it is approved',
          okText: 'Okay',
          singlAction: true, okAction: () {
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
}
