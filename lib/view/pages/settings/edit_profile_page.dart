// ignore_for_file: use_build_context_synchronously
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/view/components/card/custom_snackbar.dart';
import 'package:gameonconnect/view/components/settings/tooltip.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../components/settings/edit_input_text.dart';
import '../../components/settings/edit_date_input.dart';
import '../../components/settings/edit_switch.dart';
import 'package:gameonconnect/view/components/appbars/backbutton_appbar_component.dart';
import 'dart:io';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../../services/settings/edit_profile_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePage();
}

class _EditProfilePage extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      dataFetched = false;
      fetchData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _username = "";
  String _firstName = "";
  String _lastName = "";
  String _bio = "";
  DateTime? _birthday;
  late bool _isPrivate;
  String _profileImageUrl = '';
  dynamic _profileImage;
  String _profileBannerUrl = '';
  dynamic _profileBanner;
  late bool dataFetched;

  void databaseAccess(Map<String, dynamic>? d) async {
    setState(() {
      _username = d?['username']['profile_name'];
      _firstName = d?['name'];
      _lastName = d?['surname'];
      _bio = d?['bio'];
      _birthday = DateTime.parse(d!['birthday'].toDate().toString());
      _isPrivate = d['visibility'];
      _profileBannerUrl = d['banner'];
      _profileImageUrl = d['profile_picture'];
      dataFetched = true;
    });
  }

  Future<void> fetchData() async {
    await EditProfileService().databaseAccess().then((onValue) {
      databaseAccess(onValue);
    });
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
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to select Image.')),
        );
      }
    }
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
      }
      }
     else {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _profileImage = image.path;
          _profileImageUrl = '';
        });
      } else {}
    }
  }

  Future<void> _saveProfile() async {
    try {
      bool result = await InternetConnection().hasInternetAccess;
      if (result) {
        if (_formKey.currentState?.validate() == true) {
          _formKey.currentState?.save();
          editProfile();
          CustomSnackbar().show(context, 'Updated profile successfully');

          Navigator.of(context).pop();
        }
      } else {
        _showNoInternetSnackbar();
      }
    } on SocketException catch (_) {
      _showNoInternetSnackbar();
    }
  }

  void _showNoInternetSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No internet connection'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void editProfile() async {
    try {
      await EditProfileService().editProfile(_username, _firstName, _lastName,
          _bio, _birthday!, _isPrivate, _profileImage, _profileBanner);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error updating profile'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BackButtonAppBar(
          title: 'Edit Profile',
          onBackButtonPressed: () {
            Navigator.pop(context);
          },
          iconkey: const Key('Back_button_key'),
          textkey: const Key('edit_profile_text'),
        ),
        body: (!dataFetched)
            ? Center(
                child: LoadingAnimationWidget.halfTriangleDot(
                  color: Theme.of(context).colorScheme.primary,
                  size: 36,
                ),
              )
            : Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: [
                          InkWell(
                            onTap: _pickBanner,
                            child: Stack(
                              alignment: Alignment
                                  .center, // Change to Alignment.center
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
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator()), // Loading indicator for banner
                                            errorWidget:
                                                (context, url, error) =>
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
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                            height: 111,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              clipBehavior: Clip.none,
                              children: <Widget>[
                                //banner

                                Positioned(
                                  bottom:
                                      -80, // Half of the CircleAvatar's radius to align it properly
                                  left: 20,
                                  //profile picture
                                  child: InkWell(
                                    onTap: _pickImage,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
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

                                            child: ClipRRect(

                                              borderRadius: BorderRadius.circular(300),
                                              child: _profileImageUrl.isNotEmpty
                                                  ? CachedNetworkImage(

                                                  placeholder: (context, url) =>
                                                  const Center(
                                                      child:
                                                      CircularProgressIndicator()),
                                                      imageUrl:
                                                          _profileImageUrl , fit: BoxFit.cover)
                                                  : Image.file (File(_profileImage),fit: BoxFit.cover,),
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
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
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
                        ],
                      ),
                      const SizedBox(height: 15),
                      Expanded(
                        child: ListView(
                          children: [
                            EditInputText(
                              inputKey: const Key('usernameField'),
                              maxLines: 1,
                              label: 'Username',
                              onChanged: (value) => _username = value,
                              input: _username,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    child: EditInputText(
                                      inputKey: const Key('firstNameField'),
                                      maxLines: 1,
                                      label: 'First name',
                                      onChanged: (value) => _firstName = value,
                                      input: _firstName,
                                    ),
                                  ),
                                  Flexible(
                                    child: EditInputText(
                                      inputKey: const Key('lastNameField'),
                                      maxLines: 1,
                                      label: 'Last Name',
                                      onChanged: (value) => _lastName = value,
                                      input: _lastName,
                                    ),
                                  ),
                                ]),
                            EditInputText(
                              inputKey: const Key('bioField'),
                              maxLines: 5,
                              label: 'Bio',
                              onChanged: (value) => _bio = value,
                              input: _bio,
                            ),
                            EditDateInput(
                              currentDate: _birthday!,
                              label: 'Birthday',
                              onChanged: (value) => {_birthday = value},
                            ),
                            const Align(
                              alignment: Alignment(-1, 0),
                              child: ToolTip(
                                  message: "When your profile is set "
                                      "to Private, only your connections can "
                                      "view your profile."),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            EditSwitch(
                              label: 'Private',
                              currentValue: _isPrivate,
                              onChanged: (value) => {_isPrivate = value},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 35,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: _saveProfile,
                              child: const Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ));
  }
}
