import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget 
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: CircleAvatar(
          radius: 50.0,
          backgroundColor: Colors.white,
          center: true,
        ),
      ),
      body: EditProfileForm(),
    );
  }
}

class EditProfileForm extends StatefulWidget 
{
  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> 
{
  final _formKey = GlobalKey<FormState>();

  String _username = '';
  String _firstName = '';
  String _lastName = '';
  String _bio = '';
  DateTime _birthday = DateTime.now();
  bool _isPrivate = false;

  @override
  Widget build(BuildContext context) 
  {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            CircleAvatar(
              radius: 40.0,
              child: Icon(Icons.person, size: 40.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Edit Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            _buildTextInput('Username', (value) => _username = value ?? ''),
            _buildTextInput('First Name', (value) => _firstName = value ?? ''),
            _buildTextInput('Last Name', (value) => _lastName = value ?? ''),
            _buildTextInput('Bio', (value) => _bio = value ?? '', maxLines: 3),
            _buildDateInput('Birthday'),
            _buildSwitchInput('Private Account', (value) {
              setState(() {
                _isPrivate = value;
              });
            }),
            SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    _formKey.currentState?.save();
                    // Handle save logic here
                  }
                },
                child: Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInput(String label, void Function(String?)? onSaved, {int maxLines = 1}) {
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
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              fillColor: Colors.grey[200],
              filled: true,
            ),
            onSaved: onSaved,
            maxLines: maxLines,
          ),
        ),
      ],
    ),
  );
}


  Widget _buildDateInput(String label) {
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
                  border: OutlineInputBorder(),
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
                child: Text(
                  _birthday == null ? 'Select Date' : _birthday.toLocal().toString().split(' ')[0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchInput(String label, Function(bool) onChanged) {
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
