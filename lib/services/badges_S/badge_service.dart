import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/connection_S/connection_service.dart';
import 'package:gameonconnect/services/profile_S/storage_service.dart';
import 'package:gameonconnect/services/stats_S/stats_total_time_service.dart';

class BadgeService {
  BadgeService._privateConstructor();

  static final BadgeService _instance = BadgeService._privateConstructor();

  factory BadgeService() {
    return _instance;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<String>> getConnectionsBadgeStatus(String badgeName) async {
  final currentUser = _auth.currentUser?.uid;

  List<String> connections = await ConnectionService().getConnections("connections", currentUser);
  List<String> unlockedProfiles = []; 

  for (String connectionId in connections) {
    try {
      DocumentSnapshot<Map<String, dynamic>> badgeSnapshot =
          await _firestore.collection('badges').doc(connectionId).get();

      if (badgeSnapshot.exists && badgeSnapshot.data() != null) {
        Map<String, dynamic> badgeData = badgeSnapshot.data()!;

        if (badgeData.containsKey(badgeName) && badgeData[badgeName]['unlocked'] == true) {
          StorageService storageService = StorageService();
          String profilePictureUrl =
              await storageService.getProfilePictureUrl(currentUser!);

          unlockedProfiles.add(profilePictureUrl);
        }
      }
    } catch (e) {
      //print("Error checking badge for user $connectionId: $e");
    }
  }

  print("The unlocked profiles: ${unlockedProfiles.toString()}");

  return unlockedProfiles;
}


  Future<Map<String, dynamic>> getBadges() async {
    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection("badges")
          .doc(currentUser.uid)
          .get();

      Map<String, dynamic>? badgeData = doc.data();

    if (badgeData != null) {
      badgeData.remove('userID');
      return badgeData; 
    } else {
      const SnackBar(content: Text("No badge data found."));
    }
  } else {
    const SnackBar(content: Text("No user is currently logged in."));
  }

  return {}; 
}


  void unlockLoyaltyBadge() async {
    try {
      DateTime currentDate = DateTime.now(); //get the current date
      final currentUser = _auth.currentUser; //get the current user

      if (currentUser != null) {
        DocumentSnapshot<Map<String, dynamic>> doc =
            await _firestore.collection("badges").doc(currentUser.uid).get();
        Map<String, dynamic>? data =
            doc.data(); //get the corresponding document from firestore

        if (data != null) {
          bool unlocked = data["loyalty_badge"]["unlocked"] ??
              false; //check if the badge is already unlocked

          if (unlocked) {
            return; //if it is already unlocked then return
          }

          DateTime latestDate =
              (data["loyalty_badge"]["latest_date"] as Timestamp).toDate();

          ///get the latest date from the document
          int count =
              data["loyalty_badge"]["count"]; //get the count from the document

          // check if the function has already run today
          bool isSameDay = latestDate.day == currentDate.day &&
              latestDate.month == currentDate.month &&
              latestDate.year == currentDate.year;

          if (isSameDay) {
            //if it is the same day, then don't run again
            return;
          }

          bool isYesterday = latestDate.day == currentDate.day - 1 &&
              latestDate.month == currentDate.month &&
              latestDate.year == currentDate.year;

          if (isYesterday) {
            //if the latest date was yesterday then increment the count
            count = count + 1;
          } else {
            count = 0;
          }

          if (count >= 10) {
            await _firestore.collection("badges").doc(currentUser.uid).update({
              //if the count is >= 10 then update the document with the unlocked status
              "loyalty_badge": {
                "count": count,
                "latest_date": currentDate,
                "date_unlocked": currentDate,
                "unlocked": true,
              }
            });
          } else {
            await _firestore.collection("badges").doc(currentUser.uid).update({
              //update the count and latest date in the document
              "loyalty_badge": {
                "count": count,
                "latest_date": currentDate,
                "date_unlocked": null,
                "unlocked": false,
              }
            });
          }
        }
      }
    } catch (e) {
      throw Exception("Failed to unlock loyalty badge: $e");
    }
  }

  void unlockCollectorBadge(bool add) async {
    try {
      final currentUser = _auth.currentUser;

      if (currentUser != null) {
        DocumentSnapshot<Map<String, dynamic>> doc =
            await _firestore.collection("badges").doc(currentUser.uid).get();
        Map<String, dynamic>? data = doc.data();

        if (data != null) {
          int count = data["collector_badge"]
              ["count"]; //get the count from the document
          bool unlocked = data["collector_badge"]["unlocked"];

          if (unlocked == false) {
            // only update if its false
            if (add) {
              count++;
            } else {
              count--;
            }

            if (count == 10) {
              await _firestore
                  .collection("badges")
                  .doc(currentUser.uid)
                  .update({
                //if the count is == 10 then update the document with the unlocked status
                "collector_badge": {
                  "count": count,
                  "date_unlocked": DateTime.now(),
                  "unlocked": true,
                }
              });
            } else if (count < 10) {
              await _firestore
                  .collection("badges")
                  .doc(currentUser.uid)
                  .update({
                //update the count and latest date in the document
                "collector_badge": {
                  "count": count,
                  "date_unlocked": null,
                  "unlocked": false,
                }
              });
            }
          }
        }
      }
    } catch (e) {
      Exception("Failed to unlock collector badge: $e"); 
    }
  }

