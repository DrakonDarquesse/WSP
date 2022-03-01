import 'package:app/utils/colours.dart';
import 'package:app/widgets/all.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/adaptive.dart';
import 'package:app/models/member.dart';

class AdminMemberList extends StatefulWidget {
  const AdminMemberList({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminMemberList> createState() => AdminMemberListState();
}

class AdminMemberListState extends State<AdminMemberList> {
  IconData personIcon = Icons.person;
  List<Member> list = [
    Member(name: 'Ash', email: 'ash@gmail.com', password: 'password'),
    Member(
        name: 'Alex',
        email: 'ash@gmail.com',
        password: 'password',
        isActive: false),
    Member(name: 'Adam', email: 'ash@gmail.com', password: 'password'),
  ];

  List<Widget> header = const [
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
                list[val].isActive
                    ? Icons.notifications_outlined
                    : Icons.notifications_off_outlined,
                size: 20,
                color: list[val].isActive ? Colors.green : red(),
              ),
            ),
            alignment: PlaceholderAlignment.top,
          ),
          TextSpan(
            text: list[val].isActive ? 'Active' : 'Inactive',
          ),
        ],
        compact: isMobile(context) ? true : false,
      ),
      Expanded(
        flex: isMobile(context) ? 0 : 1,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile(context) ? 0 : 16),
          child: Wrap(
            children: [
              Chip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.grey.shade800,
                  child: Text(
                    'A',
                    style: TextStyle(color: lightBlue()),
                  ),
                ),
                label: const Text('Aaron Burr'),
                backgroundColor: Colors.grey.shade200,
              ),
              Chip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.grey.shade800,
                  child: Text(
                    'A',
                    style: TextStyle(color: lightBlue()),
                  ),
                ),
                label: const Text('Aaron Burr'),
                backgroundColor: Colors.grey.shade200,
              ),
            ],
            runSpacing: 8,
            spacing: 10,
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
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
                header: header,
              ),
            )
          : Row(
              children: [
                NavBar(),
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
