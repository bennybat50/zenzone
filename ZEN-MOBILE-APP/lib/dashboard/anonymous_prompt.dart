import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindcast/dashboard/loading.dart';

class AnonymousPrompt extends StatefulWidget {
  const AnonymousPrompt({Key? key}) : super(key: key);

  @override
  State<AnonymousPrompt> createState() => _AnonymousPromptState();
}

class _AnonymousPromptState extends State<AnonymousPrompt> {
  @override
  var _selectedOption;
  var emptySelection = true;
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
          // backgroundColor: Colors.white.withOpacity(0.1),
          // backgroundColor: Colors.grey.withOpacity(0.1),
          appBar: AppBar(
            backgroundColor: Colors.grey.withOpacity(0),
            toolbarHeight: 150,
            automaticallyImplyLeading: false,
            elevation: 0,
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
            child: ListView(
              children: [
                FractionallySizedBox(
                  widthFactor: 0.7,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Do you want to join as anonymous?",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: FractionallySizedBox(
                    widthFactor: 0.7,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Select Yes if you want to keep your identity hidden",
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.4),
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                    ),
                  ),
                ),
                Column(
                  children: [
                    RadioListTile<bool>(
                      title: const Text('Yes'),
                      value: true,
                      groupValue: _selectedOption,
                      onChanged: (bool? value) {
                        setState(() {
                          _selectedOption = value!;
                          emptySelection = false;
                        });
                      },
                    ),
                    RadioListTile<bool>(
                      title: const Text('No'),
                      value: false,
                      groupValue: _selectedOption,
                      onChanged: (bool? value) {
                        setState(() {
                          _selectedOption = value!;
                          emptySelection = false;
                        });
                      },
                    ),
                  ],
                ),
                InkWell(
                  onTap: (){
                    if(!emptySelection){
                      Navigator.push(context, MaterialPageRoute(builder: (builder)=>const Loading()));
                    };
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        color: emptySelection
                            ? Color(0xff40176C).withOpacity(0.6)
                            : Color(0xff40176C),
                        borderRadius: BorderRadius.circular(7)),
                    child: const Text(
                      "Join the podcast",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
