import 'package:app/widgets/list_tile_widget.dart';
import 'package:flutter/material.dart';

class BlockedDates extends StatefulWidget {
  const BlockedDates({
    Key? key,
  }) : super(key: key);

  @override
  State<BlockedDates> createState() => _BlockedDatesState();
}

class _BlockedDatesState extends State<BlockedDates> {
  IconData icon = Icons.event_busy;
  List<Map> list = [
    {
      'dateTime': DateTime.now(),
      'event': 'Outstation',
    },
    {
      'dateTime': DateTime.now(),
      'event': 'Birthday',
    }
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTileWidget(
          dateTime: list[index]['dateTime'],
          event: list[index]['event'],
          icon: icon,
        );
      },
      itemCount: list.length,
    );
  }
}
