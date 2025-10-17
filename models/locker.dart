class Locker {
  int lockerId;
  String lockerName;
  String status;
  String? lastOpenedBy;
  DateTime? updatedAt;

  Locker({
    required this.lockerId,
    required this.lockerName,
    required this.status,
    this.lastOpenedBy,
    this.updatedAt,
  });
}
