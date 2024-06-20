import 'package:flutter/material.dart';

class CreateContentSuccess extends StatefulWidget {
  final bool update;
  const CreateContentSuccess({Key? key, required this.update})
      : super(key: key);

  @override
  State<CreateContentSuccess> createState() => _CreateContentSuccessState();
}

class _CreateContentSuccessState extends State<CreateContentSuccess> {
  double downloadStatus = 0.81;
  var acceptTerms = false;
  bool isUploading = false;
  String selectedValue = 'Select category';
  List<String> dropdownItems = ['Select category', 'Option 2', 'Option 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60.0),
            child: Container(
              width: 60,
              height: 7,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Container(
                        padding: EdgeInsets.all(35),
                        width: 350,
                        constraints: BoxConstraints(
                          minHeight: 400,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.done_sharp,
                                  size: 150,
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: Text(
                                widget.update == true
                                    ? "Content Updated"
                                    : "Content Created",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w700),
                              ),
                            ),
                            const Text(
                              "You can continue to your profile by clicking the button below",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.pop(context);
                          // Navigator.push(context, MaterialPageRoute(builder: (builder)=>const Loading()));
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                              color: Color(0xff40176C),
                              borderRadius: BorderRadius.circular(7)),
                          child: const Text(
                            "Continue to profile",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
