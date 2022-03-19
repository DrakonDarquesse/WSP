import 'package:app/provider.dart';
import 'package:app/routes.dart';
import 'package:app/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/colours.dart';
import 'package:app/utils/adaptive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavBar extends ConsumerWidget {
  const NavBar({Key? key}) : super(key: key);

  int getIndex(String route) {
    return navRoutes.indexOf(route);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String route = ModalRoute.of(context)!.settings.name!;
    final selectedIndex = getIndex(route);
    void _onItemTapped(int index) {
      switch (index) {
        case 0:
          break;
        case 1:
          Navigator.popAndPushNamed(context, '/');
          break;
        case 2:
          ref.read(modelProvider.notifier).state = Model.role;
          Navigator.pushReplacementNamed(context, '/adminRoleList');
          break;
        case 3:
          ref.read(modelProvider.notifier).state = Model.member;
          Navigator.pushReplacementNamed(context, '/adminMemberList');
          break;
        case 4:
          Navigator.pushNamed(context, '/');
          break;
      }
    }

    return isMobile(context)
        ? BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Nav.schedule.displayIcon,
                label: Nav.schedule.displayText,
              ),
              BottomNavigationBarItem(
                icon: Nav.roster.displayIcon,
                label: Nav.roster.displayText,
              ),
              BottomNavigationBarItem(
                icon: Nav.roles.displayIcon,
                label: Nav.roles.displayText,
              ),
              BottomNavigationBarItem(
                icon: Nav.members.displayIcon,
                label: Nav.members.displayText,
              )
            ],
            showUnselectedLabels: false,
            selectedItemColor: black(),
            backgroundColor: lightBlue(),
            unselectedItemColor: blue(),
            currentIndex: selectedIndex,
            onTap: _onItemTapped,
          )
        : NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: _onItemTapped,
            labelType: NavigationRailLabelType.selected,
            destinations: <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Nav.schedule.displayIcon,
                label: Text(Nav.schedule.displayText),
              ),
              NavigationRailDestination(
                icon: Nav.roster.displayIcon,
                label: Text(Nav.roster.displayText),
              ),
              NavigationRailDestination(
                icon: Nav.roles.displayIcon,
                label: Text(Nav.roles.displayText),
              ),
              NavigationRailDestination(
                icon: Nav.members.displayIcon,
                label: Text(Nav.members.displayText),
              )
            ],
            backgroundColor: lightBlue(),
            unselectedIconTheme: IconThemeData(color: blue()),
            unselectedLabelTextStyle: TextStyle(color: blue()),
            selectedIconTheme: IconThemeData(color: black()),
            selectedLabelTextStyle: TextStyle(color: black()),
          );
  }
}
