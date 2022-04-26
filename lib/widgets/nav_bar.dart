import 'package:app/routes.dart';
import 'package:app/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/colours.dart';
import 'package:app/utils/adaptive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavBar extends ConsumerWidget {
  const NavBar({Key? key}) : super(key: key);

  int getIndex(String route) {
    return navRoutes[route]!;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String route = ModalRoute.of(context)!.settings.name!;
    final selectedIndex = getIndex(route);
    void _onItemTapped(int index) {
      switch (index) {
        case 0:
          Navigator.pushNamed(context, '/memberSchedule');
          break;
        case 1:
          Navigator.pushNamed(context, '/profile');
          break;
        case 2:
          Navigator.pushNamed(context, '/role');
          break;
        case 3:
          Navigator.pushNamed(context, '/member');
          break;
        case 4:
          Navigator.pushNamed(context, '/roster');
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
                icon: Nav.profile.displayIcon,
                label: Nav.profile.displayText,
              ),
              BottomNavigationBarItem(
                icon: Nav.roles.displayIcon,
                label: Nav.roles.displayText,
              ),
              BottomNavigationBarItem(
                icon: Nav.members.displayIcon,
                label: Nav.members.displayText,
              ),
              BottomNavigationBarItem(
                icon: Nav.roster.displayIcon,
                label: Nav.roster.displayText,
              ),
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
                icon: Nav.profile.displayIcon,
                label: Text(Nav.profile.displayText),
              ),
              NavigationRailDestination(
                icon: Nav.roles.displayIcon,
                label: Text(Nav.roles.displayText),
              ),
              NavigationRailDestination(
                icon: Nav.members.displayIcon,
                label: Text(Nav.members.displayText),
              ),
              NavigationRailDestination(
                icon: Nav.roster.displayIcon,
                label: Text(Nav.roster.displayText),
              ),
            ],
            backgroundColor: lightBlue(),
            unselectedIconTheme: IconThemeData(color: blue()),
            unselectedLabelTextStyle: TextStyle(color: blue()),
            selectedIconTheme: IconThemeData(color: black()),
            selectedLabelTextStyle: TextStyle(color: black()),
          );
  }
}
