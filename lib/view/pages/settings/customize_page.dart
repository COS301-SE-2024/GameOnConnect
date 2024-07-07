 // ignore_for_file: avoid_print, use_build_context_synchronously

 import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gameonconnect/view/theme/theme_provider.dart';
import 'package:image_picker/image_picker.dart';
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
  String _profileImageUrl=''; 
  dynamic _profileImage;
String _profileBannerUrl=''; 
  dynamic _profileBanner;
  String testBannerurl='';


  Future<void> _fetchGenresFromAPI() async {
  try {
    var url = Uri.parse('https://api.rawg.io/api/genres?key=b8d81a8e79074f1eb5c9961a9ffacee6');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      setState(() {
        _genres = (decoded['results'] as List).map((genre) => genre['name'].toString()).toList();
      });
    } else {
      print("Error fetching genres: ${response.statusCode}");
    }
  } catch (e) {
    print("Error fetching genres: $e");
  }
}

Future<void> _fetchTagsFromAPI() async {
  try {
    var url = Uri.parse('https://api.rawg.io/api/tags?key=b8d81a8e79074f1eb5c9961a9ffacee6');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      setState(() {
        _interests = (decoded['results'] as List).map((tag) => tag['name'].toString()).toList();
      });
    } else {
      print("Error fetching interest tags: ${response.statusCode}");
    }
  } catch (e) {
    print("Error fetching interest tags: $e");
  }
}


  Widget _displaySelectedItems(
      List<String> selectedItems, void Function(String) onDeleted) {
    return Wrap(

  spacing: 8.0, 
  children: selectedItems.map((item) => Chip(
    padding: const EdgeInsets.symmetric(vertical: 2),
    label: Text(item),
    backgroundColor: Theme.of(context).colorScheme.primary,
    shape: const StadiumBorder(), 
    side: BorderSide.none, 
    onDeleted: () => onDeleted(item), 
    deleteIcon: const Icon(Icons.close, size: 16), 
  )).toList(),
);

  }

  //deletion of a selected item.
  void _deleteSelectedItem(String item, List<String> selectedList) {
    setState(() {
      selectedList.remove(item);
    });
  }

  @override
void initState() {
  super.initState();
   _fetchData().then((_) {
      setState(() {
        _isDataFetched = true; 
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
        final genres = List<String>.from(data?["genre_interests_tags"] ?? []);
        final age = List<String>.from(data?["age_rating_tag"] ?? []);
        final interests = List<String>.from(data?["social_interests_tags"] ?? []);
        final profileImageUrl = data?["profile_picture"] ?? '';
        final profileBannerUrl = data?["banner"] ?? '';

        String? bannerDownloadUrl;
        String? profileDownloadUrl;

        if (profileBannerUrl.isNotEmpty) {
          bannerDownloadUrl = await FirebaseStorage.instance.refFromURL(profileBannerUrl).getDownloadURL();
        }
        if (profileImageUrl.isNotEmpty) {
          profileDownloadUrl = await FirebaseStorage.instance.refFromURL(profileImageUrl).getDownloadURL();
        }

        setState(() {
          _selectedGenres = genres;
          _selectedAge = age;
          _selectedInterests = interests;
          _profileBannerUrl = bannerDownloadUrl ?? '';
          _profileImageUrl = profileDownloadUrl ?? '';
        });
      }
    }
  } catch (e) {
    print("Error fetching user selections: $e");
  }
}


Future<void> _fetchData() async {
    await _fetchUserSelectionsFromDatabase();
    await Future.wait([_fetchGenresFromAPI(), _fetchTagsFromAPI()]);
}

Future<void> _pickImage() async {
  if (kIsWeb) {
    // Web implementation
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      PlatformFile file = result.files.first;
      if (file.bytes != null) {
        setState(() {
          _profileImage = (file.bytes!, file.name);
        });
      }
      //print("picked image and image updated ");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image selected successfully.')),
        );
    }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to select Image.')),
        );
    }
  } else {
    // Mobile/desktop implementation
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
         print("picked image and image updated ");
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image selected successfully.')),
        );
    }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to select Image.')),
        );
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
          //_profileBannerFB = file.name;
        });
        
      }
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image selected successfully.')),
        );
    }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to select Image.')),
        );
    }
  } else {
    // Mobile/desktop implementation
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileBanner = File(image.path);
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image selected successfully.')),
        );
    }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to select Image.')),
        );
    }
  }
}


