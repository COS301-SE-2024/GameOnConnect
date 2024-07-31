// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gameonconnect/services/profile_S/storage_service.dart';
import 'package:gameonconnect/view/components/appbars/backbutton_appbar_component.dart';
import 'package:gameonconnect/view/theme/theme_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../services/settings/customize_service.dart';
import 'package:image_picker_web/image_picker_web.dart';

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
  String _profileImageUrl = '';
  dynamic _profileImage;
  String _profileBannerUrl = '';
  dynamic _profileBanner;
  String testBannerurl = '';

  Widget _displaySelectedItems(
      List<String> selectedItems, void Function(String) onDeleted) {
    return Wrap(
      spacing: 8.0,
      children: selectedItems
          .map((item) => Chip(
                padding: const EdgeInsets.symmetric(vertical: 2),
                label: Text(
                  item,
                  style: const TextStyle(color: Colors.black),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: const StadiumBorder(),
                side: BorderSide.none,
                onDeleted: () => onDeleted(item),
                deleteIcon: const Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.black,
                ),
              ))
          .toList(),
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
    isDarkMode = Provider.of<ThemeProvider>(context, listen: false)
            .themeData
            .brightness ==
        Brightness.dark;
  }


  Future<void> _fetchData() async {
    Map<String,dynamic> userSelection = await CustomizeService().fetchUserSelectionsFromDatabase();
    setState(() {
      _selectedGenres = userSelection['genres'];
      _selectedAge = userSelection['age'];
      _selectedInterests = userSelection['interests'];
      _profileBannerUrl = userSelection['bannerUrl'];
      _profileImageUrl = userSelection['profileUrl'];
    });
    await Future.wait([CustomizeService().fetchGenresFromAPI(), CustomizeService().fetchTagsFromAPI()]);
  }

  Future<void> _pickImage() async {

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = image.path;
        _profileImageUrl = "";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image selected successfully.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to select Image.')),
      );
    }
  }

  Future<void> _pickBanner() async {
    // Mobile/desktop implementation
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileBanner = image.path;
        _profileBannerUrl = "";
      });
      /*ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image selected successfully.')),
        );*/
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to select Image.')),
      );
    }
  }

  Future<String> uploadImageToFirebase(File image, String imagetype) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // Create a reference to Firebase Storage
    if (imagetype == 'Profile_picture') {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_pictures/$uid.jpg');
      UploadTask uploadTask;
      if(kIsWeb){
        uploadTask = storageReference.putFile(image );
        print("hellooooo");
      }else {
         uploadTask = storageReference.putFile(image);
      }
      //await uploadTask.whenComplete(() => null);

      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } else {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('banners/$uid.jpg');
      UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask.whenComplete(() => null);

      String downloadURL = await storageReference.getDownloadURL();
      await FirebaseFirestore.instance
          .collection("profile_data")
          .doc(uid)
          .update({
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
    if (imageType == 'Profile_picture') {
      await FirebaseFirestore.instance
          .collection("profile_data")
          .doc(uid)
          .update({
        'profile_picture': url,
      });
    } else {
      await FirebaseFirestore.instance
          .collection("profile_data")
          .doc(uid)
          .update({
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
      appBar: BackButtonAppBar(
        title: 'Customize Profile',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        iconkey: const Key('Back_button_key'),
        textkey: const Key('customize_profile_text'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          InkWell(
            onTap: _pickBanner,
            child: Stack(
              alignment: Alignment.center, // Change to Alignment.center
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 150,
                  child: _profileBannerUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: _profileBannerUrl,
                          placeholder: (context, url) => const Center(
                              child:
                                  CircularProgressIndicator()), // Loading indicator for banner
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
                        )
                      : kIsWeb
                          ? Image.network(
                              _profileBanner,
                              width: 359,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(_profileBanner),
                              width: 359,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                ),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 15,
                    color: Theme.of(context).colorScheme.surface,
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
                  _profileImageUrl.isNotEmpty
                      ? CircleAvatar(
                          radius: 60,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          backgroundImage:
                              CachedNetworkImageProvider(_profileImageUrl),
                        )
                      :  kIsWeb
                      ? CircleAvatar(
                    radius: 60,
                    backgroundColor:
                    Theme.of(context).colorScheme.primary,
                    backgroundImage: NetworkImage(_profileImage),
                  )
                      : CircleAvatar(
                    radius: 60,
                    backgroundColor:
                    Theme.of(context).colorScheme.primary,
                    backgroundImage: FileImage(File(_profileImage)),
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.camera_alt,
                        size: 15, color: Theme.of(context).colorScheme.surface),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),
          //genre title
          Row(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Genre',
                    style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.secondary)),
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
                    color: Colors.black,
                    size: 12,
                  ),
                ),
              )
            ],
          ),

          const SizedBox(height: 8),
          _displaySelectedItems(_selectedGenres,
              (item) => _deleteSelectedItem(item, _selectedGenres)),

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
                  ['PEGI 3', 'PEGI 7', 'PEGI 12', 'PEGI 16', 'PEGI 18'],
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
          _displaySelectedItems(
              _selectedAge, (item) => _deleteSelectedItem(item, _selectedAge)),

          const SizedBox(height: 20),

          // social interest title
          Row(
            children: <Widget>[
              const Align(
                alignment: Alignment.centerLeft,
                child:
                    Text('Social interests ', style: TextStyle(fontSize: 15)),
              ),
              const SizedBox(width: 20),
              InkWell(
                onTap: () => _showSelectableDialog(
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
          _displaySelectedItems(_selectedInterests,
              (item) => _deleteSelectedItem(item, _selectedInterests)),

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
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
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

  Future<void> _showSelectableDialog(String title, List<String> items,
      Function(List<String>) onSelected, String selectionType) async {
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
        final profileDocRef =
            db.collection("profile_data").doc(currentUser.uid);
        if (_profileImage != null) {
          String imageUrl;
            imageUrl = await uploadImageToFirebase(
                File(_profileImage!), 'Profile_picture');

          await saveImageURL(imageUrl, 'Profile_picture');

          // Show a confirmation message or navigate
          /*ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully.')),
        );*/
        }

        if (_profileBanner != null) {
          String bannerUrl;
            bannerUrl =
                await uploadImageToFirebase(File(_profileBanner!), 'banner');
            print(bannerUrl);
          await saveImageURL(bannerUrl, 'banner');

          // Show a confirmation message or navigate
          /*ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Banner updated successfully.')),
        );*/
        }

        final data = {
          "genre_interests_tags": _selectedGenres.isNotEmpty
              ? _selectedGenres
              : FieldValue.delete(),
          "age_rating_tag":
              _selectedAge.isNotEmpty ? _selectedAge : FieldValue.delete(),
          "social_interests_tags": _selectedInterests.isNotEmpty
              ? _selectedInterests
              : FieldValue.delete(),
        };

        await profileDocRef.set(data, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully.')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to update profile.'),
            backgroundColor: Colors.red),
      );
      throw ("Error setting/updating profile data: $e");
    }
  }
}
