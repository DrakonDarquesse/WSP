import 'package:app/models/duty_roster.dart';
import 'package:app/models/role_member.dart';
import 'package:app/provider.dart';
import 'package:app/provider/roster_provider.dart';
import 'package:app/utils/adaptive.dart';
import 'package:app/utils/colours.dart';
import 'package:app/utils/enum.dart';
import 'package:app/widgets/all.dart';
import 'package:app/widgets/volunteer_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MobileRoster extends ConsumerWidget {
  final List<DutyRoster> dataList;
  final VoidCallback? callback;

  const MobileRoster({
    Key? key,
    required this.dataList,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> widgetList(val) {
      return [
        Expanded(
          child: TextWidget(
            text: [
              TextSpan(
                text: DateFormat('yMd').format(dataList[val].date),
              ),
            ],
          ),
          flex: isMobile(context) ? 0 : 1,
        ),
        TextWidget(
          text: [TextSpan(text: dataList[val].title)],
        ),
        ...dataList[val].getRoles().map((r) {
          Iterable<RoleMember> memberWithRole =
              dataList[val].roleMembers.where((rm) => rm.role == r);
          return Row(
            children: [
              Expanded(
                child: TextWidget(
                  text: [
                    TextSpan(text: r.name),
                  ],
                ),
              ),
              Expanded(
                child: TextWidget(
                    text: memberWithRole.map<TextSpan>((e) {
                  bool last = memberWithRole.last == e;
                  if (e.member.name.isNotEmpty && e.status != Status.rejected) {
                    return TextSpan(children: [
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            e.status == Status.pending
                                ? Icons.question_mark
                                : Icons.check,
                            color:
                                e.status == Status.pending ? warning() : safe(),
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
                                dataList[val];
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
                }).toList()),
              )
            ],
          );
        }),
      ];
    }

    Widget widget = Card(
      child: ListView.separated(
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              ref.watch(modeProvider.notifier).state = Mode.edit;
              ref.watch(rosterProvider.notifier).state = dataList[index];
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return EditDialogWidget(
                    text: ref.watch(sessionProvider.notifier).role == 'admin'
                        ? 'Edit'
                        : 'View',
                    model: dataList[index],
                  );
                },
              );
            },
            child: MouseRegion(
              child: Padding(
                padding: EdgeInsets.all(isMobile(context) ? 16 : 0),
                child: Flex(
                  children: widgetList(index),
                  direction:
                      isMobile(context) ? Axis.vertical : Axis.horizontal,
                  mainAxisSize:
                      isMobile(context) ? MainAxisSize.min : MainAxisSize.max,
                  mainAxisAlignment: isMobile(context)
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  crossAxisAlignment: isMobile(context)
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                ),
              ),
              cursor: index != 0 ? SystemMouseCursors.click : MouseCursor.defer,
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(height: 1, indent: 10, endIndent: 10),
        shrinkWrap: true,
        itemCount: dataList.length,
      ),
      margin: const EdgeInsets.all(16),
      elevation: 2,
    );

    return widget;
  }
}
