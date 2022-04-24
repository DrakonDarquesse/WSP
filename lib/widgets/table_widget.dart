import 'package:app/models/role_deck.dart';
import 'package:app/models/role_member.dart';
import 'package:app/provider.dart';
import 'package:app/provider/role_deck_provider.dart';
import 'package:app/provider/roster_provider.dart';
import 'package:app/utils/adaptive.dart';
import 'package:app/utils/enum.dart';
import 'package:app/widgets/all.dart';
import 'package:app/widgets/role_deck_form.dart';
import 'package:app/widgets/role_member_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/models/duty_roster.dart';

class TableWidget extends ConsumerWidget {
  final List dataList;
  final VoidCallback? callback;
  final List<Widget> Function(int) widgetList;
  final List<Widget>? header;

  const TableWidget({
    Key? key,
    required this.dataList,
    required this.widgetList,
    this.header,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> widgets = [
      Card(
        child: ListView.separated(
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                ref.watch(modeProvider.notifier).state = Mode.edit;
                if (index != 0) {
                  if (dataList[index - 1] is DutyRoster) {
                    ref.watch(rosterProvider.notifier).state =
                        dataList[index - 1];
                  }
                  if (dataList[index - 1] is RoleMember) {
                    RoleMember rm = dataList[index - 1] as RoleMember;
                    ref.watch(tempRoleMemberProvider.notifier).state =
                        dataList[index - 1];
                    ref.watch(roleProvider.notifier).assign(rm.role);
                    if (ref.watch(sessionProvider.notifier).role != 'admin') {
                      return;
                    }
                  }
                  if (dataList[index - 1] is RoleDeck) {
                    RoleDeck rd = dataList[index - 1] as RoleDeck;
                    ref.watch(selectedRolesProvider.notifier).state = rd.roles;
                    ref.watch(titleProvider.notifier).state = rd.title;
                  }
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      if (dataList[index - 1] is RoleMember) {
                        return const RoleMemberForm();
                      }
                      if (dataList[index - 1] is RoleDeck) {
                        return RoleDeckForm(
                          roledeck: dataList[index - 1],
                        );
                      }
                      return EditDialogWidget(
                        text:
                            ref.watch(sessionProvider.notifier).role == 'admin'
                                ? 'Edit'
                                : 'View',
                        model: dataList[index - 1],
                      );
                    },
                  );
                }
              },
              child: MouseRegion(
                child: Padding(
                  padding: EdgeInsets.all(isMobile(context) ? 16 : 0),
                  child: Flex(
                    children: isMobile(context)
                        ? widgetList(index)
                        : (index == 0 ? header! : widgetList(index - 1)),
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
                cursor:
                    index != 0 ? SystemMouseCursors.click : MouseCursor.defer,
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(height: 1, indent: 10, endIndent: 10),
          shrinkWrap: true,
          itemCount: isMobile(context)
              ? dataList.length
              : dataList.isEmpty
                  ? 1
                  : dataList.length + 1,
        ),
        margin: const EdgeInsets.all(16),
        elevation: 2,
      ),
    ];

    return Column(
      children: widgets,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
