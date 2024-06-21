// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/wishlist_service.dart';
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

    //createDefaultProfile();
    //databaseAccess();
    wishlistFunctions();
    //editProfile();

  }
  Future <void> wishlistFunctions() async{
    getWL();
    //await addToWL('10');
    await removeFromWL('10');
    getWL();
  }

  Future<void> getWL() async{
    try{
      final wishlist = Wishlist();
      List<String> w = await wishlist.getWishlist();
      print(w);
    setState((){
      _counter = "wishlist: $w";
    });
  }catch (e)
    {
      setState((){
        _counter = 'Error: $e';
    });
    };
  }

  Future addToWL(String i) async {
    try
        {
          final w = Wishlist();
          await w.addToWishlist(i);

        }catch (e)
    {
      setState((){
        _counter = 'error in add: $e';
      });
    }
  }

  Future<void> removeFromWL(String i) async{
    try{
      final w = Wishlist();
      await w.removeFromWishlist(i);
    }catch(e)
    {
      setState((){
        _counter = 'error in remove: $e';
      });
    }
  }

  Future<void> editProfile() async
  {
    try{
      FirebaseFirestore db = FirebaseFirestore.instance;
      final data =  {"name": "Monika"};
      // do this for any fields you want to update
      await db.collection("profile_data").doc("svVm2V1l9YQCqJYH0y0Jpg3iapz2").update(data);
    }catch (e)
    {
      setState(() {
        _counter = "Error updating profile $e"; // Update counter with error message
      });
    }
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
        "username": {"profile_name": "","unique_num":1},
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
      final FirebaseAuth auth = FirebaseAuth.instance;
      User? currentUser;
      DocumentSnapshot qs = await profileRef.doc(auth.currentUser?.uid).get();

      if(qs.exists)
        {
          // access all data
            /*setState(() {
              _counter = "profile exists: ${qs.data()}";
            });*/
            print("profile exists: ${qs.data()}");
            //access specific data :
            Map<String,dynamic> d = qs.data() as Map<String,dynamic>;
            Map<String ,dynamic> user = d['username'] as Map<String, dynamic>;
            setState(() {
              _counter = "user exists: ${user['profile_name']}";
            });

        }else
          {
            setState(() {
              _counter = "Profile not found for user";
            });
            print("Profile not found for user ");
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