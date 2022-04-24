import 'package:app/models/duty_roster.dart';
import 'package:app/models/role_member.dart';
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
          event: pendingReq[index]['roleMember'].role.name +
              (pendingReq[index]['roleMember'].status == Status.change
                  ? ' (Exchange)'
                  : ''),
          icon: icon,
          trailing: [
            {
              'text': 'Reject',
              'onPressed': () {
                if (pendingReq[index]['roleMember'].status == Status.change) {
                  DutyRoster toBeChangedRoster = ref
                      .watch(rosterListProvider)
                      .firstWhere((roster) =>
                          roster.id == pendingReq[index]['roleMember'].link);
                  RoleMember toBeRestored = toBeChangedRoster.roleMembers
                      .firstWhere(
                          (e) => e == pendingReq[index]['roleMember'].src);
                  print(roster.roleMembers.length);
                  roster.roleMembers
                      .firstWhere((e) => e == toBeRestored.src)
                      .status = Status.unattended;
                  print(toBeRestored.member.name);
                  toBeRestored.status = Status.accepted;
                  toBeRestored.src = null;
                  toBeRestored.link = null;

                  editRoster(toBeChangedRoster).then(
                    (value) {
                      ref.read(rosterListProvider.notifier).load();
                    },
                  );
                }
                roster.roleMembers.remove(pendingReq[index]['roleMember']);
                print(roster.roleMembers.length);

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
                if (pendingReq[index]['roleMember'].status == Status.change) {
                  DutyRoster toBeChangedRoster = ref
                      .watch(rosterListProvider)
                      .firstWhere((roster) =>
                          roster.id == pendingReq[index]['roleMember'].link);
                  RoleMember toBeChanged = toBeChangedRoster.roleMembers
                      .firstWhere(
                          (e) => e == pendingReq[index]['roleMember'].src);
                  print(toBeChanged.src!.member.name);
                  toBeChanged.status = Status.accepted;
                  toBeChanged.member = toBeChanged.src!.member;
                  print(roster.roleMembers.length);
                  roster.roleMembers.removeWhere((e) => e == toBeChanged.src!);
                  toBeChanged.src = null;
                  toBeChanged.link = null;

                  editRoster(toBeChangedRoster).then(
                    (value) {
                      ref.read(rosterListProvider.notifier).load();
                    },
                  );
                }
                pendingReq[index]['roleMember'].status = Status.accepted;
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
