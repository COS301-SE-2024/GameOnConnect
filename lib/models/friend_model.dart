class Friend {
  final String uid;
  final List<String> friends;
  final List<String> pending;

  Friend({required this.uid, required this.friends, required this.pending});

  factory Friend.fromMap(Map<String, dynamic> data) {
    return Friend(
      uid: data['userID'],
      friends: List<String>.from(data['friends']),
      pending: List<String>.from(data['pending']),
    );
  }
}
