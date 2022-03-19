import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListTileWidget extends StatelessWidget {
  final DateTime dateTime;
  final String event;
  final VoidCallback? callback;
  final IconData icon;

  const ListTileWidget({
    Key? key,
    required this.dateTime,
    required this.event,
    this.callback,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: SizedBox(
          child: Icon(
            icon,
            size: 32,
          ),
          height: double.infinity,
        ),
        title: Text(DateFormat('yMd').format(dateTime)),
        subtitle: Text(event),
        trailing: const Icon(Icons.more_vert),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      margin: const EdgeInsets.all(10),
      elevation: 1.5,
    );
  }
}
