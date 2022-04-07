import 'package:app/provider.dart';
import 'package:app/utils/member_roster.dart';
import 'package:app/widgets/list_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AcceptedDuty extends ConsumerWidget {
  const AcceptedDuty({
    Key? key,
  }) : super(key: key);

  final IconData icon = Icons.event_available_rounded;

  @override
  Widget build(BuildContext context, ref) {
    List<Map<String, dynamic>> req = getMemberRoster(
        ref.watch(sessionProvider), ref.watch(rosterListProvider));
    List<Map<String, dynamic>> acceptedReq = getAccepted(req);
    if (acceptedReq.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTileWidget(
          dateTime: acceptedReq[index]['date'],
          event: acceptedReq[index]['roleMember'].role.name,
          icon: icon,
          trailing: [
            const {},
            {'text': 'action', 'onPressed': () {}}
          ],
        );
      },
      itemCount: acceptedReq.length,
    );
  }
}
