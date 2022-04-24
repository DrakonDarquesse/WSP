import 'package:app/models/duty_roster.dart';
import 'package:app/models/member.dart';
import 'package:app/models/role_deck.dart';
import 'package:app/models/role_member.dart';
import 'package:app/network/roster.dart';
import 'package:app/provider.dart';
import 'package:app/provider/roster_provider.dart';
import 'package:app/screens/exchange.dart';
import 'package:app/utils/enum.dart';
import 'package:app/utils/member_roster.dart';
import 'package:app/widgets/list_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AcceptedDuty extends ConsumerWidget {
  const AcceptedDuty({
    Key? key,
  }) : super(key: key);

  final IconData icon = Icons.event_available_rounded;

  @override
  Widget build(BuildContext context, ref) {
    List<Map<String, dynamic>> req =
        ref.watch(sessionProvider.notifier).signedIn
            ? getMemberRoster(
                ref.watch(sessionProvider), ref.watch(rosterListProvider))
            : [];
    List<Map<String, dynamic>> acceptedReq = getAccepted(req);
    print(req);
    if (acceptedReq.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTileWidget(
          dateTime: acceptedReq[index]['date'],
          event: acceptedReq[index]['roleMember'].role.name +
              (acceptedReq[index]['roleMember'].status == Status.changeTarget
                  ? ' (Requested)'
                  : ''),
          icon: icon,
          trailing: [
            if (acceptedReq[index]['roleMember'].status == Status.accepted)
              {
                'text': 'I cannot attend',
                'onPressed': () async {
                  bool ifReallyCannot = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                              'Cannot duty on ${DateFormat('yMd').format(acceptedReq[index]['date'])}?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        );
                      });

                  if (ifReallyCannot) {
                    DutyRoster theRoster = ref
                        .watch(rosterListProvider)
                        .singleWhere((e) => e.id == acceptedReq[index]['id']);
                    theRoster.roleMembers
                        .singleWhere(
                            (rm) => rm == acceptedReq[index]['roleMember'])
                        .status = Status.unattended;
                    Map<String, dynamic>? something = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Exchange(
                          toBeExchanged: acceptedReq[index],
                        );
                      },
                    );

                    if (something != null) {
                      DutyRoster aRoster = ref
                          .watch(rosterListProvider)
                          .singleWhere((e) => e.id == something['id']);

                      RoleMember theRM = theRoster.roleMembers.singleWhere(
                          (rm) => rm == acceptedReq[index]['roleMember']);

                      theRM.status = Status.changeSource;
                      theRM.link = something['id'];
                      theRM.src = RoleMember.shallow(something['roleMember']);

                      RoleMember aRM = aRoster.roleMembers
                          .singleWhere((rm) => rm == something['roleMember']);
                      aRM.status = Status.changeTarget;
                      aRM.link = acceptedReq[index]['id'];
                      aRM.src =
                          RoleMember.shallow(acceptedReq[index]['roleMember']);
                      theRoster.roleMembers.add(RoleMember(
                        role: acceptedReq[index]['roleMember'].role,
                        member: something['roleMember'].member,
                        status: Status.change,
                        src: RoleMember.shallow(something['roleMember']),
                        link: something['id'],
                      ));
                      editRoster(aRoster).then(
                        (value) {
                          ref.read(rosterListProvider.notifier).load();
                        },
                      );
                    }
                    editRoster(theRoster).then(
                      (value) {
                        ref.read(rosterListProvider.notifier).load();
                      },
                    );
                  }
                }
              }
          ],
        );
      },
      itemCount: acceptedReq.length,
    );
  }
}
