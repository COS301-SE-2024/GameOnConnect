import 'package:flutter/material.dart';
import 'package:gameonconnect/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomizeProfilePage extends StatefulWidget {
  const CustomizeProfilePage({super.key});

  @override
  CustomizeProfilePageObject createState() => CustomizeProfilePageObject();
}

class CustomizeProfilePageObject extends State<CustomizeProfilePage> {

  List<String> _genres = [];
  List<String> _selectedGenres = [];
  List<String> _selectedAge = [];
  List<String> _selectedInterests = [];
  List<String> _Interests = [];

  bool isDarkMode = false;

  Future<void> _fetchGenres() async {
    var url = Uri.parse('https://api.rawg.io/api/genres?key=2a10983b69914667a056ebcf6ea48151');
    var response = await http.get(url);
    var decoded = json.decode(response.body);

    setState(() {
      _genres = (decoded['results'] as List).map((genre) => genre['name'].toString()).toList();
    });
  }

  Future<void> _fetchTags() async {
  var url = Uri.parse('https://api.rawg.io/api/tags?key=2a10983b69914667a056ebcf6ea48151');
  var response = await http.get(url);
  var decoded = json.decode(response.body);

  setState(() {
    _Interests = (decoded['results'] as List).map((tag) => tag['name'].toString()).toList();
  });
}


  Future<void> _showSelectableDialog(String title, List<String> items,
      void Function(List<String>) onSelected) async {
    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SelectableDialog(title: title, items: items);
      },
    );

    if (results != null) {
      setState(() {
        onSelected(results);
      });
    }
  }

   Widget _displaySelectedItems(List<String> selectedItems, void Function(String) onDeleted) {
    return Wrap(
  spacing: 8.0, // Spacing between chips.
  children: selectedItems.map((item) => Chip(
    padding: EdgeInsets.symmetric(vertical: 2),
    label: Text(item),
    backgroundColor: Colors.grey[300], // Chip background color.
    shape: StadiumBorder(), // Rounded corners.
    side: BorderSide.none, // Remove border
    onDeleted: () => onDeleted(item), // Callback when the delete icon is tapped.
    deleteIcon: Icon(Icons.close, size: 16), // Close icon.
  )).toList(),
);

  }

  // Function to handle deletion of a selected item.
  void _deleteSelectedItem(String item, List<String> selectedList) {
    setState(() {
      selectedList.remove(item);
    });
  }

  @override
