import 'package:app/models/role.dart';
import 'package:app/widgets/all.dart';
import 'package:flutter/material.dart';

class PendingRequest extends StatefulWidget {
  const PendingRequest({
    Key? key,
  }) : super(key: key);

  @override
  State<PendingRequest> createState() => _PendingRequestState();
}

class _PendingRequestState extends State<PendingRequest> {
  IconData icon = Icons.feedback_outlined;
  List<Map> list = [
    {
      'dateTime': DateTime.now(),
      'event': Role(name: 'Song Lead', task: 'Sing').name,
    },
    {
      'dateTime': DateTime.now(),
      'event': Role(name: 'Usher', task: 'Welcome people').name,
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
