import 'package:flutter/material.dart';
import '../../components/settings/edit_input_text.dart';
import '../../components/settings/edit_date_input.dart';

import 'dart:io';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../../services/settings/edit_profile_service.dart' as editService;

class EditProfilePage extends StatefulWidget {
  // ignore: use_super_parameters
  const EditProfilePage({Key? key}) : super(key: key);

  State<EditProfilePage> createState() => _EditProfilePage();
}

class _EditProfilePage extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).colorScheme.secondary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
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
      await editService.editProfileService().editProfile(
          _username, _firstName, _lastName, _bio, _birthday!, _isPrivate);
    } catch (e) {
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
        future: editService.editProfileService().databaseAccess(),
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
                            maxLines: 1,
                            label: 'Username:',
                            onChanged: (value) => _username = value,
                            input: _username,
                          ),
                          EditInputText(
                            maxLines: 1,
                            label: 'First name:',
                            onChanged: (value) => _firstName = value,
                            input: _firstName,
                          ),
                          EditInputText(
                              maxLines: 1,
                              label: 'Last Name:',
                              onChanged: (value) => _lastName = value,
                              input: _lastName),
                          EditInputText(
                              maxLines: 3,
                              label: 'Bio:',
                              onChanged: (value) => _bio = value,
                              input: _bio),
                          EditDateInput(
                              currentDate: _birthday!,
                              label: 'Birthday:',
                              onChanged: (value) => {
                                _birthday = value
                          }),
                          _buildSwitchInput(
                            'Private Account:',
                            key: const Key('privateAccountSwitch'),
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

  Widget _buildSwitchInput(String label, {Key? key}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(label,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary)),
          ),
          Expanded(
            key: key,
            flex: 4,
            child: Switch.adaptive(
              value: _isPrivate,
              onChanged: (bool value) {
                setState(() {
                  _isPrivate = value;
                });
              },
              activeTrackColor: Theme.of(context).colorScheme.primary,
              inactiveTrackColor: Theme.of(context).colorScheme.surface,
              inactiveThumbColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
