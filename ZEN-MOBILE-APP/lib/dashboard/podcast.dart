import 'package:flutter/material.dart';
import 'package:mindcast/dashboard/nowPlaying.dart';
import 'package:mindcast/modals/categories.dart';

class Podcast extends StatefulWidget {
  final baseKey;

  const Podcast({
    Key? key,
    this.baseKey,
  }) : super(key: key);

  @override
  State<Podcast> createState() => _ResourcesState();
}

class _ResourcesState extends State<Podcast> {
  var popularResources = [
    {
      "title": "Daily affirmations",
      "author": "VOO Onoja",
      "duration": "34",
      "thumbnail": "assets/images/clock.webp",
      "like": false,
    },
    {
      "title": "Tribal sounds",
      "author": "Roman Collins",
      "duration": "20",
      "thumbnail": "assets/images/zebra.jpg",
      "like": true,
    },
    {
      "title": "chaotic MINDS",
      "author": "Sarah Williams",
      "duration": "20",
      "thumbnail": "assets/images/card2.jpg",
      "like": false,
    },
    {
      "title": "Soul & MINDS",
      "author": "Onoja VOO",
      "duration": "25",
      "thumbnail": "assets/images/card3.jpg",
      "like": false,
    },
  ];
  var recommendedList = [
    {
      "genre": "Stories",
      "title": "Whisper at Night: Tales of Mystery and Intrigue",
      "author_name": "Jessica J.",
      "avatar": "assets/images/avatar.jpg",
      "thumbnail": "assets/images/night_whisper.jpg",
      "favorite": false
    },
    {
      "genre": "Meditation",
      "title": "Tranquil Serenity: Guided Meditation for Inner Peace",
      "author_name": "Samson A.",
      "avatar": "assets/images/avatar2.jpg",
      "thumbnail": "assets/images/tranquil.jpg",
      "favorite": false
    },
    {
      "genre": "Kid",
      "title": "Magical Fairytales: Classic Stories for Children",
      "author_name": "Dorcas S.",
      "avatar": "assets/images/dorcas.png",
      "thumbnail": "assets/images/fairytale.jpg",
      "favorite": true
    }
  ];

  var selected = {"meditation": false, "affirmations": false, "stories": false};

