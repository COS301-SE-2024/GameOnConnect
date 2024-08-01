class Event {
  final String creatorID;
  final DateTime startDate;
  final DateTime endDate;
  final String eventType;
  final int gameID;
  final String name;
  final String eventID;
  final List<dynamic> subscribed;
  final List<dynamic> participants;
  final String description;
  final bool privacy;
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
      required this.privacy});

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

    );
  }
}
