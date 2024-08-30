// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/settings/customize_service.dart';
import 'package:gameonconnect/view/components/appbars/backbutton_appbar_component.dart';
import 'package:gameonconnect/view/components/settings/customize_tag_container.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


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
  

  late CustomizeService customizeService;

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
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  bool isCurrentlyDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  Future<void> _fetchAllTags() async {
    final tagsList = await CustomizeService().fetchTagsFromAPI(_isMounted);

    if (tagsList.isNotEmpty) {
      if (_isMounted) {
        setState(() {
          _interests = tagsList;
        });
      }
    }

    final genreList = await CustomizeService().fetchGenresFromAPI(_isMounted);

    if (genreList.isNotEmpty) {
      if (_isMounted) {
        setState(() {
          _genres = genreList;
        });
      }
    }
  }

  Future<void> _fetchUserSelectionsFromDatabase() async {
    final customizeData =
        await CustomizeService().fetchUserSelectionsFromDatabase();

    if (customizeData.isNotEmpty) {
      if (_isMounted) {
        setState(() {
          _selectedGenres = customizeData.elementAt(0);
          _selectedAge = customizeData.elementAt(1);
          _selectedInterests = customizeData.elementAt(2);
          _profileBannerUrl = customizeData.elementAt(3).elementAt(0);
          _profileImageUrl = customizeData.elementAt(3).elementAt(1);
        });
      }
    }
  }

  Future<void> _fetchData() async {
    await _fetchUserSelectionsFromDatabase();
    await Future.wait([_fetchAllTags()]);
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image selected successfully.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to select Image.')),
        );
      }
    } else {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _profileImage = image.path;
          _profileImageUrl = '';
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
          _profileBannerUrl = '';
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

  void _saveChangedProfileData() async {
    final success = await CustomizeService().saveProfileData(_profileImage,
        _profileBanner, _selectedGenres, _selectedAge, _selectedInterests);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to update profile.'),
            backgroundColor: Colors.red),
      );
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
        ),
        body: Center(
          child: LoadingAnimationWidget.halfTriangleDot(
            color: Theme.of(context).colorScheme.primary,
            size: 36,
          ),
        ),
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
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(12.0),
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    //banner
                    InkWell(
                      onTap: _pickBanner,
                      child: Stack(
                        alignment:
                            Alignment.center, // Change to Alignment.center
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
                                          child:
                                              CircularProgressIndicator()), // Loading indicator for banner
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
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
                                color: Theme.of(context).colorScheme.primary,
                              )),
                        ],
                      ),
                    ),

                    Positioned(
                      bottom:
                          -50, // Half of the CircleAvatar's radius to align it properly
                      left: 20,
                      //profile picture
                      child: InkWell(
                        onTap: _pickImage,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            _profileImageUrl.isNotEmpty
                                ? Container(
                                    width: 104.0,
                                    height: 104.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        width: 4.0,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              _profileImageUrl),
                                    ),
                                  )
                                : Container(
                                    width: 104.0,
                                    height: 104.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        width: 4.0,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              _profileImage),
                                    ),
                                  ),
                            Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer
                                    .withOpacity(0.7),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Theme.of(context).colorScheme.primary,
                                size: 17,
                              ),
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
                onPressed: () => _showSelectableDialog(
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
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                height: 35,
                child: ElevatedButton(
                  key: const Key('saveButton'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    _saveChangedProfileData();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          )
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
}
