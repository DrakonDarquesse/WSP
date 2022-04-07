import 'package:app/models/duty_roster.dart';
import 'package:app/network/roster.dart';
import 'package:app/provider.dart';
import 'package:app/utils/enum.dart';
import 'package:app/utils/member_roster.dart';
import 'package:app/widgets/all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PendingRequest extends ConsumerWidget {
  const PendingRequest({
    Key? key,
  }) : super(key: key);

  final IconData icon = Icons.feedback_outlined;

  @override
  Widget build(BuildContext context, ref) {
    List<Map<String, dynamic>> req = getMemberRoster(
        ref.watch(sessionProvider), ref.watch(rosterListProvider));
    List<Map<String, dynamic>> pendingReq = getPending(req);
    if (pendingReq.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        DutyRoster roster = ref
            .watch(rosterListProvider)
            .singleWhere((roster) => roster.id == pendingReq[index]['id']);
        return ListTileWidget(
          dateTime: pendingReq[index]['date'],
          event: pendingReq[index]['roleMember'].role.name,
          icon: icon,
          trailing: [
            {
              'text': 'Reject',
              'onPressed': () {
                roster.roleMembers
                    .singleWhere((rm) => rm == pendingReq[index]['roleMember'])
                    .status = Status.rejected;
                editRoster(roster).then(
                  (value) {
                    ref.read(rosterListProvider.notifier).load();
                  },
                );
              },
            },
            {
              'text': 'Accept',
              'onPressed': () {
                roster.roleMembers
                    .singleWhere((rm) => rm == pendingReq[index]['roleMember'])
                    .status = Status.accepted;
                editRoster(roster).then(
                  (value) {
                    ref.read(rosterListProvider.notifier).load();
                  },
                );
              }
            }
          ],
        );
      },
      itemCount: pendingReq.length,
    );
  }
}
