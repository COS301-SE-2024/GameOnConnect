import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  List<String> _interests = [];

  bool isDarkMode = false;
  bool _isDataFetched = false; 

  /*Future<void> _fetchGenresFromAPI() async {
    var url = Uri.parse('https://api.rawg.io/api/genres?key=b8d81a8e79074f1eb5c9961a9ffacee6');
    var response = await http.get(url);
    var decoded = json.decode(response.body);

    setState(() {
      _genres = (decoded['results'] as List).map((genre) => genre['name'].toString()).toList();
    });
  }*/
  Future<void> _fetchGenresFromAPI() async {
  print("Fetching genres started");
  try {
    var url = Uri.parse('https://api.rawg.io/api/genres?key=b8d81a8e79074f1eb5c9961a9ffacee6');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      setState(() {
        _genres = (decoded['results'] as List).map((genre) => genre['name'].toString()).toList();
      });
      print("Genres fetched successfully");
    } else {
      print("Error fetching genres: ${response.statusCode}");
    }
  } catch (e) {
    print("Error fetching genres: $e");
  }
}


 /* Future<void> _fetchTagsFromAPI() async {
  var url = Uri.parse('https://api.rawg.io/api/tags?key=b8d81a8e79074f1eb5c9961a9ffacee6');
  var response = await http.get(url);
  var decoded = json.decode(response.body);

  setState(() {
    _interests = (decoded['results'] as List).map((tag) => tag['name'].toString()).toList();
  });
}*/
Future<void> _fetchTagsFromAPI() async {
  print("Fetching tags started");
  try {
    var url = Uri.parse('https://api.rawg.io/api/tags?key=b8d81a8e79074f1eb5c9961a9ffacee6');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      setState(() {
        _interests = (decoded['results'] as List).map((tag) => tag['name'].toString()).toList();
      });
      print("Tags fetched successfully");
    } else {
      print("Error fetching tags: ${response.statusCode}");
    }
  } catch (e) {
    print("Error fetching tags: $e");
  }
}


  /*Future<void> _showSelectableDialog(String title, List<String> items,
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
  }*/

   Widget _displaySelectedItems(List<String> selectedItems, void Function(String) onDeleted) {
    return Wrap(
  spacing: 8.0, // Spacing between chips.
  children: selectedItems.map((item) => Chip(
    padding: const EdgeInsets.symmetric(vertical: 2),
    label: Text(item),
    backgroundColor: Colors.grey[300], // Chip background color.
    shape: const StadiumBorder(), // Rounded corners.
    side: BorderSide.none, // Remove border
    onDeleted: () => onDeleted(item), // Callback when the delete icon is tapped.
    deleteIcon: const Icon(Icons.close, size: 16), // Close icon.
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
  //_fetchGenresFromAPI(); // Call the fetch genres function here
   //_fetchTagsFromAPI(); 
   //_fetchUserSelectionsFromDatabase();
   _fetchData().then((_) {
      setState(() {
        _isDataFetched = true;  // Mark data as fetched
      });
    });
  isDarkMode = Provider.of<ThemeProvider>(context, listen: false).themeData.brightness == Brightness.dark; 
}

 /*Future<void> _saveProfileData() async {
  try {
  final FirebaseAuth auth = FirebaseAuth.instance;
    final currentUser = auth.currentUser;

    if (currentUser != null) {
      final db = FirebaseFirestore.instance;
      final profileDocRef = db.collection("profile_data").doc(currentUser.uid);

      // Data to be set or updated
      final data = {
        "genre_interests_tags": _selectedGenres.isNotEmpty ? _selectedGenres : FieldValue.delete(),
        "age_rating_tag": _selectedAge.isNotEmpty ? _selectedAge : FieldValue.delete(),
        "social_interests_tags": _selectedInterests.isNotEmpty ? _selectedInterests : FieldValue.delete(),
      };

      // Use set with merge to create or update the document
      await profileDocRef.set(data, SetOptions(merge: true));
      //print("Profile data set/updated successfully!");
    }
  } catch (e) {
    //print("Error setting/updating profile data: $e");
  }
}*/

/*Future<void> _saveProfileData() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;

      if (currentUser != null) {
        final db = FirebaseFirestore.instance;
        final profileDocRef = db.collection("profile_data").doc(currentUser.uid);

        final data = {
          "genre_interests_tags": _selectedGenres.isNotEmpty ? _selectedGenres : FieldValue.delete(),
          "age_rating_tag": _selectedAge.isNotEmpty ? _selectedAge : FieldValue.delete(),
          "social_interests_tags": _selectedInterests.isNotEmpty ? _selectedInterests : FieldValue.delete(),
        };

        await profileDocRef.set(data, SetOptions(merge: true));
      }
    } catch (e) {
      print("Error setting/updating profile data: $e");
    }
  }*/

Future<void> _fetchUserSelectionsFromDatabase() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;

      if (currentUser != null) {
        final db = FirebaseFirestore.instance;
        final profileDocRef = db.collection("profile_data").doc(currentUser.uid);

        final docSnapshot = await profileDocRef.get();
        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          setState(() {
            _selectedGenres = List<String>.from(data?["genre_interests_tags"] ?? []);
            _selectedAge = List<String>.from(data?["age_rating_tag"] ?? []);
            _selectedInterests = List<String>.from(data?["social_interests_tags"] ?? []);
          });
        }
      }
    } catch (e) {
      print("Error fetching user selections: $e");
    }
  }

