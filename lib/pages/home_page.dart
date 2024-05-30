// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
class HomePage extends StatefulWidget {
  // ignore: use_super_parameters
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _counter = "";

  @override
  void initState() {
    super.initState();
    createDefaultProfile();
    databaseAccess();

  }

  Future<void> createDefaultProfile() async
  {
    try{
      FirebaseFirestore db = FirebaseFirestore.instance;
      final defaultData = <String,dynamic>{
        "name": "",
        "surname":"",
        "age_rating_tags":[],
        "birthday": null,
        "genre_interests_tags":[],
        "profile_picture" :"gameonconnect-cf66d.appspot.com/default_image.jpg",
        "social_interests_tags":[],
        "theme" : "light",
        "userID":"svVm2V1l9YQCqJYH0y0Jpg3iapz2",   // change this to dynamically add the user's id
        "username": {"profile_name": "","uniwue_num":1},
        "visibility": true
      };

      db.collection("profile_data")
      .doc("svVm2V1l9YQCqJYH0y0Jpg3iapz2")  // change this to dynamically add the user's id
      .set(defaultData)
      .onError((e,_)=>
          setState(() {
            _counter = "Error creating profile data $e"; // Update counter with error message
          })
      );

    }catch(e)
    {
      setState(() {
        _counter = "Error creating profile $e"; // Update counter with error message
      });
    }
  }

  Future<void> databaseAccess() async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      CollectionReference profileRef = db.collection("profile_data");
      DocumentSnapshot qs = await profileRef.doc("svVm2V1l9YQCqJYH0y0Jpg3iapz2").get();

      if(qs.exists)
        {
            setState(() {
              _counter = "profile exists: ${qs.data()}";
            });
            print("profile exists: ${qs.data()}");

        }else
          {
            setState(() {
              _counter = "Profile not found for user svVm2V1l9YQCqJYH0y0Jpg3iapz2";
            });
            print("Profile not found for user svVm2V1l9YQCqJYH0y0Jpg3iapz2");
          }
    } catch (e) {
      setState(() {
        _counter = "Error reading profile data"; // Update counter with error message
      });
      print('Error reading profile data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Data:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10,),
              Text(_counter, style: Theme.of(context).textTheme.bodyLarge,),
            ],
          ),
        ),
      ),
    );
  }
}