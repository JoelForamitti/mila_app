import 'package:flutter/material.dart';

class NavigationSideBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int index) onIndexSelect;

  const NavigationSideBar({Key? key,
    required this.selectedIndex,
    required this.onIndexSelect
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onIndexSelect,
      labelType: NavigationRailLabelType.all,
      destinations: [
        NavigationRailDestination(
          icon: Icon(Icons.line_weight),
          selectedIcon: Icon(Icons.line_weight),
          label: Text('Schichten'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.account_circle),
          selectedIcon: Icon(Icons.account_circle),
          label: Text('Account'),
        ),
      ],
    );
  }
}

class NavigationBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int index) onIndexSelect;

  const NavigationBottomBar({Key? key,
    required this.selectedIndex,
    required this.onIndexSelect
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onIndexSelect,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.line_weight),
          activeIcon: Icon(Icons.line_weight),
          label: 'Schichten',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          activeIcon: Icon(Icons.account_circle),
          label: 'Account',
        ),
      ],
    );
  }
}