void initState() {
  super.initState();
  _fetchGenres(); // Call the fetch genres function here
   _fetchTags(); 
  isDarkMode = Provider.of<ThemeProvider>(context, listen: false).themeData.brightness == Brightness.dark; 
}

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: AppBar(
         leading:IconButton(
            icon: const Icon(Icons.keyboard_backspace),
            onPressed: () {
              Navigator.of(context).pop();
          },
        ),

          //logo
          title: CircleAvatar(
            radius: 25.0, // Doubled the radius
            backgroundColor: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 1.0),
              ),
            ),
          ),
        centerTitle: true,
      ),

      //body
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          //title
          const Align(
          alignment: Alignment.center,
           child: Text('Customize Profile', style: TextStyle(fontSize: 24)),   
          ),

          const SizedBox(height: 30),

          //profile picture
          Center(
            child: CircleAvatar(
              radius: 60,
               backgroundColor: Colors.grey[300],  
            ),
          ),

          //change profile picture
           const Align(
            alignment: Alignment.center,
            child: Text('Change picture', style: TextStyle(fontSize: 18)),   
          ),

          const SizedBox(height: 30),

          //genre title
         Row(
                children: <Widget>[
                  const Align(
              alignment: Alignment.centerLeft,
              child: Text('Genre', style: TextStyle(fontSize: 15)), 
            ),
            const SizedBox(width: 20),
                // add button
                InkWell(
              onTap: () => _showSelectableDialog(
                'Select Genre',
                _genres, // Use the _genres list here
                (results) {
                  _selectedGenres = results;
                  setState(() {});
                },
              ),
      child: Container(
        padding: const EdgeInsets.all(5), // Adjust the padding to change the size
        decoration: BoxDecoration(
          color: Colors.grey[300], // Choose the color of the button
          shape: BoxShape.circle, // This makes the container circular
        ),
        child: const Icon(
          Icons.add, // The plus icon
          color: Colors.black, // Choose the color of the icon
          size: 12, // Adjust the size of the icon
        ),
      ),
    )
                ],
              ),

          const SizedBox(height: 8),
           _displaySelectedItems(_selectedGenres, (item) => _deleteSelectedItem(item, _selectedGenres)),

            const SizedBox(height: 15),
            //const SizedBox(height: 45),

             // age rating title
             Row(
                children: <Widget>[
                  const Align(
              alignment: Alignment.centerLeft,
              child: Text('Age rating ', style: TextStyle(fontSize: 15)), 
            ),
            const SizedBox(width: 20),
                // add button
                InkWell(
      onTap: () => _showSelectableDialog(
                'Select Age rating',
                ['rating1', 'rating2', 'rating3', 'rating4'],
                (results) {
                  _selectedAge = results;
                  // Call setState to update the UI with the selected items.
                  setState(() {});
                },
              ),
      child: Container(
        padding: const EdgeInsets.all(5), // Adjust the padding to change the size
        decoration: BoxDecoration(
          color: Colors.grey[300], // Choose the color of the button
          shape: BoxShape.circle, // This makes the container circular
        ),
        child: const Icon(
          Icons.add, // The plus icon
          color: Colors.black, // Choose the color of the icon
          size: 12, // Adjust the size of the icon
        ),
      ),
    ),
                ],
              ),
              const SizedBox(height: 8),
                  _displaySelectedItems(_selectedAge, (item) => _deleteSelectedItem(item, _selectedAge)),

            const SizedBox(height: 15),


            // social interest title
          
             Row(
                children: <Widget>[
                  const Align(
              alignment: Alignment.centerLeft,
              child: Text('Social interests ', style: TextStyle(fontSize: 15)), 
            ),
            const SizedBox(width: 20),
                // add button
                InkWell(
      /*onTap: () => _showSelectableDialog(
                'Select Social interest',
                ['interest1', 'interest2', 'interest3', 'interest4'],
                (results) {
                  _selectedInterests = results;
                  // Call setState to update the UI with the selected items.
                  setState(() {});
                },
              ),*/
               onTap: () => _showSelectableDialog(
                'Select Social interest',
                _Interests, // Use the _genres list here
                (results) {
                  _selectedInterests = results;
                  setState(() {});
                },
              ),
      child: Container(
        padding: const EdgeInsets.all(5), // Adjust the padding to change the size
        decoration: BoxDecoration(
          color: Colors.grey[300], // Choose the color of the button
          shape: BoxShape.circle, // This makes the container circular
        ),
        child: const Icon(
          Icons.add, // The plus icon
          color: Colors.black, // Choose the color of the icon
          size: 12, // Adjust the size of the icon
        ),
      ),
    )
                ],
              ),  
                  
            

            const SizedBox(height: 8),
            _displaySelectedItems(_selectedInterests, (item) => _deleteSelectedItem(item, _selectedInterests)),



            // DARK MODE
            const SizedBox(height: 20),

            Row(
              children: <Widget>[
                // title
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Dark mode:', style: TextStyle(fontSize: 15)),
              ),

            const SizedBox(width: 20),
            //Spacer(), 

            // switch 
            Switch(
              value: isDarkMode,
              onChanged: (newValue) {
                setState(() {
                  isDarkMode = newValue;
                });
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
              },
            ),
          ],
        ),
            

            //save button
            const SizedBox(height: 40.0),
            Center(
              child: ElevatedButton(
                key: const Key('saveButton'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black54,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                    //  update database
                },
                child: const Text('Save Changes'),
              ),
            ),

        ]
      ),
    );
  }
}


class CustomButtons extends StatelessWidget {
  final String text;
  const CustomButtons({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text),
              const SizedBox(width: 8), // Space between text and icon
              GestureDetector(
                onTap: () {
                  // 
                },
                child: const Icon(
                  Icons.close, // Cross icon for close
                  size: 16.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(5), // Adjust the padding to change the size
        decoration: BoxDecoration(
          color: Colors.grey[300], // Choose the color of the button
          shape: BoxShape.circle, // This makes the container circular
        ),
        child: const Icon(
          Icons.add, // The plus icon
          color: Colors.black, // Choose the color of the icon
          size: 12, // Adjust the size of the icon
        ),
      ),
    );
  }
}



// Generic SelectableDialog widget.
class SelectableDialog extends StatefulWidget {
  final String title;
  final List<String> items;

  const SelectableDialog({Key? key, required this.title, required this.items})
      : super(key: key);

  @override
  _SelectableDialogState createState() => _SelectableDialogState();
}

class _SelectableDialogState extends State<SelectableDialog> {
  List<String> _selectedItems = [];
  
   void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    Navigator.pop(context, _selectedItems);
    // seend to the database 
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    value: _selectedItems.contains(item),
                    title: Text(item),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }

 
}


