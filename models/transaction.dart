class Transaction {
  int transactionId;
  int lockerId;
  int? userId;
  String action;
  String? rfidTag;
  DateTime timestamp;

  Transaction({
    required this.transactionId,
    required this.lockerId,
    this.userId,
    required this.action,
    this.rfidTag,
    required this.timestamp,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: int.parse(json['transaction_id'].toString()),
      lockerId: int.parse(json['locker_id'].toString()),
      userId: json['user_id'] != null ? int.parse(json['user_id'].toString()) : null,
      action: json['action'],
      rfidTag: json['rfid_tag'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
