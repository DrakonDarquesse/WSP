import 'package:app/models/duty_roster.dart';
import 'package:app/models/member.dart';
import 'package:app/models/role_deck.dart';
import 'package:app/models/role_member.dart';
import 'package:app/provider.dart';
import 'package:app/provider/roster_provider.dart';
import 'package:app/utils/colours.dart';
import 'package:app/utils/enum.dart';
import 'package:app/utils/validate.dart';
import 'package:app/widgets/all.dart';
import 'package:app/widgets/role_member_form.dart';
import 'package:app/widgets/use_role_set_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class RosterFormWidget extends ConsumerStatefulWidget {
  final DutyRoster? roster;
  const RosterFormWidget({
    Key? key,
    this.roster,
  }) : super(key: key);

  @override
  ConsumerState<RosterFormWidget> createState() => _RosterFormWidgetState();
}

class _RosterFormWidgetState extends ConsumerState<RosterFormWidget> {
  late final DutyRoster _roster;
  DateTime selectedDate = DateTime.now();

  void _changeRosterTitle(String value) {
    setState(() {
      _roster.title = value;
    });

    DutyRoster newRoster = DutyRoster(
        id: ref.read(rosterProvider).id,
        date: ref.read(rosterProvider).date,
        title: value,
        roleMembers: ref.read(rosterProvider).roleMembers);
    ref.read(rosterProvider.notifier).state = newRoster;
  }

  @override
  void initState() {
    _roster = widget.roster ??
        DutyRoster(date: DateTime.now(), title: "", roleMembers: []);

    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
        selectableDayPredicate: (DateTime d) {
          if (d.isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
            return true;
          }
          return false;
        });
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      DutyRoster newRoster = DutyRoster(
          id: ref.read(rosterProvider).id,
          date: picked,
          title: ref.read(rosterProvider).title,
          roleMembers: ref.read(rosterProvider).roleMembers);
      ref.read(rosterProvider.notifier).state = newRoster;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DutyRoster roster = ref.watch(rosterProvider);

    const List<Widget> header = [
      Expanded(
        child: TextWidget(
          text: [
            TextSpan(
              text: 'Role',
            ),
          ],
          compact: false,
        ),
      ),
      Expanded(
        child: TextWidget(
          text: [
            TextSpan(
              text: 'Member',
            ),
          ],
          compact: false,
        ),
      ),
      Expanded(
        child: TextWidget(
          text: [
            TextSpan(
              text: 'Status',
            ),
          ],
          compact: false,
        ),
      ),
    ];

    List<Widget> widgetList(val) {
      return [
        Expanded(
          child: TextWidget(
            text: [
              TextSpan(
                  text: roster.roleMembers[val].role.name,
                  style: TextStyle(
                      color: roster.roleMembers[val].status == Status.rejected
                          ? error()
                          : black())),
            ],
            compact: false,
          ),
        ),
        Expanded(
          child: TextWidget(
            text: [
              TextSpan(
                  text: roster.roleMembers[val].member.name,
                  style: TextStyle(
                      color: roster.roleMembers[val].status == Status.rejected
                          ? error()
                          : black())),
            ],
            compact: false,
          ),
        ),
        Expanded(
          child: TextWidget(
            text: [
              TextSpan(
                  text: roster.roleMembers[val].status.name,
                  style: TextStyle(
                      color: roster.roleMembers[val].status == Status.rejected
                          ? error()
                          : black())),
            ],
            compact: false,
          ),
        ),
      ];
    }

    return Column(
      children: [
        Row(
          children: [
            TextWidget(text: [
              TextSpan(
                text: 'Date: ${DateFormat('yMd').format(selectedDate)}',
                style: Theme.of(context).textTheme.headline6,
              ),
              if (ref.watch(modeProvider) == Mode.add)
                TextSpan(
                  text: '\nPick a date first to check member\'s availability',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
            ]),
            if (ref.watch(sessionProvider.notifier).role == 'admin')
              ButtonWidget(
                  text: 'Pick Date',
                  callback: () async {
                    await _selectDate(context);
                  }),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        FormWidget(
          info: 'Title',
          helper: 'Simple the best',
          save: (String? value) {
            _changeRosterTitle(value!);
          },
          validator: (String? value) {
            return checkEmpty(value);
          },
          initialValue: roster.title,
          readOnly: ref.watch(sessionProvider.notifier).role != 'admin',
        ),
        if (ref.watch(sessionProvider.notifier).role == 'admin')
          Row(
            children: [
              if (ref.watch(modeProvider) == Mode.add)
                ButtonWidget(
                  text: 'Use Role Set',
                  callback: () async {
                    RoleDeck roleDeck = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const UseRoleSetForm();
                      },
                    );

                    List<RoleMember> roleMembers = roleDeck.roles
                        .map<RoleMember>(
                            (e) => RoleMember(role: e, member: Member.empty()))
                        .toList();

                    DutyRoster newRoster = DutyRoster(
                        id: ref.read(rosterProvider).id,
                        date: ref.read(rosterProvider).date,
                        title: ref.read(rosterProvider).title,
                        roleMembers: roleMembers);
                    ref.watch(rosterProvider.notifier).state = newRoster;
                  },
                  icon: Icons.add_circle_outline_rounded,
                ),
              ButtonWidget(
                text: 'Add Role',
                callback: () {
                  ref.watch(modeProvider.notifier).state = Mode.add;
                  ref.read(roleProvider.notifier).reset();
                  ref.read(memberProvider.notifier).reset();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const RoleMemberForm();
                    },
                  );
                },
                icon: Icons.add_circle_outline_rounded,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 250),
          child: SingleChildScrollView(
            child: TableWidget(
              dataList: roster.roleMembers,
              widgetList: widgetList,
              header: header,
            ),
          ),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.end,
    );
  }
}
