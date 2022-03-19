import 'package:app/widgets/list_tile_widget.dart';
import 'package:flutter/material.dart';

class AcceptedDuty extends StatefulWidget {
  const AcceptedDuty({
    Key? key,
  }) : super(key: key);

  @override
  State<AcceptedDuty> createState() => _AcceptedDutyState();
}

class _AcceptedDutyState extends State<AcceptedDuty> {
  IconData icon = Icons.event_available_rounded;
  List<Map> list = [
    // {
    //   'dateTime': DateTime.now(),
    //   'event': Role(name: 'Song Lead', task: 'Sing').name,
    // },
    // {
    //   'dateTime': DateTime.now(),
    //   'event': Role(name: 'Usher', task: 'Welcome people').name,
    // }
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
