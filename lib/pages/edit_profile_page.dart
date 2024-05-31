import 'package:flutter/material.dart';

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

class EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();

  DateTime _birthday = DateTime.now();
  bool _isPrivate = false;

  @override
  Widget build(BuildContext context) {
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
                  _buildTextInput('Username:', key: const Key('usernameField')),
                  _buildTextInput('First Name:', key: const Key('firstNameField')),
                  _buildTextInput('Last Name:', key: const Key('lastNameField')),
                  _buildTextInput('Bio:', maxLines: 3, key: const Key('bioField')),
                  _buildDateInput('Birthday:', key: const Key('birthdayField')),
                  _buildSwitchInput(
                    'Private Account:',
                    (value) {
                      setState(() {
                        _isPrivate = value;
                      });
                    },
                    key: const Key('privateAccountSwitch'),
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
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInput(String label, {int maxLines = 1, Key? key}) {
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
}
