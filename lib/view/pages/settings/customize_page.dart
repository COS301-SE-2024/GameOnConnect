// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/settings/customize_service.dart';
import 'package:gameonconnect/view/components/appbars/backbutton_appbar_component.dart';
import 'package:gameonconnect/view/components/settings/customize_tag_container.dart';
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

  bool _isDataFetched = false;

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
        });
      }
    }
  }

  Future<void> _fetchData() async {
    await _fetchUserSelectionsFromDatabase();
    await Future.wait([_fetchAllTags()]);
  }

  void _saveChangedProfileData() async {
    final success = await CustomizeService().saveProfileData(
       _selectedGenres, _selectedAge, _selectedInterests);
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
              TagContainer(
                // Show the number of selected genres
                tagType: 'Genre (${_selectedGenres.length} selected)',
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
                // Show the number of selected ESRB ratings
                tagType: 'ESRB rating (${_selectedAge.length} selected)',
                onPressed: () => _showSelectableDialog(
                  'Select ESRB rating',
                  ['PEGI 3', 'PEGI 7', 'PEGI 12', 'PEGI 16', 'PEGI 18'],
                  (results) {
                    _selectedAge = results;
                    setState(() {});
                  },
                  'age',
                ),
              ),
              TagContainer(
                // Show the number of selected social interests
                tagType: 'Social interests (${_selectedInterests.length} selected)',
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
              content: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
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
