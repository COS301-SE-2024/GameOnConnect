import 'package:flutter/material.dart';
import 'package:gameonconnect/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomizeProfilePage extends StatefulWidget {
  const CustomizeProfilePage({super.key});

  @override
  CustomizeProfilePageObject createState() => CustomizeProfilePageObject();
}

class CustomizeProfilePageObject extends State<CustomizeProfilePage> {

  List<String> _selectedTopics = [];
  List<String> _selectedGenres = [];
  List<String> _selectedInterests = [];

  bool isDarkMode = false;

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
          const Align(
            alignment: Alignment.centerLeft,
            child:    Padding(
              padding: EdgeInsets.only(left: 30), 
              child: Text('Genre interests:', style: TextStyle(fontSize: 15)),
            ),
          ),

          const SizedBox(height: 8),

          // actual genres
           const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CustomButtons(text: 'genre1'),
                CustomButtons(text: 'genre2'),
                CustomButtons(text: 'genre3'),
              ],
            ),

            const SizedBox(height: 45),

             // age rating title
            const Align(
              alignment: Alignment.centerLeft,
              child:    Padding(
                padding: EdgeInsets.only(left: 30), 
                child: Text('Age ratings:', style: TextStyle(fontSize: 15)),
              ),
            ),

            const SizedBox(height: 8),

            //actual age ratings
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CustomButtons(text: 'Age rating1'),
                CustomButtons(text: 'Age rating2'),
                // add button 
                AddButton(),
              ],
            ),

            const SizedBox(height: 45),

            // social interest title
          
                  const Align(
              alignment: Alignment.centerLeft,
              child:    Padding(
                padding: EdgeInsets.only(left: 30), 
                child: Text('Social interests:', style: TextStyle(fontSize: 15)),
              ),
            ),
            

            const SizedBox(height: 8),

           //actual social interests
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CustomButtons(text: 'interest1'),
                CustomButtons(text: ' interest2'),

                // add button 
                //AddButton(),
              ],
            ),


            // DARK MODE
            const SizedBox(height: 40),

            Row(
              children: <Widget>[
                // title
              const Align(
                alignment: Alignment.centerLeft,
                child:    Padding(
                  padding: EdgeInsets.only(left: 30), 
                  child: Text('Dark mode:', style: TextStyle(fontSize: 15)),
                ),
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
      onTap: () {
        // 
      },
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


