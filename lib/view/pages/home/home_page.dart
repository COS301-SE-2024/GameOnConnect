// ignore_for_file: prefer_const_constructors, use_super_parameters
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/badges_S/badge_service.dart';
import 'package:gameonconnect/services/events_S/dynamic_scaling.dart';
import 'package:gameonconnect/services/profile_S/profile_service.dart';
import 'package:gameonconnect/view/components/card/custom_snackbar.dart';
import 'package:gameonconnect/view/components/home/online_friends_list.dart';
import 'package:gameonconnect/view/components/home/start_timer.dart';
import 'package:gameonconnect/view/pages/game_library/game_library_page.dart';
import 'package:gameonconnect/view/pages/games_page/games_page.dart';
import 'package:gameonconnect/view/pages/messaging/messaging_page.dart';
import 'package:gameonconnect/view/pages/profile/profile_page.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
// import 'package:gameonconnect/view/pages/events/events_page.dart';
// import 'package:gameonconnect/services/messaging_S/messaging_service.dart';
import 'package:gameonconnect/view/pages/events/view_events_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  final String title;

  // ignore: prefer_const_constructors_in_immutables
  const HomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final _formKey = GlobalKey<FormState>();
  ProfileService profileService = ProfileService();
  late TextEditingController usernamecontroller;

  final BadgeService _badgeService = BadgeService();

  late String currentUserId; // Declare currentUserId here
  late List<Widget> _pages; // Declare _pages as late

  @override
  void initState() {
    super.initState();
    usernamecontroller = TextEditingController();
    currentUserId = getCurrentUserId(); // Initialize currentUserId
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _checkProfileAndShowDialog());

    // Initialize _pages after currentUserId is set
    _pages = <Widget>[
      Center(
        child: _HomePageDisplay(),
      ),
      const GameLibrary(),
      const GamesPageWidget(),
      const ViewEvents(),
      ProfilePage(uid: currentUserId, isOwnProfile: true, isConnection: true, loggedInUser: currentUserId,),
    ];

    _badgeService.unlockLoyaltyBadge();
    _badgeService.unlockNightOwlBadge(DateTime.now());
  }

  String getCurrentUserId() {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return currentUserId;

    //WidgetsBinding.instance
    //.addPostFrameCallback((_) => _checkProfileAndShowDialog());
  }

  @override
  void dispose() {
    usernamecontroller.dispose();
    super.dispose();
  }

  Future<void> _checkProfileAndShowDialog() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final currentUserID = auth.currentUser?.uid;
    String userId = currentUserID ?? '';
    String? profileName = await profileService.getProfileName(userId);

    if (profileName == '' || profileName.toLowerCase() == 'default user') {
      _showDialogOnStart();
    } else {
      //print('Username is set to: $profileName');
    }
  }

  void _showNoInternetToast() {
    CustomSnackbar().show(context, 'Please check your internet connection');
  }

  void _showUsernameSet() {
    CustomSnackbar().show(context, 'Username has been set successfully');
  }

  Future<bool> _saveUsername(String username) async {
    try {
      //check the internet connection
      bool result = await InternetConnection().hasInternetAccess;
      //if the internet passed then check the username
      if (result) {
        if (username.isNotEmpty) {
          await profileService.editUsername(username); //set the username
          _showUsernameSet(); //show the success of the username set
          return true;
        }
        return false;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  //bool is needed for the state of the button
  bool _isSubmitting = false;

  void _showDialogOnStart() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Please enter a username:'),
          //user enters text in the form field
          content: Form(
            key: _formKey,
            child: TextFormField(
              maxLength: 16,
              key: Key('usernameInput'),
              autofocus: true,
              controller: usernamecontroller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 15, top: 12.5),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                hintText: 'Enter any alphabetical username',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                }
                if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                  return 'Only alphabetical letters are permitted';
                }
                return null;
              },
            ),
          ),
          actions: <Widget>[
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return TextButton(
                  onPressed: _isSubmitting //disables the submit button
                      ? null
                      : () async {
                          //first check if the person has already submitted
                          setState(() {
                            _isSubmitting = true;
                          });

                          //set is submitting to true to disable the button
                          _isSubmitting = true;

                          //the formkey calls the state to run the validator on the TextFormField
                          if (_formKey.currentState!.validate()) {
                            bool internet =
                                await _saveUsername(usernamecontroller.text);
                            if (internet != false) {
                              // ignore: use_build_context_synchronously
                              Navigator.of(dialogContext).pop();
                            } else {
                              _showNoInternetToast();
                            }
                          }

                          //set the state to false to ensure the
                          setState(() {
                            _isSubmitting = false;
                          });
                        },
                  child: Text('Submit'),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      height: 60.pixelScale(context),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_filled, 0),
          _buildNavItem(Icons.search, 1),
          _buildNavItem(Icons.gamepad_rounded, 2),
          _buildNavItem(Icons.calendar_today, 3),
          _buildNavItem(Icons.person, 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    Color selectedColor = Theme.of(context).brightness == Brightness.light
        ? Colors.black
        : Theme.of(context).colorScheme.primary;
    Color defaultColor = Theme.of(context).brightness == Brightness.light
        ? Colors.grey
        : Theme.of(context).colorScheme.primary;
    Color highlightColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).colorScheme.primary
        : const Color.fromARGB(255, 43, 43, 43);

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        width: 40,
        height: 40.pixelScale(context),
        alignment: Alignment.center,
        decoration: isSelected
            ? BoxDecoration(
                color: highlightColor,
                shape: BoxShape.circle,
              )
            : null,
        child: Icon(
          icon,
          size: 30,
          color: isSelected ? selectedColor : defaultColor,
        ),
      ),
    );
  }
}

