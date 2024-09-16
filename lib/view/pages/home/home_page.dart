// ignore_for_file: prefer_const_constructors, use_super_parameters
import 'dart:io';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/GameyCon/gameycon_game.dart';
import 'package:gameonconnect/services/profile_S/profile_service.dart';
import 'package:gameonconnect/view/components/card/custom_toast_card.dart';
import 'package:gameonconnect/view/components/home/connection_updates.dart';
import 'package:gameonconnect/view/components/home/event_invite_list.dart';
import 'package:gameonconnect/view/components/home/online_friends_list.dart';
import 'package:gameonconnect/view/components/home/start_timer.dart';
import 'package:gameonconnect/view/pages/badges/achievement_badges.dart';
import 'package:gameonconnect/view/pages/flappy_bird/game_screen_page.dart';
import 'package:gameonconnect/view/pages/game_library/game_library_page.dart';
import 'package:gameonconnect/view/pages/messaging/messaging_page.dart';
import 'package:gameonconnect/view/pages/profile/profile_page.dart';
import 'package:gameonconnect/view/pages/events/create_events_page.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
// import 'package:gameonconnect/view/pages/events/events_page.dart';
// import 'package:gameonconnect/services/messaging_S/messaging_service.dart';
import 'package:gameonconnect/view/pages/events/view_events_page.dart';
import 'package:gameonconnect/view/pages/space_shooter_game/game_page.dart';

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
      const CreateEvents(),
      const ViewEvents(),
      ProfilePage(uid: currentUserId, isOwnProfile: true, isConnection: true, loggedInUser: currentUserId,),
    ];
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
    DelightToastBar(
      builder: (context) {
        return CustomToastCard(
          title: Text(
            'No internet connection', // Changed message here
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        );
      },
      position: DelightSnackbarPosition.top,
      autoDismiss: true,
      snackbarDuration: const Duration(seconds: 3),
    ).show(context);
  }

  void _showUsernameSet() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Username has been set successfully'),
        backgroundColor: Colors.green,
      ),
    );
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
      height: 60,
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
        height: 40,
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
   GameyCon game = GameyCon();

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
      child: ListView(children: [
        Text("Ready to game,",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        Text("$currentUserName?",
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary)),
        SizedBox(height: 15),
        GameTimer(),
        SizedBox(height: 15),
        Divider(
          thickness: 1,
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        SizedBox(height: 19),
        Text("Friends currently online",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        SizedBox(height: 15),
        CurrentlyOnlineBar(),
        SizedBox(height: 30),
        Text("Connection updates",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        SizedBox(height: 15),
        ConnectionUpdates(),
        SizedBox(height: 30),
        Text("Event invites",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        SizedBox(height: 15),
        EventInvitesList()
      ]),
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
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0,top: 16.0),
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
            Padding(
              padding: const EdgeInsets.only(right: 20.0,top: 16.0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AchievementBadgesPage(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.model_training,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Padding(

              padding: const EdgeInsets.only(right: 20.0,top: 16.0),

              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GamePage(),   //GameWidget(game: SpaceShooterGame())
                    ),
                  );
                },
                icon: Icon(
                  Icons.sports_score,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0,top: 16.0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameScreen()
                    ),
                  );
                },
                icon: Icon(
                  Icons.flutter_dash,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0,top: 16.0),
              child: IconButton(
                onPressed: () async {
                  await Flame.device.fullScreen();
                  if (!context.mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      //builder: (context) => GameWidget(game: game,),
                      builder: (context) => GameWidget(game: kDebugMode ? GameyCon() : game,),
                    ),
                  );
                },
                icon: Icon(

                  Icons.games_outlined,

                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0,
        ),
        body: _homeBody());
  }
}
