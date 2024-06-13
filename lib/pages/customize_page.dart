import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gameonconnect/theme/theme_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io' if (dart.library.html) 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
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
  //File? _profileImage;

  //profile picture 
  Uint8List? _profileImageBytes;
  String _profileImageUrl=''; // URL of the image stored in Firebase
  dynamic _profileImage;
Uint8List? _profileImageWeb;
String? _profileImageFB;
String testBannerurl='';

//profile banner
String _profileBannerUrl=''; // URL of the image stored in Firebase
  dynamic _profileBanner;
  String? _profileBannerFB;


  Future<void> _fetchGenresFromAPI() async {
  //("Fetching genres started");
  try {
    var url = Uri.parse('https://api.rawg.io/api/genres?key=b8d81a8e79074f1eb5c9961a9ffacee6');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      setState(() {
        _genres = (decoded['results'] as List).map((genre) => genre['name'].toString()).toList();
      });
      //print("Genres fetched successfully");
    } else {
      //print("Error fetching genres: ${response.statusCode}");
    }
  } catch (e) {
    //print("Error fetching genres: $e");
  }
}

Future<void> _fetchTagsFromAPI() async {
  //print("Fetching tags started");
  try {
    var url = Uri.parse('https://api.rawg.io/api/tags?key=b8d81a8e79074f1eb5c9961a9ffacee6');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      setState(() {
        _interests = (decoded['results'] as List).map((tag) => tag['name'].toString()).toList();
      });
      //print("Tags fetched successfully");
    } else {
      //print("Error fetching tags: ${response.statusCode}");
    }
  } catch (e) {
    //print("Error fetching tags: $e");
  }
}


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
          setState(() async {
            _selectedGenres = List<String>.from(data?["genre_interests_tags"] ?? []);
            _selectedAge = List<String>.from(data?["age_rating_tag"] ?? []);
            _selectedInterests = List<String>.from(data?["social_interests_tags"] ?? []);
             _profileImageUrl = data?["profile_picture"] ?? '';
             print("Fetched image from Firebase: $_profileImageUrl");
             
             _profileBannerUrl = data?["banner"] ?? '';
              print("Fetched banner from Firebase: $_profileBannerUrl");

        //new code 
        
        String downloadUrl = await FirebaseStorage.instance.refFromURL(_profileBannerUrl).getDownloadURL();
        setState(() {
          testBannerurl = downloadUrl;
        });
              

          });
        }
      }
    } catch (e) {
     // print("Error fetching user selections: $e");
    }
  }

Future<void> _fetchData() async {
   //print("Fetching data started");
    await _fetchUserSelectionsFromDatabase();
    //await Future.wait([_fetchGenresFromAPI(), _fetchTagsFromAPI()]);
    //print("Fetching data completed");
}


//NEW CODE
Future<void> _pickImage() async {
  if (kIsWeb) {
    // Web implementation
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      PlatformFile file = result.files.first;
      if (file.bytes != null) {
        setState(() {
          _profileImage = (file.bytes!, file.name);
          _profileImageFB = file.name;
        });
      }
      print("picked image and image updated ");
    }
  } else {
    // Mobile/desktop implementation
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
         print("picked image and image updated ");
      });
    }
  }
}

Future<void> _pickBanner() async {
  if (kIsWeb) {
    // Web implementation
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      PlatformFile file = result.files.first;
      if (file.bytes != null) {
        setState(() {
          _profileBanner = (file.bytes!, file.name);
          _profileBannerFB = file.name;
        });
      }
      print("picked banner and  updated ");
    }
  } else {
    // Mobile/desktop implementation
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileBanner = File(image.path);
        testBannerurl= _profileBanner!.path;
         print("picked banner and  updated ");
      });
    }
  }
}

 

//FILE PICKER
/*Future<String> FileToFirebase(Uint8List data, String fileName) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  Reference storageReference = FirebaseStorage.instance.ref().child('profile_pictures/$uid/$fileName');
  UploadTask uploadTask = storageReference.putData(data);
  await uploadTask.whenComplete(() => null);
  String downloadURL = await storageReference.getDownloadURL();
  return downloadURL;
}*/

Future<String> uploadImageToFirebase(File image,String imagetype) async {
  // Get the user's UID
  String uid = FirebaseAuth.instance.currentUser!.uid;
  
  // Create a reference to Firebase Storage
  if(imagetype=='Profile_picture')
  {
    Reference storageReference = FirebaseStorage.instance.ref().child('profile_pictures/$uid.jpg');
    // Upload the file
    UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.whenComplete(() => null);
    
    // Get the download URL
    String downloadURL = await storageReference.getDownloadURL();
    return downloadURL;
    }
  else
  {
    Reference storageReference = FirebaseStorage.instance.ref().child('banners/$uid.jpg');
    // Upload the file
    UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.whenComplete(() => null);
    
    // Get the download URL
    String downloadURL = await storageReference.getDownloadURL();
     await FirebaseFirestore.instance.collection("profile_data").doc(uid).update({
    'banner': downloadURL,
    
  });
     setState(() {
        testBannerurl=downloadURL;
      });
    return downloadURL;
  }
  
}


