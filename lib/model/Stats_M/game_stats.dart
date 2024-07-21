class GameStats{
  final String gameId;
  final String lastPlayed;
  final String mood; // In hours
  final String timePlayedLast;

  GameStats({
    required this.gameId,
    required this.lastPlayed,
    required this.mood,
    required this.timePlayedLast
  });
}

//DateTime firestoreDateTime = snapshot.data.documents[index].data['timestamp'].toDate();
/**
 * import 'package:intl/intl.dart';

// Assuming you already have the Firestore timestamp as 'firestoreDateTime'
String formattedDate = DateFormat.yMMMd().format(firestoreDateTime); // Format date
int hour = firestoreDateTime.hour; // Hour
int minute = firestoreDateTime.minute; 
 */