Future<String> uploadImageToFirebase(File image,String imagetype) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  // Create a reference to Firebase Storage
  if(imagetype=='Profile_picture')
  {
    Reference storageReference = FirebaseStorage.instance.ref().child('profile_pictures/$uid.jpg');
    UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.whenComplete(() => null);
    
    String downloadURL = await storageReference.getDownloadURL();
    return downloadURL;
    }
  else
  {
    Reference storageReference = FirebaseStorage.instance.ref().child('banners/$uid.jpg');
    UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.whenComplete(() => null);
    
    String downloadURL = await storageReference.getDownloadURL();
     await FirebaseFirestore.instance.collection("profile_data").doc(uid).update({
    'banner': downloadURL,
    
  });
     /*setState(() {
        testBannerurl=downloadURL;
      });*/
    return downloadURL;
  }
  
}

Future<void> saveImageURL(String url, String imageType) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  if(imageType=='Profile_picture')
  {
    await FirebaseFirestore.instance.collection("profile_data").doc(uid).update({
    'profile_picture': url,
    
  });
  }
  else
  {
    await FirebaseFirestore.instance.collection("profile_data").doc(uid).update({
    'banner': url,
    
  });
  }

}

/*void _showSnackbar(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
    ),
  );
}*/


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
    width: double.infinity,
    height: 150,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: _profileBanner != null
          ? (kIsWeb ? NetworkImage(_profileBanner!.path) : FileImage(_profileBanner!)) as ImageProvider
          : _profileBannerUrl.isNotEmpty
            ? NetworkImage(_profileBannerUrl) as ImageProvider
            : const NetworkImage('https://th.bing.com/th/id/OIP.W7SwNSuA3OfLVlwh7euftgHaHk?pid=ImgDet&w=474&h=484&rs=1') as ImageProvider,
        fit: BoxFit.cover,
      ),
    ),
  ),
      Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.camera_alt,
          size: 15,

        ),
      ),
    ],
  ),
),
          
          const SizedBox(height: 30),
          Center( 
      child: InkWell(
        onTap: _pickImage,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
          radius: 60,
          backgroundColor: Theme.of(context).colorScheme.primary,
          backgroundImage: _profileImage != null
            ? (kIsWeb ? NetworkImage(_profileImage!.path) : FileImage(_profileImage!)) as ImageProvider
            : _profileImageUrl.isNotEmpty
              ? NetworkImage(_profileImageUrl) as ImageProvider
              : const NetworkImage('https://th.bing.com/th/id/OIP.W7SwNSuA3OfLVlwh7euftgHaHk?pid=ImgDet&w=474&h=484&rs=1') as ImageProvider,
        ),
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 15,
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
        padding: const EdgeInsets.all(5), 
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary, 
          shape: BoxShape.circle, 
        ),
        child: const Icon(
          Icons.add, 
          size: 12, 
        ),
      ),
    )
                ],
              ),

          const SizedBox(height: 8),
           _displaySelectedItems(_selectedGenres, (item) => _deleteSelectedItem(item, _selectedGenres)),

            const SizedBox(height: 20),

             // age rating title
             Row(
                children: <Widget>[
                  const Align(
              alignment: Alignment.centerLeft,
              child: Text('Age rating ', style: TextStyle(fontSize: 15)), 
            ),
            const SizedBox(width: 20),
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
        padding: const EdgeInsets.all(5), 
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary, 
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
        padding: const EdgeInsets.all(5), 
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle, 
        ),
        child: const Icon(
          Icons.add, 
          color: Colors.black, 
          size: 12, 
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
                backgroundColor: Theme.of(context).colorScheme.primary,
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
      if (_profileImage != null) {
        String imageUrl;
        if (kIsWeb) {
          imageUrl = await uploadImageToFirebase(_profileImage!,'Profile_picture');
        } else {
          imageUrl = await uploadImageToFirebase(_profileImage!,'Profile_picture');
        }

        await saveImageURL(imageUrl,'Profile_picture');

        // Show a confirmation message or navigate
        /*ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully.')),
        );*/

      }

      if (_profileBanner != null) {
        String bannerUrl;
        if (kIsWeb) {
          bannerUrl= await uploadImageToFirebase(_profileBanner!,'banner');
        } else {
          bannerUrl= await uploadImageToFirebase(_profileBanner!,'banner');
        }

        await saveImageURL(bannerUrl,'banner');

        // Show a confirmation message or navigate
       /*ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Banner updated successfully.')),
        );*/
      }

      final data = {
        "genre_interests_tags": _selectedGenres.isNotEmpty ? _selectedGenres : FieldValue.delete(),
        "age_rating_tag": _selectedAge.isNotEmpty ? _selectedAge : FieldValue.delete(),
        "social_interests_tags": _selectedInterests.isNotEmpty ? _selectedInterests : FieldValue.delete(),
      };

      await profileDocRef.set(data, SetOptions(merge: true));
      
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully.')),
        );
  
    }
  } catch (e) {
    print("Error setting/updating profile data: $e");
    ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile.'),backgroundColor: Colors.red),
        );
  }

}




}







