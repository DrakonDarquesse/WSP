import 'package:app/models/duty_roster.dart';
import 'package:app/models/exchange.dart';
import 'package:app/models/role_member.dart';
import 'package:app/network/exchange.dart';
import 'package:app/network/roster.dart';
import 'package:app/provider.dart';
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
        ref.watch(sessionProvider.notifier).signedIn == true
            ? getMemberRoster(
                ref.watch(sessionProvider), ref.watch(rosterListProvider))
            : [];
    List<Map<String, dynamic>> acceptedReq = getAccepted(req);
    if (acceptedReq.isEmpty) {
      return const Center(child: Text('No Accepted'));
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTileWidget(
          dateTime: acceptedReq[index]['date'],
          event: acceptedReq[index]['roleMember'].role.name,
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
                        return ExchangeDialog(
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
                      RoleMember aRM = aRoster.roleMembers
                          .singleWhere((rm) => rm == something['roleMember']);

                      Exchange exchange = Exchange(
                          target: aRM,
                          source: theRM,
                          targetid: acceptedReq[index]['id'],
                          sourceid: something['id']);

                      addExchange(exchange);

                      editRoster(aRoster).then(
                        (value) {
                          ref.read(exchangeListProvider.notifier).load();
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
              },
            if (acceptedReq[index]['roleMember'].status == Status.unattended)
              {
                'text': 'Seek Exchange',
                'onPressed': () async {
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
                      return ExchangeDialog(
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
                    RoleMember aRM = aRoster.roleMembers
                        .singleWhere((rm) => rm == something['roleMember']);

                    Exchange exchange = Exchange(
                        target: aRM,
                        source: theRM,
                        targetid: acceptedReq[index]['id'],
                        sourceid: something['id']);

                    addExchange(exchange);

                    editRoster(aRoster).then(
                      (value) {
                        ref.read(exchangeListProvider.notifier).load();
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
          ],
        );
      },
      itemCount: acceptedReq.length,
    );
  }
}
