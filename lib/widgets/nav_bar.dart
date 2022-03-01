import 'package:flutter/material.dart';
import 'package:app/utils/colours.dart';
import 'package:app/utils/adaptive.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isMobile(context)
        ? BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.schedule),
                label: "Schedule",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.event),
                label: "Roster",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_rounded),
                label: "Chat",
              )
            ],
            showUnselectedLabels: false,
            selectedItemColor: black(),
            backgroundColor: lightBlue(),
            unselectedItemColor: blue(),
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          )
        : NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.selected,
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.schedule),
                label: Text('First'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.event),
                label: Text('Second'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.chat_rounded),
                label: Text('Third'),
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
