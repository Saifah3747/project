import 'package:flutter/material.dart';
import '../models/locker.dart';
import '../models/transaction.dart';
import '../services/mqtt_service.dart';
import '../widgets/transaction_list.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LockerDashboard extends StatefulWidget {
  @override
  _LockerDashboardState createState() => _LockerDashboardState();
}

class _LockerDashboardState extends State<LockerDashboard> {
  Locker? locker;
  List<Transaction> transactions = [];
  final MqttService mqttService = MqttService();

  @override
  void initState() {
    super.initState();
    fetchData();
    setupMQTT();
  }

  void setupMQTT() {
    mqttService.onMessageReceived = (data) {
      setState(() {
        locker = Locker(
          lockerId: data['locker_id'],
          lockerName: locker?.lockerName ?? 'Locker A1',
          status: data['status'],
          lastOpenedBy: data['user'],
          updatedAt: DateTime.parse(data['timestamp']),
        );
      });
    };
    mqttService.connect();
  }

  Future<void> fetchData() async {
    try {
      final lockerRes = await http.get(Uri.parse('http://localhost/smart_locker_api/get_lockers.php'));
      final lockerData = json.decode(lockerRes.body);

      if (lockerData['status'] == 'success') {
        final l = lockerData['lockers'][0];
        locker = Locker(
          lockerId: l['locker_id'],
          lockerName: l['locker_name'],
          status: l['status'],
          lastOpenedBy: l['last_opened_by']?.toString(),
          updatedAt: DateTime.parse(l['updated_at']),
        );
      }

      final txRes = await http.get(Uri.parse('http://localhost/smart_locker_api/transactions.php'));
      final txData = json.decode(txRes.body);

      if (txData['status'] == 'success') {
        transactions = (txData['transactions'] as List)
            .map((e) => Transaction.fromJson(e))
            .toList();
      }

      setState(() {});
    } catch (e) {
      print('fetchData error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Smart Locker Dashboard')),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: locker == null
                ? Colors.grey
                : locker!.status == 'available'
                    ? Colors.green
                    : locker!.status == 'in_use'
                        ? Colors.red
                        : Colors.yellow,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Locker: ${locker?.lockerName ?? 'Loading...'}', style: TextStyle(fontSize: 20, color: Colors.white)),
                Text('Status: ${locker?.status ?? '-'}', style: TextStyle(fontSize: 16, color: Colors.white)),
                Text('Last opened by: ${locker?.lastOpenedBy ?? '-'}', style: TextStyle(fontSize: 16, color: Colors.white)),
                Text('Updated at: ${locker?.updatedAt?.toString() ?? '-'}', style: TextStyle(fontSize: 14, color: Colors.white70)),
              ],
            ),
          ),
          Expanded(
            child: TransactionList(transactions: transactions),
          ),
        ],
      ),
    );
  }
}
