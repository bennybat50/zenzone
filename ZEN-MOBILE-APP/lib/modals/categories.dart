import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _DownloadingState();
}

class _DownloadingState extends State<Categories> {
  var categories = [
    "Meditation",
    "Affirmations",
    "Stories",
    "Sleep wel",
    "Relationship",
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      height: 400,

      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(40), topLeft:Radius.circular(40) )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap:(){
              Navigator.of(context).pop();
            },
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
            ),
          ),
          ListView.builder(
            itemCount: 5,
              shrinkWrap: true,
              itemBuilder: (context, index){
              var item = categories[index];
                return InkWell(
                  child: ListTile(
                    leading: Text("${item}"),
                    trailing: index==1?Icon(Icons.done):null,
                  ),
                );
              }
          ),

  
        ],
      ),
    );
  }
}
