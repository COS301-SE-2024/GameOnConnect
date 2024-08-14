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
import 'package:gameonconnect/view/components/settings/customize_tag_container.dart';
import 'package:gameonconnect/view/components/settings/edit_colour_icon_component.dart';
import 'package:gameonconnect/view/theme/theme_provider.dart';
import 'package:gameonconnect/view/theme/themes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../globals.dart' as globals;

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
  bool _isMounted = false;
  Color selectedColor = const Color.fromRGBO(0, 255, 117, 1.0);

  Future<void> _fetchGenresFromAPI() async {
    try {
      var url =
          Uri.parse('https://api.rawg.io/api/genres?key=${globals.apiKey}');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var decoded = json.decode(response.body);
        if (_isMounted) {
          setState(() {
            _genres = (decoded['results'] as List)
                .map((genre) => genre['name'].toString())
                .toList();
          });
        }
      } else {
        //print("Error fetching genres: ${response.statusCode}");
      }
    } catch (e) {
      //print("Error fetching genres: $e");
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> _fetchTagsFromAPI() async {
    try {
      if (_isMounted) {
        var url =
            Uri.parse('https://api.rawg.io/api/tags?key=${globals.apiKey}');
        var response = await http.get(url);
        if (response.statusCode == 200) {
          var decoded = json.decode(response.body);

          setState(() {
            _interests = (decoded['results'] as List)
                .map((tag) => tag['name'].toString())
                .toList();
          });
        } else {
          throw ("Error fetching interest tags: ${response.statusCode}");
        }
      }
    } catch (e) {
      throw ("Error fetching interest tags: $e");
    }
  }

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
    if (_isMounted) {
      setState(() {
        selectedList.remove(item);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _fetchData().then((_) {
      if (_isMounted) {
      setState(() {
        _isDataFetched = true;
      });
    }
    });
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    ThemeData currentTheme = themeProvider.themeData;

    // Check if the current theme is a dark theme
    isDarkMode = currentTheme == darkGreenTheme ||
        currentTheme == darkPurpleTheme ||
        currentTheme == darkBlueTheme ||
        currentTheme == darkYellowTheme ||
        currentTheme == darkPinkTheme;
  }

  void _updateTheme(Color color) {
    setState(() {
      selectedColor = color;
    });
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    if (color == const Color.fromRGBO(0, 255, 117, 1.0)) {
      themeProvider.setTheme(isDarkMode ? darkGreenTheme : lightGreenTheme);
    } else if (color == const Color.fromRGBO(173, 0, 255, 1.0)) {
      themeProvider.setTheme(isDarkMode ? darkPurpleTheme : lightPurpleTheme);
    } else if (color == const Color.fromRGBO(0, 10, 255, 1.0)) {
      themeProvider.setTheme(isDarkMode ? darkBlueTheme : lightBlueTheme);
    } else if (color == const Color.fromRGBO(235, 255, 0, 1.0)) {
      themeProvider.setTheme(isDarkMode ? darkYellowTheme : lightYellowTheme);
    } else if (color == const Color.fromRGBO(255, 0, 199, 1.0)) {
      themeProvider.setTheme(isDarkMode ? darkPinkTheme : lightPinkTheme);
    }
  }

  Future<void> _fetchUserSelectionsFromDatabase() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;

      if (currentUser != null) {
        final db = FirebaseFirestore.instance;
        final profileDocRef =
            db.collection("profile_data").doc(currentUser.uid);

        final docSnapshot = await profileDocRef.get();
        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          final genres = List<String>.from(data?["genre_interests_tags"] ?? []);
          final age = List<String>.from(data?["age_rating_tags"] ?? []);
          final interests =
              List<String>.from(data?["social_interests_tags"] ?? []);

          StorageService storageService = StorageService();
          String bannerDownloadUrl =
              await storageService.getBannerUrl(currentUser.uid);
          String profileDownloadUrl =
              await storageService.getProfilePictureUrl(currentUser.uid);
          if (_isMounted) {
            setState(() {
              _selectedGenres = genres;
              _selectedAge = age;
              _selectedInterests = interests;
              _profileBannerUrl = bannerDownloadUrl;
              _profileImageUrl = profileDownloadUrl;
            });
          }
        }
      }
    } catch (e) {
      throw ("Error fetching user selections: $e");
    }
  }

  Future<void> _fetchData() async {
    await _fetchUserSelectionsFromDatabase();
    await Future.wait([_fetchGenresFromAPI(), _fetchTagsFromAPI()]);
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      // Web implementation
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);

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
      } else {
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
  }

  Future<void> _pickBanner() async {
    if (kIsWeb) {
      // Web implementation
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null) {
        PlatformFile file = result.files.first;
        if (file.bytes != null) {
          setState(() {
            _profileBanner = (file.bytes!, file.name);
            //_profileBannerFB = file.name;
          });
        }
        /* ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image selected successfully.')),
        );*/
      } else {
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
  }

  Future<String> uploadImageToFirebase(File image, String imagetype) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // Create a reference to Firebase Storage
    if (imagetype == 'Profile_picture') {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_pictures/$uid.jpg');
      UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask.whenComplete(() => null);

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
        padding: const EdgeInsets.all(12.0),
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 50),
            child:  Stack(

            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: <Widget>[

              //banner
              InkWell(
            onTap: _pickBanner,
            child: Stack(
              alignment: Alignment.center, // Change to Alignment.center
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: double.infinity,
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _profileBannerUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: _profileBannerUrl,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()), // Loading indicator for banner
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(_profileBanner),
                            width: 359,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.7),
                      shape: BoxShape.circle),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Theme.of(context)
                        .colorScheme
                        .primary,
                  )
                ),
              ],
            ),
          ),
              
               Positioned(
                bottom: -50, // Half of the CircleAvatar's radius to align it properly
                left: 20,
                //profile picture
                child: InkWell(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  _profileImageUrl.isNotEmpty
                      ? CircleAvatar(
                          radius: 50,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          backgroundImage:
                              CachedNetworkImageProvider(_profileImageUrl),
                        )
                      : CircleAvatar(
                          radius: 50,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          backgroundImage: FileImage(File(_profileImage)),
                        ),
                  Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.7),
                      shape: BoxShape.circle),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Theme.of(context)
                        .colorScheme
                        .primary,
                    size: 17,
                  )
                ),
                ],
              ),
            ),
              ),
            ],
          ),


          ),
          
          TagContainer(
            tagType: 'Genre',
            onPressed: () => _showSelectableDialog(
                  'Select Genre',
                  _genres,
                  (results) {
                    _selectedGenres = results;
                    setState(() {});
                  },
                  'genre',
                ),
          ),

          TagContainer(
            tagType: 'Age rating',
            onPressed: () =>_showSelectableDialog(
                  'Select Age rating',
                  ['PEGI 3', 'PEGI 7', 'PEGI 12', 'PEGI 16', 'PEGI 18'],
                  (results) {
                    _selectedAge = results;
                    setState(() {});
                  },
                  'age',
                ),
          ),
          TagContainer(
            tagType: 'Social interests',
            onPressed: () => _showSelectableDialog(
                  'Select Social interest',
                  _interests,
                  (results) {
                    _selectedInterests = results;
                    setState(() {});
                  },
                  'interest',
                ),
          ),



             
          
          
          
          const SizedBox(height: 20),
        
          ColourIconContainer(
            updateTheme: _updateTheme,
            isDarkMode: isDarkMode,
            onDarkModeChanged: (newValue) {
              setState(() {
                isDarkMode = newValue;
              });
            },
            currentColor: selectedColor,
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
              child: const Text(
                'Save Changes',
                style: TextStyle(
                  color: Colors.black
                  )),
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
          if (kIsWeb) {
            imageUrl = await uploadImageToFirebase(
                File(_profileImage!), 'Profile_picture');
          } else {
            imageUrl = await uploadImageToFirebase(
                File(_profileImage!), 'Profile_picture');
          }

          await saveImageURL(imageUrl, 'Profile_picture');

          // Show a confirmation message or navigate
          /*ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully.')),
        );*/
        }

        if (_profileBanner != null) {
          String bannerUrl;
          if (kIsWeb) {
            bannerUrl =
                await uploadImageToFirebase(File(_profileBanner!), 'banner');
          } else {
            bannerUrl =
                await uploadImageToFirebase(File(_profileBanner!), 'banner');
          }
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
          "age_rating_tags":
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to update profile.'),
            backgroundColor: Colors.red),
      );
      throw ("Error setting/updating profile data: $e");
    }
  }
}