//only when the user clicks on the save button -----------------
Future<void> saveImageURL(String url, String imageType) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  if(imageType=='Profile_picture')
  {
    await FirebaseFirestore.instance.collection("profile_data").doc(uid).update({
    'profile_picture': url,
    
  });
  print("Saved selected profile picture to Firebase: $url");
  }
  else
  {
    await FirebaseFirestore.instance.collection("profile_data").doc(uid).update({
    'banner': url,
    
  });
  print("Saved selected banner to Firebase: $url");
  }

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
         InkWell(
  onTap: _pickBanner,
  child: Stack(
    alignment: Alignment.center, // Change to Alignment.center
    children: [
      Container(
        width: double.infinity, // Full width of the screen
        height: 150, // Adjust the height as needed
        //color: Colors.grey,
        //Uncomment and use the decoration property if you want to use an image
        decoration: BoxDecoration(
          image: DecorationImage(
              //image: NetworkImage(testBannerurl),
               image: _profileBanner != null ? FileImage(_profileBanner!) 
               : NetworkImage(testBannerurl) as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
       
      ),
      Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.camera_alt,
          size: 15,
          // Uncomment and set a color if you want to change the icon color
          //color: Colors.white,
        ),
      ),
    ],
  ),
),
          
          const SizedBox(height: 30),
         // profile picture user can change 
          Center( // Wrap with Center widget to align the circle in the center
      child: InkWell(
        //onTap: onProfileTapped,
        onTap: _pickImage,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey,
              //backgroundImage: NetworkImage(profilePicture),
              //backgroundImage: _profileImageUrl != '' ? NetworkImage(_profileImageUrl) : NetworkImage('https://th.bing.com/th/id/OIP.W7SwNSuA3OfLVlwh7euftgHaHk?pid=ImgDet&w=474&h=484&rs=1') as ImageProvider,
 backgroundImage: _profileImage != null
               ? (kIsWeb ? NetworkImage(_profileImage!.path) : FileImage(_profileImage!)) as ImageProvider
              : _profileImageUrl != ''
                  ? NetworkImage(_profileImageUrl)as ImageProvider
                  : NetworkImage('https://th.bing.com/th/id/OIP.W7SwNSuA3OfLVlwh7euftgHaHk?pid=ImgDet&w=474&h=484&rs=1') as ImageProvider,
              
            ),
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.camera_alt,
                size: 15,
                //color: Colors.white,
              ),
            ),
          ],
        ),
      ),
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

            const SizedBox(height: 20),
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

            const SizedBox(height: 20),

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
  try {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final currentUser = auth.currentUser;

    if (currentUser != null) {
      final db = FirebaseFirestore.instance;
      final profileDocRef = db.collection("profile_data").doc(currentUser.uid);

      // Save image if there is a new one
      if (_profileImage != null) {
        // Upload the image to Firebase Storage
        String imageUrl;
        if (kIsWeb) {
          imageUrl = await uploadImageToFirebase(_profileImage!,'Profile_picture');
        } else {
          imageUrl = await uploadImageToFirebase(_profileImage!,'Profile_picture');
        }

        // Save the download URL to Firestore
        await saveImageURL(imageUrl,'Profile_picture');

        // Show a confirmation message or navigate
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture updated')),
        );
      }

      // Save banner if there is a new one
      if (_profileBanner != null) {
        // Upload the image to Firebase Storage
        String bannerUrl;
        if (kIsWeb) {
          bannerUrl = await uploadImageToFirebase(_profileBanner!,'banner');
        } else {
          bannerUrl = await uploadImageToFirebase(_profileBanner!,'banner');
        }

        // Save the download URL to Firestore
        //await saveImageURL(bannerUrl,'banner');

        // Show a confirmation message or navigate
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('banner updated')),
        );
      }

      // Data to be set or updated
      final data = {
        "genre_interests_tags": _selectedGenres.isNotEmpty ? _selectedGenres : FieldValue.delete(),
        "age_rating_tag": _selectedAge.isNotEmpty ? _selectedAge : FieldValue.delete(),
        "social_interests_tags": _selectedInterests.isNotEmpty ? _selectedInterests : FieldValue.delete(),
      };

      // Use set with merge to create or update the document
      await profileDocRef.set(data, SetOptions(merge: true));
      print("Profile data set/updated successfully!");
    }
  } catch (e) {
    print("Error setting/updating profile data: $e");
  }
}




}