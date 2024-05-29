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
    databaseAccess();
  }

  Future<void> databaseAccess() async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      CollectionReference profileRef = db.collection("profile_data");
      DocumentSnapshot qs = await profileRef.doc("DHfSzIoQpFMJgSuXlvi53Tp88t73").get();

      if(qs.exists)
        {
            setState(() {
              _counter = "profile exists: ${qs.data()}";
            });
            print("profile exists: ${qs.data()}");

        }else
          {
            setState(() {
              _counter = "Profile not found for user DHfSzIoQpFMJgSuXlvi53Tp88t73";
            });
            print("Profile not found for user DHfSzIoQpFMJgSuXlvi53Tp88t73");
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