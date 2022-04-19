import 'package:app/models/duty_roster.dart';
import 'package:app/models/member.dart';
import 'package:app/models/role.dart';
import 'package:app/models/role_member.dart';
import 'package:app/network/member.dart';
import 'package:app/network/role.dart';
import 'package:app/network/roster.dart';
import 'package:app/provider.dart';
import 'package:app/provider/roster_provider.dart';
import 'package:app/utils/enum.dart';
import 'package:app/utils/size.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class VolunteerDialog extends ConsumerWidget {
  const VolunteerDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    void setAndReset(DutyRoster newRoster) {
      ref.read(roleProvider.notifier).reset();
      ref.read(memberProvider.notifier).reset();
      ref.read(rosterProvider.notifier).state = newRoster;
    }

    List<Widget> widgets = [
      TextWidget(text: [
        TextSpan(
          text: 'Volunteer to serve?',
          style: Theme.of(context).textTheme.headline5,
        ),
      ]),
      TextWidget(text: [
        TextSpan(
          text: DateFormat('yMd').format(ref.watch(rosterProvider).date),
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ]),
      TextWidget(text: [
        TextSpan(
          text: ref.watch(roleProvider).name,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ]),
      const Divider(),
      ButtonWidget(
        text: 'Yes, I volunteer',
        callback: () async {
          RoleMember newRoleMember = RoleMember(
              role: ref.watch(roleProvider),
              member: ref.watch(sessionProvider)!,
              status: Status.accepted);
          ref
              .read(rosterProvider)
              .roleMembers
              .remove(ref.read(tempRoleMemberProvider));

          DutyRoster newRoster = DutyRoster(
              id: ref.read(rosterProvider).id,
              date: ref.watch(rosterProvider).date,
              title: ref.watch(rosterProvider).title,
              roleMembers: [
                ...ref.watch(rosterProvider).roleMembers,
                newRoleMember
              ]);
          setAndReset(newRoster);
          await editRoster(ref.read(rosterProvider)).then((value) {
            ref.read(rosterListProvider.notifier).load();
            Navigator.of(context, rootNavigator: true).pop();
          });
        },
      ),
    ];
    return Dialog(
      child: Container(
        child: Column(
          children: widgets,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 320, vertical: 0),
    );
  }
}
