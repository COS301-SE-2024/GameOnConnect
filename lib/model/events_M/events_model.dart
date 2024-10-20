class Event {
  final String creatorID;
  late final DateTime startDate;
  final DateTime endDate;
  final String eventType;
  late final int gameID;
  late final String name;
  final String eventID;
  final List<dynamic> subscribed;
  final List<dynamic> participants;
  late final String description;
  final bool privacy;
  late final List<String> invited;
  final String creatorName;
  // can later add  conversation id and teams if needed

  Event(
      {required this.creatorID,
      required this.startDate,
      required this.endDate,
      required this.eventType,
      required this.gameID,
      required this.name,
      required this.eventID,
      required this.subscribed,
      required this.participants,
      required this.description,
      required this.privacy,
        required this.invited,
         required this.creatorName
      });

  factory Event.fromMap(Map<String, dynamic> data, String id) {
    return Event(
        creatorID: data['creatorID'],
        startDate: data['start_date'].toDate(),
        endDate: data['end_date'].toDate(),
        eventType: data['eventType'],
        gameID: data['gameID'],
        name: data['name'],
        eventID: id,
        subscribed: data['subscribed'],
        participants: data['participants'],
        description: data['description'],
        privacy: data['privacy'],
        invited: List<String>.from(data['invited']),
      creatorName: data['creatorName']
    );
  }
}
