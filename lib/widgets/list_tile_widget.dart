import 'package:app/models/role.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app/utils/colours.dart';

class ListTileWidget extends StatelessWidget {
  final DateTime? dateTime;
  final Role? role;
  final String event;
  final VoidCallback? callback;
  final IconData icon;
  final List<Map> trailing;

  const ListTileWidget({
    Key? key,
    this.dateTime,
    this.role,
    required this.event,
    this.callback,
    required this.icon,
    required this.trailing,
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
        title: dateTime != null
            ? Text(DateFormat('yMd').format(dateTime!))
            : Text(role!.name),
        subtitle: Text(event),
        trailing: Row(children: [
          if (trailing[0].isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: MaterialButton(
                child: Text(
                  trailing[0]['text'],
                ),
                padding: const EdgeInsets.all(16),
                color: yellow(),
                minWidth: 0,
                onPressed: trailing[0]['onPressed'],
              ),
            ),
          MaterialButton(
            onPressed: trailing[1]['onPressed'],
            child: Text(
              trailing[1]['text'],
            ),
            padding: const EdgeInsets.all(16),
            color: lightBlue(),
            minWidth: 0,
          )
        ], mainAxisSize: MainAxisSize.min),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      margin: const EdgeInsets.all(10),
      elevation: 1.5,
    );
  }
}
