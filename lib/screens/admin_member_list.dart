import 'package:app/provider.dart';
import 'package:app/utils/colours.dart';
import 'package:app/widgets/all.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/adaptive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminMemberList extends ConsumerWidget {
  const AdminMemberList({
    Key? key,
  }) : super(key: key);

  final IconData personIcon = Icons.person;

  final List<Widget> header = const [
    Expanded(
      child: TextWidget(
        text: [
          TextSpan(
            text: 'Name',
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
            text: 'Role(s)',
          ),
        ],
        compact: false,
        alignment: TextAlign.end,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    personIcon,
                    size: 20,
                  ),
                ),
                alignment: PlaceholderAlignment.top,
              ),
              TextSpan(
                text: members[val].name,
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
                  members[val].isActive
                      ? Icons.notifications_outlined
                      : Icons.notifications_off_outlined,
                  size: 20,
                  color: members[val].isActive ? Colors.green : red(),
                ),
              ),
              alignment: PlaceholderAlignment.top,
            ),
            TextSpan(
              text: members[val].isActive ? 'Active' : 'Inactive',
            ),
          ],
          compact: isMobile(context) ? true : false,
        ),
        Expanded(
          flex: isMobile(context) ? 0 : 1,
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: isMobile(context) ? 0 : 16),
            child: Wrap(
              children: members[val].roles.map<Chip>((role) {
                return Chip(
                  avatar: CircleAvatar(
                    backgroundColor: role.color,
                    child: Text(
                      'A',
                      style: TextStyle(color: lightBlue()),
                    ),
                  ),
                  label: Text(role.name),
                  backgroundColor: role.color.withOpacity(0.15),
                );
              }).toList(),
              runSpacing: 8,
              spacing: 10,
            ),
          ),
        ),
      ];
    }

    TableWidget tableWidget = TableWidget(
      dataList: members,
      widgetList: widgetList,
      header: header,
    );

    Widget getTableWidget() {
      return members.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : tableWidget;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
        backgroundColor: blue(),
      ),
      body: isMobile(context)
          ? Center(
              child: getTableWidget(),
            )
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