class _HomePageDisplay extends StatefulWidget {
  @override
  State<_HomePageDisplay> createState() => _HomePageDisplayState();
}

class _HomePageDisplayState extends State<_HomePageDisplay> {
  // final MessagingService messagingService = MessagingService();
  late String currentUserName = "";
  late String currentUserId;
  final ProfileService _profileService = ProfileService();

  @override
  initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    String? userName = await getUserName();
    setState(() {
      currentUserName = userName!;
    });
  }

  Future<String?> getUserName() async {
    return await _profileService.getProfileName(currentUserId);
  }

  Widget _homeBody() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ready to game,",
              style: TextStyle(fontSize: 32.pixelScale(context), fontWeight: FontWeight.bold)),
          Text("$currentUserName?",
              style: TextStyle(
                  fontSize: 32.pixelScale(context),
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary)),
          SizedBox(height: 15.pixelScale(context)),
          GameTimer(),
          SizedBox(height: 15.pixelScale(context)),
          Divider(
            thickness: 1,
            color: Theme.of(context).colorScheme.primaryContainer,
          ),

          Expanded(
            child: ListView(children: [
              SizedBox(height: 19.pixelScale(context)),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameLibrary()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withAlpha(50),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Explore,",
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.onPrimary,
                                      fontSize: 25.pixelScale(context),
                                      fontWeight: FontWeight.bold)),
                              Text("Game,",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontSize: 25.pixelScale(context),
                                      fontWeight: FontWeight.bold)),
                              Text("Connect",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontSize: 25.pixelScale(context),
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          Row(
                            children: [
                               SvgPicture.asset(
                                'assets/icons/start_hearts.svg',
                                width: 110,
                                fit: BoxFit.contain,
                              ), 
                              SizedBox(width: 10),
                              Icon(
                                Icons.arrow_forward_ios,
                                color:
                                    Theme.of(context).brightness == Brightness.dark
                                        ? Colors.black
                                        : Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.pixelScale(context)),
              Text("Friends currently online",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.pixelScale(context))),
              SizedBox(height: 15.pixelScale(context)),
              CurrentlyOnlineBar(),
              SizedBox(height: 30.pixelScale(context)),            ]),
          ),
        ],
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              'Home',
              style: TextStyle(
                fontSize: 32.pixelScale(context),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 16.0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Messaging(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.message,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(right: 20.0, top: 16.0),
            //   child: IconButton(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => const AchievementBadgesPage(),
            //         ),
            //       );
            //     },
            //     icon: Icon(
            //       Icons.model_training,
            //       color: Theme.of(context).colorScheme.primary,
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(right: 20.0, top: 16.0),
            //   child: IconButton(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) =>
            //               GamePage(), //GameWidget(game: SpaceShooterGame())
            //         ),
            //       );
            //     },
            //     icon: Icon(
            //       Icons.sports_score,
            //       color: Theme.of(context).colorScheme.primary,
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(right: 20.0, top: 16.0),
            //   child: IconButton(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => GameScreen()),
            //       );
            //     },
            //     icon: Icon(
            //       Icons.flutter_dash,
            //       color: Theme.of(context).colorScheme.primary,
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(right: 20.0, top: 16.0),
            //   child: IconButton(
            //     onPressed: () async {
            //       await Flame.device.fullScreen();
            //       if (!context.mounted) return;
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => const LoadingGameyConPage(),
            //         ),
            //       );
            //     },
            //     icon: Icon(
            //       Icons.games_outlined,
            //       color: Theme.of(context).colorScheme.primary,
            //     ),
            //   ),
            // ),
          ],
          centerTitle: false,
          elevation: 0,
        ),
        body: _homeBody());
  }
}