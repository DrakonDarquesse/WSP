import 'package:app/models/role.dart';
import 'package:app/utils/colours.dart';
import 'package:app/widgets/all.dart';
import 'package:app/widgets/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/adaptive.dart';

class AdminRoleList extends StatefulWidget {
  const AdminRoleList({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminRoleList> createState() => AdminRoleListState();
}

class AdminRoleListState extends State<AdminRoleList> {
  IconData circleIcon = Icons.circle;

  List<Role> list = [
    Role(
      name: 'song lead',
      task: 'sing',
      color: Colors.indigo,
    ),
    Role(
      name: 'usher',
      task: 'welcome',
      color: Colors.pink.shade300,
      isEnabled: false,
    ),
    Role(
      name: 'pianist',
      task: 'plays piano',
      color: Colors.blue.shade600,
    ),
  ];

  List<Widget> header = const [
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
  Widget build(BuildContext context) {
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
                    color: list[val].color,
                  ),
                ),
                alignment: PlaceholderAlignment.top,
              ),
              TextSpan(
                text: list[val].name,
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
                  list[val].isEnabled
                      ? Icons.check_circle_outline
                      : Icons.cancel_outlined,
                  size: 20,
                  color: list[val].isEnabled ? Colors.green : red(),
                ),
              ),
              alignment: PlaceholderAlignment.top,
            ),
            TextSpan(
              text: list[val].isEnabled ? 'Enabled' : 'Disabled',
            ),
          ],
          compact: isMobile(context) ? true : false,
        ),
        Expanded(
          child: TextWidget(
            text: [
              const WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
        backgroundColor: blue(),
      ),
      body: isMobile(context)
          ? Center(
              child: TableWidget(
                dataList: list,
                widgetList: widgetList,
              ),
            )
          : Row(
              children: [
                const NavBar(),
                Expanded(
                  child: TableWidget(
                    dataList: list,
                    widgetList: widgetList,
                    header: header,
                  ),
                ),
              ],
              mainAxisSize: MainAxisSize.max,
            ),
      bottomNavigationBar: isMobile(context) ? NavBar() : null,
    );
  }
}
