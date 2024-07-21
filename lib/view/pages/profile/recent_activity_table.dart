import 'package:flutter/material.dart';
import 'package:gameonconnect/model/Stats_M/game_stats.dart';

class RecentActivityTable extends StatelessWidget {
  final List<GameStats> mockData = [
    GameStats(
      gameId: 'Fortnite',
      lastPlayed: '17/07/2024 at 19:26',
      date:'17/07/2024',
      time:'19:26',
      mood: 'Joy',
      timePlayedLast: '1',
    ),
    GameStats(
      gameId: 'Portal 2',
      lastPlayed: '2 July 2024 at 03:11:11',
      date:'2/07/2024',
      time:'03:11',
      mood: 'Disgust',
      timePlayedLast: '3',
    ),
    GameStats(
      gameId: 'Game 3',
      lastPlayed: '23 June 2024 at 12:04:11',
      date:'2 days ago',
      time:'12:04',
      mood: 'Fear',
      timePlayedLast: '3.6',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(title: const Text('Recent Activities')),
        body: SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child:Column(
    children: [
      DataTable(
           columns: [
              const DataColumn(
                label: const Text(
                  'Game',
                  style: TextStyle(
                  fontWeight: FontWeight.bold,
                  )
                )
              ),
              const DataColumn(
                label: Text(
                  'Mood',
                  style: TextStyle(
                  fontWeight: FontWeight.bold,
                  )
                )
              ),
              const DataColumn(
                label: Text(
                  'Time(h)',
                  style: TextStyle(
                  fontWeight: FontWeight.bold,
                  )
                )
              ),
              const DataColumn(
                label: Text(
                  'Last Played',
                  style: TextStyle(
                  fontWeight: FontWeight.bold,
                  )
                )
              ),
              DataColumn(label: Text('')),
            ],
          rows: mockData.map((game) {
              return DataRow(cells: [
                //DataCell(Text(game.gameId)),
                DataCell(Row(
                  children: [
                    CircleAvatar(
                      radius: 16, // Adjust the size as needed
                      backgroundImage: NetworkImage('https://cdn2.unrealengine.com/15br-bplaunch-egs-s3-2560x1440-2560x1440-687570387.jpg'),
                      
                    ),
                    SizedBox(width: 8), // Add spacing between avatar and text
                    Text(game.gameId),
                  ],
                )),
                DataCell(Text(game.mood)),
                DataCell(Text(game.timePlayedLast)),
                DataCell(Text('${game.date} | ${game.time}')),
                DataCell(IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        //delete row 
                      },
                    )),
              ]);
            }).toList(),
        ),
    ],
  ), 
  
  ),
       
      );
    
  }
}