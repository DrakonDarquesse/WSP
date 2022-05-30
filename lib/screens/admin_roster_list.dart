import 'package:app/models/duty_roster.dart';
import 'package:app/models/member.dart';
import 'package:app/models/role.dart';
import 'package:app/models/role_member.dart';
import 'package:app/network/message.dart';
import 'package:app/provider.dart';
import 'package:app/provider/roster_provider.dart';
import 'package:app/utils/colours.dart';
import 'package:app/utils/enum.dart';
import 'package:app/utils/make_mesaage.dart';
import 'package:app/utils/organize_roster.dart';
import 'package:app/widgets/all.dart';
import 'package:app/widgets/custom_app_bar.dart';
import 'package:app/widgets/mobile_roster.dart';
import 'package:app/widgets/volunteer_dialog.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/adaptive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AdminRosterList extends ConsumerWidget {
  const AdminRosterList({
    Key? key,
  }) : super(key: key);

  final IconData personIcon = Icons.event_note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roles = ref.watch(roleListProvider);
    final rosters = ref.watch(rosterListProvider);

    Widget notifyBtn = ButtonWidget(
      text: 'Notify Update',
      callback: () {
        Member? m = ref.read(sessionProvider);
        sendMessage(m!.id!);
      },
      icon: Icons.send,
    );

    Widget addBtn = ButtonWidget(
      text: 'Add',
      callback: () {
        ref.watch(modeProvider.notifier).state = Mode.add;
        ref.watch(rosterProvider.notifier).state =
            DutyRoster(date: DateTime.now(), title: "", roleMembers: []);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AddDialogWidget(
              text: 'Add ${ref.read(modelProvider).name}',
            );
          },
        );
      },
      icon: Icons.add_circle_outline_rounded,
    );

    List<Widget> Function(int) getWidgetList(List<DutyRoster> aRoster) {
      Set<Role> roleOrders = aRoster.first.getRoles();
      List<Widget> widgetList(val) {
        return [
          Expanded(
            child: TextWidget(
              text: [
                TextSpan(
                  text: DateFormat('yMd').format(aRoster[val].date),
                ),
              ],
              compact: false,
            ),
          ),
          Expanded(
            child: TextWidget(
              text: [TextSpan(text: aRoster[val].title)],
              compact: false,
            ),
          ),
          ...roleOrders.map((r) {
            Iterable<RoleMember> memberWithRole =
                aRoster[val].roleMembers.where((rm) => rm.role == r);
            return Expanded(
              child: GestureDetector(
                child: TextWidget(
                  text: memberWithRole.map<TextSpan>((e) {
                    bool last = memberWithRole.last == e;
                    if (e.member.name.isNotEmpty &&
                        e.status != Status.rejected) {
                      return TextSpan(children: [
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              e.status == Status.pending
                                  ? Icons.question_mark
                                  : Icons.check,
                              color: e.status == Status.pending
                                  ? warning()
                                  : safe(),
                              size: 20,
                            ),
                          ),
                          alignment: PlaceholderAlignment.top,
                        ),
                        TextSpan(
                          text: e.member.name + (last ? '' : '\n'),
                        ),
                      ]);
                    } else {
                      return TextSpan(
                        children: [
                          WidgetSpan(
                              child: MaterialButton(
                            onPressed: () {
                              ref.watch(rosterProvider.notifier).state =
                                  aRoster[val];
                              ref.watch(tempRoleMemberProvider.notifier).state =
                                  e;
                              ref.watch(roleProvider.notifier).assign(e.role);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const VolunteerDialog();
                                },
                              );
                            },
                            child: const Text('Volunteer'),
                            padding: const EdgeInsets.all(16),
                            color: lightBlue(),
                            minWidth: 0,
                          )),
                        ],
                      );
                    }
                  }).toList(),
                ),
              ),
            );
          }),
          if (ref.watch(sessionProvider.notifier).role == 'admin')
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10),
              child: MaterialButton(
                child: const Text('Remind'),
                onPressed: () {
                  sendMessages(messageFactory(aRoster[val]));
                },
                minWidth: 0,
                padding: const EdgeInsets.all(16),
                color: yellow(),
              ),
            )
        ];
      }

      return widgetList;
    }

    Map<DutyRoster, List<int>> cats = generateCategory(rosters, roles);
    List<List<DutyRoster>> groupedRosters =
        cats.entries.map<List<DutyRoster>>((m) {
      return m.value.map<DutyRoster>((idx) => rosters[idx]).toList();
    }).toList();

    List<TableWidget> tables = groupedRosters.map<TableWidget>((e) {
      return TableWidget(
        dataList: e,
        widgetList: getWidgetList(e),
        header: header(e.first.getRoles(),
            ref.watch(sessionProvider.notifier).role == 'admin'),
      );
    }).toList();

    MobileRoster mobiletables = MobileRoster(
      dataList: rosters,
    );

    List<Widget> getTableWidget() {
      return tables.isEmpty
          ? [const Center(child: CircularProgressIndicator())]
          : (isMobile(context) ? [mobiletables] : tables);
    }

    return Scaffold(
      appBar: const CustomAppBar(
        text: 'Roster',
      ),
      body: isMobile(context)
          ? Center(
              child: Column(
                children: [
                  if (ref.watch(sessionProvider.notifier).role == 'admin')
                    Row(
                      children: [addBtn, notifyBtn],
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
                  Expanded(
                      child: Center(
                    child: SingleChildScrollView(
                      child: getTableWidget()[0],
                    ),
                  ))
                ],
                mainAxisSize: MainAxisSize.min,
              ),
            )
          : Row(
              children: [
                const NavBar(),
                Expanded(
                  child: Column(
                    children: [
                      if (ref.watch(sessionProvider.notifier).role == 'admin')
                        Row(
                          children: [addBtn, notifyBtn],
                          mainAxisAlignment: MainAxisAlignment.end,
                        ),
                      Expanded(
                        child: Center(
                            child: SingleChildScrollView(
                                child: Column(children: [...getTableWidget()]))),
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                  ),
                ),
              ],
              mainAxisSize: MainAxisSize.max,
            ),
      bottomNavigationBar: isMobile(context) ? const NavBar() : null,
    );
  }
}
