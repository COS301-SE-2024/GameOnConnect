import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatelessWidget {
  // ignore: use_super_parameters
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: CircleAvatar(
          key: const Key('profileAvatar'),
          radius: 25.0, // Doubled the radius
          backgroundColor: Colors.black,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2.0),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: const EditProfileForm(),
    );
  }
}

class EditProfileForm extends StatefulWidget {
  // ignore: use_super_parameters
  const EditProfileForm({Key? key}) : super(key: key);

  @override
  EditProfileFormState createState() => EditProfileFormState();
}

class  EditProfileFormState  extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();

  String _username = "";
  String _firstName = "";
  String _lastName = "";
  String _bio = "";
  DateTime _birthday = DateTime.now();
  bool _isPrivate = false;


 /* Future<void> databaseAccess() async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      CollectionReference profileRef = db.collection("profile_data");
      final FirebaseAuth auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot qs = await profileRef.doc(currentUser.uid).get();
        if (qs.exists) {
          //access specific data :
          Map<String, dynamic> d = qs.data() as Map<String, dynamic>;
          print(d['name']);
          _username = d['username.profile_name'];
          print(_username);
          _firstName = d['name'];
          _lastName = d['surname'];
          _bio = d['bio'];
          _birthday = d['birthday'];
          _isPrivate = d['visibility'];
        }
      }
    } catch (e) {   }
  }*/

  @override
  Widget build(BuildContext context) {
    //databaseAccess();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 16.0),
            const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32.0), // Increased space between header and inputs
            Expanded(
              child: ListView(
                children: [
                  _buildTextInput('Username:', (value) => _username = value ?? '', key: const Key('usernameField')),
                  _buildTextInput('First Name:', (value) => _firstName = value ?? '', key: const Key('firstNameField')),
                  _buildTextInput('Last Name:', (value) => _lastName = value ?? '', key: const Key('lastNameField')),
                  _buildTextInput('Bio:', (value) => _bio = value ?? '', maxLines: 3, key: const Key('bioField')),
                  _buildDateInput('Birthday:', key: const Key('birthdayField')),
                  _buildSwitchInput('Private Account:', (value) {
                    setState(() {
                      _isPrivate = value;
                    });
                  }, key: const Key('privateAccountSwitch'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[400],
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    _formKey.currentState?.save();
                    // Handle save logic here
                    editProfile(_username,_firstName,_lastName,_bio,_birthday, _isPrivate).then((_) {
                      Navigator.of(context).pop();
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to update profile: $error'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    });
                  }
                },
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInput(String label, void Function(String?)? onSaved, {int maxLines = 1, required Key key}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(label),
          ),
          Expanded(
            flex: 4,
            child: TextFormField(
              key: key,
              onChanged: onSaved,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                fillColor: Colors.grey[400],
                filled: true,
              ),
              maxLines: maxLines,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInput(String label, {Key? key}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(label),
          ),
          Expanded(
            flex: 4,
            child: InkWell(
              key: key,
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if (picked != null && picked != _birthday) {
                  setState(() {
                    _birthday = picked;
                  });
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  fillColor: Colors.grey[400],
                  filled: true,
                ),
                child: Text(
                  _birthday.toLocal().toString().split(' ')[0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchInput(String label, Function(bool) onChanged, {Key? key}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(label),
          ),
          Expanded(
            flex: 4,
            child: Switch(
              key: key,
              value: _isPrivate,
              onChanged: onChanged,
              activeColor: Colors.black,
              inactiveTrackColor: Colors.grey,
              inactiveThumbColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
  Future<void> editProfile(String username,String firstname, String lastName, String bio, DateTime birthday,bool privacy) async
  {
    try{
      FirebaseFirestore db = FirebaseFirestore.instance;
      final FirebaseAuth auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;
      if (currentUser != null) {
        if (username.isNotEmpty) {
          final data = { "username.profile_name" :username};
          await db.collection("profile_data").doc(currentUser.uid).update(data);
        }
        if(firstname.isEmpty)
        {
            final data = { "name" :firstname};
            await db.collection("profile_data").doc(currentUser.uid).update(data);
        }
        if (lastName.isNotEmpty) {
          final data = { "surname" :lastName};
          await db.collection("profile_data").doc(currentUser.uid).update(data);
        }
        if (bio.isNotEmpty){
          final data = { "bio" :bio};
          await db.collection("profile_data").doc(currentUser.uid).update(data);
        }
        final data = { "birthday" :birthday,"visibility":privacy };
        await db.collection("profile_data").doc(currentUser.uid).update(data);

      }
    }catch (e)
    {
      throw Exception('Error updating profile: $e');
      /*setState(() {
        _counter = "Error updating profile $e"; // Update counter with error message
      });*/
    }
  }

}
