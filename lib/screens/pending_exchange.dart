import 'package:app/models/duty_roster.dart';
import 'package:app/models/exchange.dart';
import 'package:app/models/role_member.dart';
import 'package:app/network/exchange.dart';
import 'package:app/network/roster.dart';
import 'package:app/provider.dart';
import 'package:app/utils/enum.dart';
import 'package:app/utils/member_roster.dart';
import 'package:app/widgets/all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PendingExchange extends ConsumerWidget {
  const PendingExchange({
    Key? key,
  }) : super(key: key);

  final IconData icon = Icons.swap_horiz;

  @override
  Widget build(BuildContext context, ref) {
    List<Exchange> pendingReq = getExchange(
        ref.watch(sessionProvider), ref.watch(exchangeListProvider));
    if (pendingReq.isEmpty) {
      return const Center(child: Text('No Exchange'));
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        DutyRoster roster = ref
            .watch(rosterListProvider)
            .firstWhere((roster) => roster.id == pendingReq[index].targetid);
        DutyRoster rosterb = ref
            .watch(rosterListProvider)
            .firstWhere((roster) => roster.id == pendingReq[index].sourceid);
        return ListTileWidget(
          dateTime: rosterb.date,
          event: pendingReq[index].source.role.name,
          icon: icon,
          trailing: [
            {
              'text': 'Reject',
              'onPressed': () {
                pendingReq[index].status = 'done';

                editExchange(pendingReq[index]).then(
                  (value) {
                    ref.read(exchangeListProvider.notifier).load();
                  },
                );
              },
            },
            {
              'text': 'Accept',
              'onPressed': () {
                pendingReq[index].source.status = Status.accepted;
                pendingReq[index].target.status = Status.accepted;
                roster.roleMembers.add(pendingReq[index].target);
                roster.roleMembers.remove(pendingReq[index].source);
                rosterb.roleMembers.add(pendingReq[index].source);
                rosterb.roleMembers.remove(pendingReq[index].target);

                editRoster(roster).then(
                  (value) {
                    ref.read(rosterListProvider.notifier).load();
                  },
                );

                editRoster(rosterb).then(
                  (value) {
                    ref.read(rosterListProvider.notifier).load();
                  },
                );

                pendingReq[index].status = 'done';

                editExchange(pendingReq[index]).then(
                  (value) {
                    ref.read(exchangeListProvider.notifier).load();
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
