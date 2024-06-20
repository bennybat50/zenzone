import 'package:flutter/material.dart';
import 'package:mindcast/models/PublicVar.dart';

class ShowMessages extends StatefulWidget {
  final title, message, image;
  const ShowMessages({Key? key, this.title, this.message, this.image})
      : super(key: key);

  @override
  State<ShowMessages> createState() => _ShowMessagesState();
}

class _ShowMessagesState extends State<ShowMessages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.withOpacity(0.2),
        child: ListView(
          children: [
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 35,
              ),
              child: Column(
                children: [
                  widget.title == ""
                      ? SizedBox()
                      : Text(
                          "${widget.title}",
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 30),
                        ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.image == ""
                          ? SizedBox()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: Container(
                                alignment: Alignment.center,
                                height: 250,
                                child: Image.network(
                                  "${widget.image}",
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                ),
                              ),
                            ),
                      widget.message == ""
                          ? SizedBox()
                          : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: Text(
                                "${widget.message}",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
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
                                color: Color(PublicVar.primaryColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Okay",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
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
