import 'package:flutter/material.dart';

class ViewLeaderboard extends StatefulWidget {
  const ViewLeaderboard({super.key});

  @override
  State<ViewLeaderboard> createState() => _ViewLeaderboardState();
}

//NB rename
class _ViewLeaderboardState extends State<ViewLeaderboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leaderboard",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () {
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewLeaderboard(),
                  ),
                ); */
              },
              icon: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.primary,
                size: 25.0,
              ),
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Poker Tournament',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 25,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  MaterialButton(
                    height: 30,
                    onPressed: () {
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewLeaderboard()));
                    },
                    color: Theme.of(context).colorScheme.surface,
                    textColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Rounded corners
                      side: BorderSide(
                        color:
                            Theme.of(context).colorScheme.primary, // Green edge
                      ),
                    ),
                    child: const Text(
                      'Edit Scores',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const SizedBox(
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //here the components will go for each user in the rankings
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