  void unlockAchieverBadge() async {
    try {
      final currentUser = _auth.currentUser;

      if (currentUser != null) {
        DocumentSnapshot<Map<String, dynamic>> doc =
            await _firestore.collection("badges").doc(currentUser.uid).get();
        Map<String, dynamic>? data = doc.data();

        if (data != null) {
          bool unlocked = data["achiever_badge"]["unlocked"];

          if (unlocked == false) {
            await _firestore.collection("badges").doc(currentUser.uid).update({
              "achiever_badge": {
                "date_unlocked": DateTime.now(),
                "unlocked": true,
              }
            });
          }
        }
      }
    } catch (e) {
      Exception("Failed to unlock achiever badge: $e"); 
    }
  }

  void unlockCustomizerBadge() async {
    try {
      final currentUser = _auth.currentUser;

      if (currentUser != null) {
        DocumentSnapshot<Map<String, dynamic>> doc =
            await _firestore.collection("badges").doc(currentUser.uid).get();
        Map<String, dynamic>? data = doc.data();

        if (data != null) {
          int count = data["customizer_badge"]
              ["count"]; //get the count from the document

          bool unlocked = data["customizer_badge"]["unlocked"];

          if (unlocked == false) {
            //Only update if its not unlocked yet
            if (count < 3) {
              count++;
            }

            if (count == 3) {
              await _firestore
                  .collection("badges")
                  .doc(currentUser.uid)
                  .update({
                //if the count is ==3 then update the document with the unlocked status
                "customizer_badge": {
                  "count": count,
                  "date_unlocked": DateTime.now(),
                  "unlocked": true,
                }
              });
            } else if (count < 3) {
              await _firestore
                  .collection("badges")
                  .doc(currentUser.uid)
                  .update({
                //update the count and latest date in the document
                "customizer_badge": {
                  "count": count,
                  "date_unlocked": null,
                  "unlocked": false,
                }
              });
            }
          }
        }
      }
    } catch (e) {
      Exception("Failed to unlock customizer badge: $e");
    }
  }

  void unlockSocialButterflyBadge(bool disconnect, String otherUserId) async {
    try {
      final currentUser = _auth.currentUser;

      if (currentUser != null) {
        DocumentSnapshot<Map<String, dynamic>> currentUserDoc =
            await _firestore.collection("badges").doc(currentUser.uid).get();
        Map<String, dynamic>? currentUserData = currentUserDoc.data();

        if (currentUserData != null) {
          int currentUserCount =
              currentUserData["social_butterfly_badge"]["count"];
          bool unlocked = currentUserData["social_butterfly_badge"]["unlocked"];

          if (!unlocked) // update only if its not already unlocked
          {
            if (!disconnect) {
              currentUserCount++;
            } else {
              currentUserCount--;
            }

            if (currentUserCount == 15) {
              await _firestore
                  .collection("badges")
                  .doc(currentUser.uid)
                  .update({
                //if the count is == 15 then update the document with the unlocked status
                "social_butterfly_badge": {
                  "count": currentUserCount,
                  "date_unlocked": DateTime.now(),
                  "unlocked": true,
                }
              });
            } else if (currentUserCount < 15) {
              await _firestore
                  .collection("badges")
                  .doc(currentUser.uid)
                  .update({
                //update the count and latest date in the document
                "social_butterfly_badge": {
                  "count": currentUserCount,
                  "date_unlocked": null,
                  "unlocked": false,
                }
              });
            }
          }
        }

        DocumentSnapshot<Map<String, dynamic>> otherUserDoc =
            await _firestore.collection("badges").doc(otherUserId).get();
        Map<String, dynamic>? otherUserData = otherUserDoc.data();

        if (otherUserData != null) {
          int otherUserCount = otherUserData["social_butterfly_badge"]["count"];
          bool unlocked = otherUserData["social_butterfly_badge"]["unlocked"];

          if (!unlocked) {
            // update only if its not already unlocked
            if (!disconnect) {
              otherUserCount++;
            } else {
              otherUserCount--;
            }

            if (otherUserCount == 15) {
              await _firestore.collection("badges").doc(otherUserId).update({
                //if the count is == 15 then update the document with the unlocked status
                "social_butterfly_badge": {
                  "count": otherUserCount,
                  "date_unlocked": DateTime.now(),
                  "unlocked": true,
                }
              });
            } else if (otherUserCount < 15) {
              await _firestore.collection("badges").doc(otherUserId).update({
                //update the count and latest date in the document
                "social_butterfly_badge": {
                  "count": otherUserCount,
                  "date_unlocked": null,
                  "unlocked": false,
                }
              });
            }
          }
        }
      }
    } catch (e) {
      Exception("Failed to unlock social butterfly badge: $e");
    }
  }

