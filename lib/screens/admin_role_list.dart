import 'dart:async';

import 'package:app/network/auth.dart';
import 'package:app/network/role.dart';
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

  final Stream<List<Role>> _roles = (() {
    late final StreamController<List<Role>> controller;
    controller = StreamController<List<Role>>.broadcast(
      onListen: () async {
        controller.add(await fetchRole());
        await controller.close();
      },
    );
    return controller.stream;
  })();

  @override
  Widget build(BuildContext context) {
    fetchRole().then((roles) {});

    StreamBuilder<List<Role>> streamBuilder = StreamBuilder<List<Role>>(
        stream: _roles,
        builder: (context, snapshot) {
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
                          color: snapshot.data![val].color,
                        ),
                      ),
                      alignment: PlaceholderAlignment.top,
                    ),
                    TextSpan(
                      text: snapshot.data![val].name,
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
                        snapshot.data![val].isEnabled
                            ? Icons.check_circle_outline
                            : Icons.cancel_outlined,
                        size: 20,
                        color: snapshot.data![val].isEnabled
                            ? Colors.green
                            : red(),
                      ),
                    ),
                    alignment: PlaceholderAlignment.top,
                  ),
                  TextSpan(
                    text:
                        snapshot.data![val].isEnabled ? 'Enabled' : 'Disabled',
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
                  alignment:
                      isMobile(context) ? TextAlign.start : TextAlign.end,
                ),
                flex: isMobile(context) ? 0 : 1,
              ),
            ];
          }

          if (snapshot.hasData) {
            return TableWidget(
              dataList: snapshot.data!,
              widgetList: widgetList,
              header: header,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Role'),
        backgroundColor: blue(),
      ),
      body: isMobile(context)
          ? Center(
              child: streamBuilder,
            )
          : Row(
              children: [
                const NavBar(),
                Expanded(
                  child: streamBuilder,
                ),
              ],
              mainAxisSize: MainAxisSize.max,
            ),
      bottomNavigationBar: isMobile(context) ? NavBar() : null,
    );
  }
}
