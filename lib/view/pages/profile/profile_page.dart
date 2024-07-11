import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gameonconnect/model/game_library_M/game_details_model.dart';
import 'package:gameonconnect/model/profile_M/profile_model.dart';
import 'package:gameonconnect/services/profile_S/profile_service.dart';
import 'game_list.dart';
import 'stats_card.dart';
import 'profile_section.dart';

class Profilenew extends StatefulWidget {
  const Profilenew({super.key});

  @override
  State<Profilenew> createState() => _ProfileState();
}

//NB rename
class _ProfileState extends State<Profilenew>  {

late Future<GameDetails> _gameDetails;

@override
 /* void initState() {
    super.initState();
  //  _gameDetails = _fetchGameDetails(widget.gameId);
  }*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [ // NB only show if its my own profile
                  Builder(
                    builder: (context) {
                      return IconButton(
                        key: const Key('settings_icon_button'),
                        icon: const Icon(Icons.settings),
                        color: Theme.of(context).colorScheme.secondary,
                        onPressed: () {
                          //Scaffold.of(context).openEndDrawer();
                          Navigator.pushNamed(context, '/settings');
                        },
                      );
                    },
                  ),
                ],
      ),
      body: FutureBuilder<Profile?>(
        future: ProfileService().fetchProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Center(child: CircularProgressIndicator()); // Show loading indicator
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null) {
            return Center(child: Text('Profile data not found.'));
          } else {
            final profileData = snapshot.data!;
      return SingleChildScrollView(
        child: Column(
          children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Column(
                        children: [
                          // Banner
                          Container(
                            height: 170,
                            width: MediaQuery.of(context).size.width,
                            /*decoration:  BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                // ignore: unnecessary_string_interpolations
                                image:CachedNetworkImageProvider('${profileData.banner}'), // Use banner from storage
                              ),
                            ),*/
                            child: CachedNetworkImage(
                              imageUrl: profileData.banner,
                              placeholder: (context, url) => Center(child: CircularProgressIndicator()), // Loading indicator for banner
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Bottom container
                          Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 55), //space 
                                    Text(
                                      '${profileData.profileName}',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '#${profileData.uniqueNumber}',
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      '${profileData.numberOfconnections} Connections',
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 15), //space 
                                    Text(
                                      '${profileData.bio}',
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                                              
                        ],
                      ),
                      // Profile picture
                      Positioned(
                        top: 120, // Adjust this value to move the profile picture downwards
                        left: (MediaQuery.of(context).size.width - 100) / 2, // Center the profile picture
                        child: ClipOval(
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle, // Make it circular
                              border: Border.all(
                                color:Theme.of(context).colorScheme.primary,  // Set your desired border color
                                width: 3, // Set the border width
                              ),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider('${profileData.profilePicture}'),
                              ),
                            ),
                             /*child: CachedNetworkImage(
                              imageUrl: profileData.profilePicture,
                              placeholder: (context, url) => Center(child: CircularProgressIndicator()), // Loading indicator for profile picture
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),*/
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20), //space 
                  Container(
                    margin: const EdgeInsets.fromLTRB(18.9, 0, 3, 13),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                  const Text(
                    'Currently playing ',
                    style:  TextStyle(
                      ////'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      //height: 1.4,
                      //letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(7, 4, 8.1, 0),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF00FF75)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IntrinsicWidth(
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //start of currently playing fortnite
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 3.5, 3),
                              child: Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      '../../../../../assets/images/image_3.png',
                                    ),
                                  ),
                                ),
                               child: Container(
                                  width: 147,
                                  height: 101,
                                ),
                              ),
                            ),
                            Container(
                              //margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    //margin: const EdgeInsets.fromLTRB(3.5, 0, 3.5, 0),
                                    child: const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Fortnite',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                          //height: 0.9,
                                          //color: Color(0xFFC4C4C4),
                                        ),
                                          
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(0, 0, 13.9, 7.3),
                                    child: SizedBox(
                                      //width: 138.5,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          
                                          Container(
                                            //margin: const EdgeInsets.fromLTRB(0, 0, 0, 4.7),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFEE1313),
                                                borderRadius: BorderRadius.circular(3),
                                              ),
                                              child: Container(
                                                padding: const EdgeInsets.fromLTRB(7, 4, 9.5, 3),
                                                child: const Text(
                                                  'LIVE',
                                                  style:  TextStyle(
                                                    ////'Inter',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                    //height: 0.9,
                                                    //color: Color(0xFF000000),
                                                  ),
                                                ),
                                              ),
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
                        ),
                        
                      ),
                    ),
                  ),
                      ],
                    )),
                  
                ],
        ),
      );
      }
        },
      ),
    );
  }
}
