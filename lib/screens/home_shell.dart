import 'package:flutter/material.dart';

import 'coming_soon_screen.dart';
import 'hangar_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _tabs = <Widget>[
    HangarScreen(),
    ComingSoonScreen(
      sectionName: 'Codex',
      description:
          'A database of characters, planets, and Force lore. Browse, filter, and add your own entries.',
      icon: Icons.menu_book_outlined,
    ),
    ComingSoonScreen(
      sectionName: 'Bounties',
      description:
          'Track active and claimed bounties across the galaxy. Sort by reward and planet.',
      icon: Icons.gps_fixed,
    ),
    ComingSoonScreen(
      sectionName: 'Favorites',
      description: 'Pinned ships, codex entries, and bounties in one place.',
      icon: Icons.star_outline,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.rocket_launch_outlined),
            selectedIcon: Icon(Icons.rocket_launch),
            label: 'Hangar',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Codex',
          ),
          NavigationDestination(
            icon: Icon(Icons.gps_fixed),
            selectedIcon: Icon(Icons.my_location),
            label: 'Bounties',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_outline),
            selectedIcon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
