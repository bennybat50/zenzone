import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Downloading extends StatefulWidget {
  const Downloading({Key? key}) : super(key: key);

  @override
  State<Downloading> createState() => _DownloadingState();
}

class _DownloadingState extends State<Downloading> {
  double downloadStatus = 0.81;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      height: 300,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(40), topLeft:Radius.circular(40) )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap:(){
              Navigator.of(context).pop();
            },
            child: Container(
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: const Text("Downloading...",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700
                )
            ),
          ),

          Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child:  Container(

              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1,
                    spreadRadius: 0,
                    color: Colors.grey
                  )
                ]
              ),
              child: Row(
                children: [
                  Icon(Icons.sim_card_download_outlined,
                  // size: 30,
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Downloading file",
                              ),
                              Container(
                                  // width: 30,
                                  child: Text("${downloadStatus * 100}%",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700
                                  ),
                                  )
                              ),


                            ],
                          ),
                          Container(
                            width: double.infinity,
                            child: LinearProgressIndicator(

                              value: downloadStatus,
                              color: Colors.green,
                              backgroundColor: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  


                ],
              ),
            )
          ),




          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                  color: Color(0xff40176c),
                  borderRadius: BorderRadius.circular(7)
              ),

              child: Text("Continue",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  fontSize: 20
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(7)
              ),

              child: Text("Cancel",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  fontSize: 20
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
