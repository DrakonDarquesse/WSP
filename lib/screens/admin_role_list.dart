import 'package:app/provider.dart';
import 'package:app/utils/colours.dart';
import 'package:app/widgets/all.dart';
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
                  color: roles[val].isEnabled ? Colors.green : red(),
                ),
              ),
              alignment: PlaceholderAlignment.top,
            ),
            TextSpan(
              text: roles[val].isEnabled ? 'Enabled' : 'Disabled',
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
                text: 5.toString(),
              ),
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
          : tableWidget;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Role'),
        backgroundColor: blue(),
      ),
      body: isMobile(context)
          ? Center(child: getTableWidget())
          : Row(
              children: [
                const NavBar(),
                Expanded(
                  child: getTableWidget(),
                ),
              ],
              mainAxisSize: MainAxisSize.max,
            ),
      bottomNavigationBar: isMobile(context) ? const NavBar() : null,
    );
  }
}