  // final GlobalKey<ScaffoldState> indexKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var noneSelected = !selected.containsValue(true);
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        toolbarHeight: 120,
        leadingWidth: double.infinity,
        automaticallyImplyLeading: false,
        leading: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 20, bottom: 5),
              child: Text(
                "Podcast",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 30.0, bottom: 50),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20, right: 30, bottom: 20),
              child: Container(
                padding: EdgeInsets.only(left: 20),
                height: 50,
                width: 310,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 1,
                        spreadRadius: 0,
                        color: Colors.black,
                      )
                    ],
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 20,
                      // height: 40,
                      child: const Icon(
                        Icons.search,
                        color: Colors.black38,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 240,
                      child: TextFormField(
                        autofocus: false,
                        onTapOutside: _handleTapInputOutside,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search for topics",
                            hintStyle: TextStyle(color: Colors.black38),
                            contentPadding:
                                EdgeInsets.only(left: 10, bottom: 10)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: Container(
                // width: 800,
                padding: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black))),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: selected["meditation"]!
                                ? (Color(0xff40176C))
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6)),
                        // width: 80,
                        child: InkWell(
                          onTap: () {
                            updateSelected("meditation");
                          },
                          child: Text(
                            " Meditation",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: selected["meditation"]!
                                    ? Colors.white70
                                    : Colors.black38,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: selected["affirmations"]!
                                ? (Color(0xff40176C))
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6)),
                        child: InkWell(
                          onTap: () {
                            updateSelected("affirmations");
                          },
                          child: Text(
                            "Affirmations",
                            style: TextStyle(
                                color: selected["affirmations"]!
                                    ? Colors.white70
                                    : Colors.black38,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: selected["stories"]!
                                ? (Color(0xff40176C))
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6)),
                        child: InkWell(
                          onTap: () {
                            updateSelected("stories");
                          },
                          child: Text(
                            "Stories",
                            style: TextStyle(
                                color: selected["stories"]!
                                    ? Colors.white70
                                    : Colors.black38,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 25.0),
                        child: InkWell(
                          onTap: () {
                            updateSelected("none");

                            showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) {
                                  return Categories();
                                });
                          },
                          child: Text(
                            "+4 more",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.4),
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30.0, top: 20),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const NowPlaying(
                                canPlay: true,
                              )));
                },
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                      // color: Color(0xff40176C),
                      borderRadius: BorderRadius.circular(20)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/images/now_playing_cover.png",
                      fit: BoxFit.cover,
                      height: 250,
                    ),
                  ),
                ),
              ),
            ),
            if (noneSelected)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 10),
                    child: const Text(
                      "Recommended hosts",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 25),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Container(
                                width: 300,
                                decoration: BoxDecoration(
                                    color: Colors.pink.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 130,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10)),
                                        child: Image.asset(
                                          "assets/images/avatar.jpg",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 35,
                                              child: Text(
                                                "Sigmund Owen",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 25),
                                              ),
                                            ),
                                            Container(
                                              height: 50,
                                              child: Text(
                                                "Relationship, moodswings, self development",
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Text(
                                              "540 Subscribers",
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.4),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Container(
                                width: 300,
                                decoration: BoxDecoration(
                                    color: Colors.greenAccent.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 130,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10)),
                                        child: Image.asset(
                                          "assets/images/dorcas.png",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 35,
                                              child: Text(
                                                "Sigmund Owen",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 25),
                                              ),
                                            ),
                                            Container(
                                              height: 50,
                                              child: Text(
                                                "Relationship, moodswings, self development",
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Text(
                                              "540 Subscribers",
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.4),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 10),
                    child: const Text(
                      "Popular Resources",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 25),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: popularResources.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var resource = popularResources[index];
                        return Container(
                          padding: EdgeInsets.only(left: index == 0 ? 0 : 20),
                          child: Column(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      // color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: AssetImage(
                                              '${resource["thumbnail"]}'),
                                          fit: BoxFit.cover,
                                          alignment: Alignment.topCenter),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: Text(
                                      "${resource["title"]}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 0),
                                    child: Text(
                                      "${resource["duration"]} MIN",
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.5),
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            if (selected["stories"]!)
              Padding(
                padding: const EdgeInsets.only(right: 30.0, top: 20),
                child: GridView.builder(
                  itemCount: popularResources.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var podcast = popularResources[index];
                    return SizedBox(
                      // padding: EdgeInsets.only(left: index == 0 ? 0 : 20),
                      child: Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 135,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: AssetImage(
                                              '${podcast["thumbnail"]}'),
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center),
                                    ),
                                  ),
                                  Positioned(
                                    right: 5,
                                    top: 5,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          podcast["like"] =
                                              !(podcast["like"] as bool);
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.4),
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: InkWell(
                                          child: Icon(
                                            podcast["like"] == true
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 65,
                                    child: Container(
                                        // height: 70,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text(
                                          "${podcast["title"]}".toUpperCase(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        )),
                                  )
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(
                                  "${podcast["author"]}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                child: Text(
                                  "${podcast["duration"]} MIN",
                                  style: TextStyle(
                                      color: Colors.grey.withOpacity(0.7),
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      // mainAxisExtent: double.infinity,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                ),
              )
          ],
        ),
      ),
    );
  }

  void _handleTapInputOutside(PointerDownEvent e) {
    FocusScope.of(context).unfocus();
    setState(() {
      // isSearching = false;
    });
  }

  void updateSelected(String key) {
    selected.forEach((k, _) {
      setState(() {
        selected[k] = (k == key);
      });
    });
  }
}
