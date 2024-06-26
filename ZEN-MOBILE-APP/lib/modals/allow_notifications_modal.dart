import 'package:flutter/material.dart';
import 'package:mindcast/firebase_api.dart';
import 'package:mindcast/models/PublicVar.dart';

class AllowNotificationModal extends StatefulWidget {
  const AllowNotificationModal({Key? key}) : super(key: key);

  @override
  State<AllowNotificationModal> createState() => _AllowNotificationModalState();
}

class _AllowNotificationModalState extends State<AllowNotificationModal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.withOpacity(0.2),
        child: ListView(
          children: [
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 25,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Turn on notification",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 30),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Get the best out of Zenzone  on "
                      "recommendations, updates and "
                      "personalized goals.",
                      style: TextStyle(
                          fontSize: 18,
                          height: 1.5,
                          color: Colors.black.withOpacity(0.4),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Container(
                          alignment: Alignment.center,
                          height: 200,
                          child: Image.asset(
                            "assets/images/notification_skeleton.png",
                            width: double.infinity,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: InkWell(
                          onTap: () {
                            FirebaseApi().initNotifications(true);
                            Navigator.pop(context);
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(vertical: 18),
                              width: 350,
                              decoration: BoxDecoration(
                                color: Color(PublicVar.primaryColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Allow Notification",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(vertical: 18),
                              width: 350,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Skip",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
