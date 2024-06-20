import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindcast/dashboard/podcasterProfile.dart';

class LivePodcast extends StatefulWidget {
  const LivePodcast({Key? key}) : super(key: key);

  @override
  State<LivePodcast> createState() => _LivePodcastState();
}

class _LivePodcastState extends State<LivePodcast> {
  var commentList = [

    {
      "authorAvatar":"assets/images/avatar.jpg",
      "authorName":"Lyne Russel",
      "isAnonymous":false,
      "comment":"Dance therapy?"
    },
    {
      "authorAvatar":"assets/images/dorcas.png",
      "authorName":"Dorcas Shaibu",
      "isAnonymous":false,
      "comment":"This is a test comment intended to check for length response in case of extremely long comments. How's it doing in that regard?",

    },
    {
      "authorAvatar":"",
      "authorName":"",
      "isAnonymous":true,
      "comment":"I feel like crying already"
    },
    {
      "authorAvatar":"assets/images/podcaster.png",
      "authorName":"John Doe",
      "isAnonymous":false,
      "comment":"Welcome to my podcast y'all"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/podcaster.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),



          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25, top: 40, bottom: 10),

            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap:(){
                        showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context){

                          return Container( 
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                            height: 300,
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
                                      width: 80,
                                      height: 7,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Expanded(child: Text("Sebestian Pandelache",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700
                                      )
                                      )),
                                      Container(
                                        width: 40,
                                        height: 40,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey

                                        ),

                                        child: Icon(Icons.favorite_border),
                                      )
                                    ],
                                  ),
                                ),

                                Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: Text("Mental Health Therapist",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16
                                ),
                                ),
                                ),
                                Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: Text("Mood, Relationship, Self development, Career counsellor, Speech therapist",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.grey
                                ),
                                ),
                                ),


                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: Color(0xff40176c),
                                      borderRadius: BorderRadius.circular(20)
                                    ),

                                    child: Text("Join the host",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700
                                    ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                      },
                      child: Container(
                        alignment:Alignment.center,
                        height: 80,
                        child: Icon(Icons.arrow_drop_down_outlined,
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (builder)=>const PodcasterProfile()));

                      },
                      child: Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100)
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.asset("assets/images/dorcas.png",
                                    alignment: Alignment.topCenter,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // height:30,
                                  padding:EdgeInsets.only(top: 10),
                                  child: Text("Sebastian Pandelache",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700
                                    ),

                                  ),
                                ),

                                SizedBox(
                                  height: 20,
                                  child: Row(
                                    children:  [
                                      Container(
                                          width:35,
                                          child: Text("LIVE")),
                                      Icon(Icons.circle,
                                        size: 12,
                                        color: Colors.red,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),


                          ],
                        ),
                      ),
                    ),

                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey

                      ),

                      child: Icon(Icons.favorite_border),
                    )




                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 200,
                  maxHeight: 500
                ),
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: ListView.builder(
                      itemCount: commentList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index){
                        var comment = commentList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(
                            padding: EdgeInsets.all(5),
                             decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(7)
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: comment["isAnonymous"] ==true? Colors.deepPurpleAccent:Colors.transparent
                                  ),

                                  child: comment["isAnonymous"] == false? ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.asset(comment["authorAvatar"] as String,
                                        fit: BoxFit.cover,
                                        alignment: Alignment.topCenter,
                                      )):null,
                                ),
                                // SizedBox(width: 10,),


                                Container(
                                  // width: 100,
                                  child: RichText(
                                    text: TextSpan(text: "  ${ comment["isAnonymous"]==false? comment["authorName"] :"Anonymous"} : "),
                                  ),
                                ),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(text: comment["comment"] as String),
                                  ),
                                ),



                              ],
                            ),


                          ),
                        );
                      }
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
              child: Container(
                  constraints: BoxConstraints(
                      minHeight: 80
                  ),
                  padding: EdgeInsets.all(10),
                  width: double.infinity,

                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(7)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFormField(
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: TextStyle(
                              color: Colors.white
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10),
                              hintText: "Type here ...",
                              hintStyle: TextStyle(
                                  color: Colors.white
                              )
                          ),

                        ),
                      ),

                      Icon(Icons.send,
                        size: 30,
                        color: Colors.white,
                      )
                    ],
                  )
              ),
            ),
          ),
        ],
      )
    );
  }
}
