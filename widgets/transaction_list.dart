import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  TransactionList({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final tx = transactions[index];
        Color color;
        switch (tx.action) {
          case 'open':
            color = Colors.green;
            break;
          case 'close':
            color = Colors.blue;
            break;
          case 'failed_scan':
            color = Colors.red;
            break;
          default:
            color = Colors.grey;
        }
        return ListTile(
          leading: Icon(Icons.lock, color: color),
          title: Text('${tx.action} by ${tx.userId ?? 'Unknown'}'),
          subtitle: Text('${tx.timestamp}'),
        );
      },
    );
  }
}