  void unlockNightOwlBadge(DateTime time) async {
    bool isPastNightOwlTime = time.hour > 22 ||
        (time.hour == 22 &&
            time.minute >= 15 &&
            time.second >= 0); //check if the time is past 10:15 PM

    if (isPastNightOwlTime) {
      final currentUser = _auth.currentUser;

      if (currentUser != null) {
        DocumentSnapshot<Map<String, dynamic>> doc =
            await _firestore.collection("badges").doc(currentUser.uid).get();
        Map<String, dynamic>? data =
            doc.data(); //get the corresponding document from firestore

        if (data != null) {
          bool unlocked = data["nightowl_badge"]["unlocked"] ??
              false; //check if the badge is already unlocked

          if (unlocked) {
            return; //if it is already unlocked then return
          }

          await _firestore.collection("badges").doc(currentUser.uid).update({
            //update the document with the unlocked status
            "nightowl_badge": {
              "date_unlocked": time,
              "unlocked": true,
            }
          });
        }
      }
    } else {
      return; //return if the time is not past 10:15 PM
    }
  }

  void unlockEventPlannerBadge() async {
    try {
      DateTime currentDate = DateTime.now(); //get the current date
      final currentUser = _auth.currentUser; //get the current user

      if (currentUser != null) {
        DocumentSnapshot<Map<String, dynamic>> doc =
            await _firestore.collection("badges").doc(currentUser.uid).get();
        Map<String, dynamic>? data =
            doc.data(); //get the corresponding document from firestore

        if (data != null) {
          bool unlocked = data["event_planner_badge"]["unlocked"] ??
              false; //check if the badge is already unlocked

          if (unlocked) {
            return; //if it is already unlocked then return
          }

          await _firestore.collection("badges").doc(currentUser.uid).update({
            "event_planner_badge": {
              "date_unlocked": currentDate,
              "unlocked": true,
            }
          });
        }
      }
    } catch (e) {
      throw Exception("Failed to unlock event planner badge: $e");
    }
  }

  void unlockGamerBadge() async {
    StatsTotalTimeService timeService = StatsTotalTimeService();
    try {
      DateTime currentDate = DateTime.now(); //get the current date
      final currentUser = _auth.currentUser; //get the current user

      if (currentUser != null) {
        DocumentSnapshot<Map<String, dynamic>> doc =
            await _firestore.collection("badges").doc(currentUser.uid).get();
        Map<String, dynamic>? data =
            doc.data(); //get the corresponding document from firestore

        if (data != null) {
          bool unlocked = data["gamer_badge"]["unlocked"] ??
              false; //check if the badge is already unlocked

          if (unlocked) {
            return; //if it is already unlocked then return
          }

          double time =await timeService.getTotalTimePlayedAll(currentUser.uid);
          
          if (time >= 20.0) {
            await _firestore.collection("badges").doc(currentUser.uid).update({
              "gamer_badge": {
                "date_unlocked": currentDate,
                "unlocked": true,
              }
            });
          }
        }
      }
    } catch (e) {
      throw Exception("Failed to unlock gamer badge: $e");
    }
  }

  //to unlock join_event you need to pass "join_event" as the component
  //to unlock view_help you need to pass "view_help" as the component
  //to unlock share_game you need to pass "share_game" as the component
  //to unlock created_chat you need to pass "created_chat" as the component
  //to unlock play_spaceshooter you need to pass "play_spaceshooter" as the component
  //to unlock changed_theme you need to pass "changed_theme" as the component
  void unlockExplorerComponent(String component) async {
    try {
      final currentUser = _auth.currentUser;

      if (currentUser != null) {
        DocumentSnapshot<Map<String, dynamic>> doc =
            await _firestore.collection("badges").doc(currentUser.uid).get();
        Map<String, dynamic>? data = doc.data();

        if (data != null) {
          bool unlocked = data["explorer_badge"]["unlocked"];
          bool neededComponent = data["explorer_badge"][component];

          if (unlocked == false && neededComponent == false) {
            //Only update if its not unlocked yet

            int unlockedComponents =
                data["explorer_badge"]["unlocked_components"];

            unlockedComponents++; // new component unlocked

            if (unlockedComponents == 12) {
              //unlocked every component
              await _firestore
                  .collection("badges")
                  .doc(currentUser.uid)
                  .update({
                "explorer_badge.unlocked_components": unlockedComponents,
                "explorer_badge.date_unlocked": DateTime.now(),
                "explorer_badge.$component": true,
                "explorer_badge.unlocked": true,
              });
            } else if (unlockedComponents < 12) {
              //still have more components to unlock
              await _firestore
                  .collection("badges")
                  .doc(currentUser.uid)
                  .update({
                "explorer_badge.unlocked_components": unlockedComponents,
                "explorer_badge.date_unlocked": null,
                "explorer_badge.$component": true,
                "explorer_badge.unlocked": false,
              });
            }
          }
        }
      }
    } catch (e) {
      Exception("Failed to unlock $component component: $e");
    }
  }

}
