import 'package:flutter/material.dart';
import '../../components/settings/edit_input_text.dart';
import '../../components/settings/edit_date_input.dart';
import '../../components/settings/edit_switch.dart';
import 'package:gameonconnect/view/components/appbars/backbutton_appbar_component.dart';
import 'dart:io';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../../services/settings/edit_profile_service.dart' ;

class EditProfilePage extends StatefulWidget {
  // ignore: use_super_parameters
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePage();
}

class _EditProfilePage extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackButtonAppBar(
          title: 'Edit Profile',
          onBackButtonPressed: () {

            Navigator.pop(context);
          },
          iconkey: const Key('Back_button_key'),
          textkey: const Key('edit_profile_text'),
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

class EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _username = "";
  String _firstName = "";
  String _lastName = "";
  String _bio = "";
  DateTime? _birthday;
  late bool _isPrivate;

  void databaseAccess(Map<String, dynamic>? d) async {
    _username = d?['username']['profile_name'];
    _firstName = d?['name'];
    _lastName = d?['surname'];
    _bio = d?['bio'];
    _birthday = DateTime.parse(d!['birthday'].toDate().toString());
    _isPrivate = d['visibility'];
  }

  Future<void> _saveProfile() async {
    try {
      bool result = await InternetConnection().hasInternetAccess;
      if (result) {
        if (_formKey.currentState?.validate() == true) {
          _formKey.currentState?.save();
          editProfile();
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
        }
      } else {
        _showNoInternetSnackbar();
      }
    } on SocketException catch (_) {
      _showNoInternetSnackbar();
    }
  }

  void _showNoInternetSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No internet connection'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void editProfile() async {
    try {
      await EditProfileService().editProfile(
          _username, _firstName, _lastName, _bio, _birthday!, _isPrivate);
    } catch (e) {
      //ignore:  use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error updating profile'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
        future: EditProfileService().databaseAccess(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            databaseAccess(snapshot.data);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        children: [
                          EditInputText(
                            inputKey:  const Key('usernameField'),
                            maxLines: 1,
                            label: 'Username:',
                            onChanged: (value) => _username = value,
                            input: _username,
                          ),
                          EditInputText(
                            inputKey: const Key('firstNameField'),
                            maxLines: 1,
                            label: 'First name:',
                            onChanged: (value) => _firstName = value,
                            input: _firstName,
                          ),
                          EditInputText(
                            inputKey: const Key('lastNameField'),
                              maxLines: 1,
                              label: 'Last Name:',
                              onChanged: (value) => _lastName = value,
                              input: _lastName),
                          EditInputText(
                            inputKey: const Key('bioField'),
                              maxLines: 3,
                              label: 'Bio:',
                              onChanged: (value) => _bio = value,
                              input: _bio),
                          EditDateInput(
                              currentDate: _birthday!,
                              label: 'Birthday:',
                              onChanged: (value) => {_birthday = value}),
                          EditSwitch(
                            label: 'Private Account:',
                            currentValue: _isPrivate,
                            onChanged: (value) => {_isPrivate = value},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: _saveProfile,
                        child: const Text('Save Changes'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
