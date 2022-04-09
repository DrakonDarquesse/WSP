import 'package:app/models/role.dart';
import 'package:app/models/role_deck.dart';
import 'package:app/provider.dart';
import 'package:app/utils/adaptive.dart';
import 'package:app/utils/colours.dart';
import 'package:app/utils/enum.dart';
import 'package:app/widgets/role_deck_form.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminRoleDeckList extends ConsumerWidget {
  const AdminRoleDeckList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<RoleDeck> roleDecks = ref.watch(roleDeckListProvider);
    const List<Widget> header = [
      Expanded(
        child: TextWidget(
          text: [
            TextSpan(
              text: 'Title',
            ),
          ],
          compact: false,
        ),
      ),
      Expanded(
        child: TextWidget(
          text: [
            TextSpan(
              text: 'Roles',
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
                text: roleDecks[val].title,
              ),
            ],
            compact: isMobile(context) ? true : false,
          ),
          flex: isMobile(context) ? 0 : 1,
        ),
        Expanded(
          flex: isMobile(context) ? 0 : 1,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: isMobile(context) ? 0 : 16, vertical: 10),
            child: Wrap(
              children: roleDecks[val].roles.map<Chip>((role) {
                return Chip(
                  avatar: CircleAvatar(
                    backgroundColor: role.color,
                    child: Text(
                      role.name[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
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
      dataList: roleDecks,
      widgetList: widgetList,
      header: header,
    );

    Widget getTableWidget() {
      return roleDecks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : tableWidget;
    }

    List<Widget> widgets = [
      ButtonWidget(
        text: 'Add',
        icon: Icons.add_circle_outline_rounded,
        callback: () {
          ref.watch(modeProvider.notifier).state = Mode.add;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const RoleDeckForm(
                roledeck: null,
              );
            },
          );
        },
      ),
      getTableWidget(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Roster Template'),
        backgroundColor: blue(),
      ),
      body: isMobile(context)
          ? Center(
              child: Column(
                children: widgets,
                crossAxisAlignment: CrossAxisAlignment.stretch,
              ),
            )
          : Row(
              children: [
                const NavBar(),
                Expanded(
                  child: Column(
                    children: widgets,
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
