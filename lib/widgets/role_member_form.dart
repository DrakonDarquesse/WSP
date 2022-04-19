import 'package:app/models/blocked_date.dart';
import 'package:app/models/duty_roster.dart';
import 'package:app/models/member.dart';
import 'package:app/models/role_member.dart';
import 'package:app/provider.dart';
import 'package:app/provider/roster_provider.dart';
import 'package:app/utils/colours.dart';
import 'package:app/utils/enum.dart';
import 'package:app/widgets/all.dart';
import 'package:app/widgets/choice_chips_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final roleIndexProvider = StateProvider.autoDispose<int?>((ref) {
  if (ref.watch(roleProvider).name.isEmpty) return null;
  return ref.watch(roleListProvider).indexOf(ref.watch(roleProvider));
});

final memberIndexProvider = StateProvider.autoDispose<int?>((ref) {
  return null;
});

final filteredMembersProvider = StateProvider.autoDispose<List<Member>>((ref) {
  if (ref.watch(roleProvider).name.isEmpty) return [];
  return ref
      .watch(memberListProvider)
      .where((m) => m.roles.contains(ref.watch(roleProvider)))
      .where((m) => !ref
          .watch(rosterProvider)
          .roleMembers
          .contains(RoleMember(role: ref.watch(roleProvider), member: m)))
      .toList();
});

class RoleMemberForm extends ConsumerWidget {
  const RoleMemberForm({
    Key? key,
  }) : super(key: key);

  bool _isSelected(int? selectedIndex, int index) {
    if (selectedIndex != index) return false;
    return true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roles = ref.watch(roleListProvider);
    final members = ref.watch(memberListProvider);
    final filteredMembers = ref.watch(filteredMembersProvider);
    final int? selectedRoleIndex = ref.watch(roleIndexProvider);
    final int? selectedMemberIndex = ref.watch(memberIndexProvider);

    void setAndReset(DutyRoster newRoster) {
      ref.read(roleProvider.notifier).reset();
      ref.read(memberProvider.notifier).reset();
      ref.read(rosterProvider.notifier).state = newRoster;
    }

    return Dialog(
      child: Container(
        child: Column(
          children: [
            TextWidget(
              text: [
                TextSpan(
                  text: 'Add Role and Member',
                  style: Theme.of(context).textTheme.headline5,
                )
              ],
            ),
            TextWidget(text: [
              TextSpan(
                text: 'Select Role',
                style: Theme.of(context).textTheme.subtitle1,
              )
            ]),
            roles.isNotEmpty
                ? ChoiceChipsWidget(
                    choice: roles,
                    onSelect: (select, role) {
                      if (select) {
                        ref.read(roleProvider.notifier).assign(role);
                        ref.read(roleIndexProvider.notifier).state =
                            roles.indexOf(role);
                        ref.read(filteredMembersProvider.notifier).state =
                            members
                                .where((m) => m.roles.contains(role))
                                .where((m) => !ref
                                    .watch(rosterProvider)
                                    .roleMembers
                                    .contains(RoleMember(
                                        role: ref.watch(roleProvider),
                                        member: m)))
                                .toList();
                      }
                    },
                    isSelect: (role) {
                      return _isSelected(
                          selectedRoleIndex, roles.indexOf(role));
                    },
                    color: (role) {
                      return role.color.withOpacity(0.15);
                    },
                  )
                : const Center(child: CircularProgressIndicator()),
            TextWidget(text: [
              TextSpan(
                text: 'Choose a member to be assigned',
                style: Theme.of(context).textTheme.subtitle1,
              )
            ]),
            filteredMembers.isNotEmpty
                ? ChoiceChipsWidget(
                    choice: filteredMembers,
                    onSelect: (select, member) {
                      if (select) {
                        ref.read(memberProvider.notifier).assign(member);
                        ref.read(memberIndexProvider.notifier).state =
                            filteredMembers.indexOf(member);
                      }
                    },
                    isSelect: (member) {
                      return _isSelected(
                          selectedMemberIndex, filteredMembers.indexOf(member));
                    },
                    color: (m) {
                      Member member = m as Member;

                      if (member.blockedDates.contains(
                          BlockedDate(date: ref.watch(rosterProvider).date))) {
                        return red().withOpacity(0.25);
                      }
                      if (ref
                          .watch(rosterProvider)
                          .getMembers()
                          .contains(member)) {
                        return red().withOpacity(0.5);
                      }
                      return blue().withOpacity(0.55);
                    },
                  )
                : Center(
                    child: Text(ref.watch(roleProvider).name != ''
                        ? 'No member to can be assigned'
                        : 'Pick a role first to see who is available'),
                  ),
            if (ref.watch(modeProvider) == Mode.edit &&
                ref.watch(tempRoleMemberProvider)?.member.name != '')
              Column(
                children: [
                  TextWidget(
                    text: [
                      TextSpan(
                        text: 'Currently Assigned Member',
                        style: Theme.of(context).textTheme.subtitle1,
                      )
                    ],
                  ),
                  Wrap(
                    children: ref
                        .watch(rosterProvider)
                        .roleMembers
                        .where((rm) => rm.role == ref.watch(roleProvider))
                        .map<Chip>((choice) {
                      return Chip(
                        avatar: CircleAvatar(
                          backgroundColor: blue(),
                          child: Text(
                            choice.member.name[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        label: Text(choice.member.name),
                        backgroundColor: blue().withOpacity(0.55),
                      );
                    }).toList(),
                    runSpacing: 8,
                    spacing: 10,
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.start,
              ),
            const Divider(),
            if (ref.watch(modeProvider) == Mode.add)
              ButtonWidget(
                  text: 'Add',
                  callback: () async {
                    RoleMember newRoleMember = RoleMember(
                        role: ref.read(roleProvider),
                        member: ref.read(memberProvider));
                    ref.read(rosterProvider).roleMembers.add(newRoleMember);
                    DutyRoster newRoster = DutyRoster(
                        id: ref.read(rosterProvider).id,
                        date: ref.read(rosterProvider).date,
                        title: ref.read(rosterProvider).title,
                        roleMembers: ref.read(rosterProvider).roleMembers);
                    setAndReset(newRoster);
                    Navigator.of(context, rootNavigator: true).pop();
                  }),
            if (ref.watch(modeProvider) == Mode.edit) ...[
              ButtonWidget(
                  text: 'Save Change',
                  callback: () async {
                    RoleMember newRoleMember = RoleMember(
                        role: ref.watch(roleProvider),
                        member: ref.watch(memberProvider));
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
                    Navigator.of(context, rootNavigator: true).pop();
                  }),
              ButtonWidget(
                text: 'Delete',
                callback: () async {
                  ref
                      .read(rosterProvider)
                      .roleMembers
                      .remove(ref.read(tempRoleMemberProvider));
                  DutyRoster newRoster = DutyRoster(
                    id: ref.read(rosterProvider).id,
                    date: ref.watch(rosterProvider).date,
                    title: ref.watch(rosterProvider).title,
                    roleMembers: ref.watch(rosterProvider).roleMembers,
                  );
                  setAndReset(newRoster);
                  Navigator.of(context, rootNavigator: true).pop();
                },
                color: red(),
              )
            ]
          ],
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 320, vertical: 0),
    );
  }
}