Future<void> _fetchData() async {
   print("Fetching data started");
    await _fetchUserSelectionsFromDatabase();
    await Future.wait([_fetchGenresFromAPI(), _fetchTagsFromAPI()]);
    print("Fetching data completed");
}

 @override
Widget build(BuildContext context) {
    if (!_isDataFetched) {
      // Show loading indicator while data is being fetched
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.keyboard_backspace),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: CircleAvatar(
            radius: 25.0,
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
        body: const Center(child: CircularProgressIndicator()),
      );
    } else {
      // Show the main content once data is fetched
      return _buildContent(context);
    }
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: CircleAvatar(
          radius: 25.0,
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Align(
            alignment: Alignment.center,
            child: Text('Customize Profile', style: TextStyle(fontSize: 24)),
          ),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                height: 170,
                width: double.infinity,
                color: Colors.grey[300],
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: FloatingActionButton(
                  onPressed: () {
                    // TODO: Implement the functionality to edit the banner picture
                  },
                  child: const Icon(Icons.edit),
                  mini: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Center(
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[300],
            ),
          ),
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
                    _genres,
                    (results) {
                      _selectedGenres = results;
                      setState(() {});
                    },
                    'genre',
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
              ['PEGI 3', 'PEGI 7', 'PEGI 12', 'PEGI 16','PEGI 18' ],
              (results) {
                _selectedAge = results;
                setState(() {});
              },
              'age',
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
                onTap: () =>_showSelectableDialog(
                'Select Social interest',
                _interests,
                (results) {
                  _selectedInterests = results;
                  setState(() {});
                },
                'interest',
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


          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Dark mode:', style: TextStyle(fontSize: 15)),
              ),
              const SizedBox(width: 20),
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
                _saveProfileData();
                Navigator.of(context).pop();
              },
              child: const Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }

  /*Widget _buildSelectableSection(String title, List<String> items, List<String> selectedItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(title, style: const TextStyle(fontSize: 15)),
            ),
            const SizedBox(width: 20),
            InkWell(
              onTap: () => _showSelectableDialog(
                'Select $title',
                items,
                (results) {
                  setState(() {
                    selectedItems.clear();
                    selectedItems.addAll(results);
                  });
                },
              ),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 12,
                ),
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 8.0,
          children: selectedItems.map((item) {
            return Chip(
              label: Text(item),
              onDeleted: () {
                setState(() {
                  selectedItems.remove(item);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }*/

 Future<void> _showSelectableDialog(
  String title, List<String> items, Function(List<String>) onSelected, String selectionType) async {
  List<String> selectedItems = [];

  switch (selectionType) {
    case 'genre':
      selectedItems.addAll(_selectedGenres);
      break;
    case 'age':
      selectedItems.addAll(_selectedAge);
      break;
    case 'interest':
      selectedItems.addAll(_selectedInterests);
      break;
    default:
      break;
  }
  
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: items.map((item) {
                  return CheckboxListTile(
                    value: selectedItems.contains(item),
                    title: Text(item),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool? isChecked) {
                      setState(() {
                        if (isChecked == true) {
                          selectedItems.add(item);
                        } else {
                          selectedItems.remove(item);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Select'),
                onPressed: () {
                  Navigator.of(context).pop(selectedItems);
                },
              ),
            ],
          );
        },
      );
    },
  );

  if (selectedItems.isNotEmpty) {
    onSelected(selectedItems);
  }
}

 
  void _saveProfileData() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final currentUser = auth.currentUser;
    if (currentUser != null) {
      final db = FirebaseFirestore.instance;
      final profileDocRef = db.collection("profile_data").doc(currentUser.uid);

      await profileDocRef.set({
        "genre_interests_tags": _selectedGenres,
        "age_rating_tag": _selectedAge,
        "social_interests_tags": _selectedInterests,
      });
    }
  }
}