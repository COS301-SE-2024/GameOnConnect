class BadgeModel {
  final String badgeName;
  final String badgeFile;
  final String badgeDescription;
  bool unlocked = false;
  DateTime dateUnlocked = DateTime.now();

  BadgeModel({required this.badgeName, required this.badgeFile, required this.badgeDescription});
}