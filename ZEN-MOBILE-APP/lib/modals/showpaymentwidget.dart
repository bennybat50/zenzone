import 'package:app_framework/app_framework.dart';
import 'package:flutter/material.dart';
import 'package:mindcast/models/PublicVar.dart';
import 'package:mindcast/widgets/global_widgets.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../bloc/app_bloc.dart';
import '../bloc/server.dart';
import '../models/urls.dart';
import '../utils/app_actions.dart';

class ShowPaymentWidget extends StatefulWidget {
  final List<Package> packages;
  final ValueChanged<StoreProduct> onClickedPackage;
  const ShowPaymentWidget(
      {Key? key, required this.packages, required this.onClickedPackage})
      : super(key: key);

  @override
  State<ShowPaymentWidget> createState() => _ShowPaymentWidgetState();
}

class _ShowPaymentWidgetState extends State<ShowPaymentWidget> {
  var selectedPlan = "";
  var selectedPackage;
  var couponTxt = TextEditingController();
  bool loading = false, subscribe = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AppBloc appBloc;
  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 70),
        child: ListView(
          children: [
            subscribe == false
                ? Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        Text(
                          "Choose Payment Method",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          "Provide subscription coupon code or subscribe to a plan",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(PublicVar.primaryColor),
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 4),
                            width: 350,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                              validator: Validation().text,
                              controller: couponTxt,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter Coupon Code"),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 40.0),
                          child: ButtonWidget(
                            onPress: () => _validateFields(),
                            width: double.infinity,
                            height: 50.0,
                            loading: loading,
                            txColor: Colors.white,
                            bgColor: Color(PublicVar.primaryColor),
                            text: 'Apply Coupon Code',
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "-----------OR-----------",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 40.0),
                          child: ButtonWidget(
                            onPress: () {
                              setState(() {
                                subscribe = true;
                              });
                            },
                            width: double.infinity,
                            height: 50.0,
                            loading: selectedPlan != "",
                            txColor: Colors.white,
                            bgColor: Color(PublicVar.primaryColor),
                            text: 'Get A Plan',
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
            subscribe == true
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Get a plan",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        "Unlimited premium access for 3-Days",
                        style: TextStyle(
                            color: Color(PublicVar.primaryColor),
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children:
                            List.generate(widget.packages.length, (index) {
                          final item = widget.packages[index];
                          StoreProduct package = item.storeProduct;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: InkWell(
                              onTap: () {
                                selectedPlan = package.identifier;
                                selectedPackage = package;
                                setState(() {});
                                widget.onClickedPackage(selectedPackage);
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                      color: selectedPlan == package.identifier
                                          ? Color(PublicVar.primaryColor)
                                          : Color(PublicVar.primaryColor)
                                              .withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(40)),
                                  child: ListTile(
                                    title: Text(
                                      "${package.title}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${package.currencyCode}179.88",
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.grey[200],
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        ),
                                        Text(
                                          "${package.priceString}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        )
                                      ],
                                    ),
                                    trailing: selectedPlan == package.identifier
                                        ? ShowProcessingIndicator()
                                        : Icon(
                                            Icons.chevron_right,
                                            color: Colors.white,
                                          ),
                                  )),
                            ),
                          );
                        }),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.check_circle,
                          color: Color(PublicVar.primaryColor),
                        ),
                        title: Text(
                            "Access to all features for 3 days at no cost."),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.check_circle,
                          color: Color(PublicVar.primaryColor),
                        ),
                        title: Text(
                            "No commitment required during the trial period."),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.check_circle,
                          color: Color(PublicVar.primaryColor),
                        ),
                        title: Text(
                            "Cancel anytime before the trail ends to avoid being charged."),
                      ),
                      SizedBox()
                    ],
                  )
                : SizedBox()
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
            //   child: ButtonWidget(
            //     onPress: () => widget.onClickedPackage(selectedPackage),
            //     width: double.infinity,
            //     height: 50.0,
            //     loading: selectedPlan!="",
            //     txColor: Colors.white,
            //     bgColor: Color(PublicVar.primaryColor),
            //     text: 'Try free & Subscribe',
            //   ),
            // ),
            SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Skip",
                  style: TextStyle(fontSize: 18),
                ))
          ],
        ),
      ),
    );
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
    var data = {"userID": PublicVar.userId, "code": couponTxt.text};
    if (await Server()
        .postAction(url: Urls.assignCouponCode, data: data, bloc: appBloc)) {
      await Server().loadDashboard(appBloc: appBloc);
      Navigator.pop(context);
    } else {
      showLoading();
      AppActions().showErrorToast(
        text: "${appBloc.errorMsg}",
        context: context,
      );
    }
  }
}
