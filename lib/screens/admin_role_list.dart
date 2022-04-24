import 'package:app/provider.dart';
import 'package:app/provider/roster_provider.dart';
import 'package:app/utils/colours.dart';
import 'package:app/utils/enum.dart';
import 'package:app/utils/size.dart';
import 'package:app/widgets/all.dart';
import 'package:app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/adaptive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminRoleList extends ConsumerWidget {
  const AdminRoleList({
    Key? key,
  }) : super(key: key);

  final IconData circleIcon = Icons.circle;

  final List<Widget> header = const [
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
    TextWidget(
      text: [
        TextSpan(
          text: 'Status',
        ),
      ],
      compact: false,
    ),
    Expanded(
      child: TextWidget(
        text: [
          TextSpan(
            text: 'Number of members',
          ),
        ],
        compact: false,
        alignment: TextAlign.end,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roles = ref.watch(roleListProvider);
    final members = ref.watch(memberListProvider);

    List<Widget> widgetList(val) {
      return [
        Expanded(
          child: TextWidget(
            text: [
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    circleIcon,
                    size: 20,
                    color: roles[val].color,
                  ),
                ),
                alignment: PlaceholderAlignment.top,
              ),
              TextSpan(
                text: roles[val].name,
              ),
            ],
            compact: isMobile(context) ? true : false,
          ),
          flex: isMobile(context) ? 0 : 1,
        ),
        TextWidget(
          text: [
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  roles[val].isEnabled
                      ? Icons.check_circle_outline
                      : Icons.cancel_outlined,
                  size: 20,
                  color: roles[val].isEnabled ? safe() : red(),
                ),
              ),
              alignment: PlaceholderAlignment.top,
            ),
            TextSpan(
              text: roles[val].getIsEnabled(),
            ),
          ],
          compact: isMobile(context) ? true : false,
        ),
        Expanded(
          child: TextWidget(
            text: [
              const WidgetSpan(
                child: Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.people_alt_outlined,
                    size: 20,
                  ),
                ),
                alignment: PlaceholderAlignment.top,
              ),
              TextSpan(
                  text: members
                      .where((m) => m.roles.contains(roles[val]))
                      .length
                      .toString()),
            ],
            compact: isMobile(context) ? true : false,
            alignment: isMobile(context) ? TextAlign.start : TextAlign.end,
          ),
          flex: isMobile(context) ? 0 : 1,
        ),
      ];
    }

    TableWidget tableWidget = TableWidget(
      dataList: roles,
      widgetList: widgetList,
      header: header,
    );

    Widget getTableWidget() {
      return roles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: percentHeight(context, 0.8)),
              child: SingleChildScrollView(
                child: tableWidget,
              ),
            );
    }

    Widget addBtn = ButtonWidget(
      text: 'Add',
      callback: () {
        ref.watch(modeProvider.notifier).state = Mode.add;
        ref.read(roleProvider.notifier).reset();
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

    Widget roleDeckBtn = ButtonWidget(
      text: 'Role Deck',
      callback: () {
        Navigator.pushNamed(context, '/roleDeck');
      },
      icon: Icons.view_column_outlined,
    );

    return Scaffold(
      appBar: const CustomAppBar(
        text: 'Roles',
      ),
      body: isMobile(context)
          ? Column(
              children: [
                if (ref.watch(sessionProvider.notifier).role == 'admin')
                  Row(
                    children: [
                      roleDeckBtn,
                      addBtn,
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                Center(child: getTableWidget()),
              ],
            )
          : Row(
              children: [
                const NavBar(),
                Expanded(
                  child: Column(
                    children: [
                      if (ref.watch(sessionProvider.notifier).role == 'admin')
                        Row(
                          children: [
                            roleDeckBtn,
                            addBtn,
                          ],
                          mainAxisAlignment: MainAxisAlignment.end,
                        ),
                      getTableWidget(),
                    ],
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
