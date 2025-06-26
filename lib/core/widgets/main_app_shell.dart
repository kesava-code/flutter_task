// File: lib/core/widgets/main_app_shell.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainAppShell extends StatelessWidget {
  final Widget child;
  const MainAppShell({super.key, required this.child});

  void _onTap(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/chats');
        break;
      case 2:
        context.go('/map');
        break;
      default:
        context.go('/home');
    }
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/chats')) {
      return 1;
    }
    if (location.startsWith('/map')) {
      return 2;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    // We use LayoutBuilder to determine if we should show a rail or a bar
    return LayoutBuilder(
      builder: (context, constraints) {
        // If the screen width is greater than 600, show a NavigationRail (for web/tablets)
        if (constraints.maxWidth > 600) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Flutter Task'),
              actions: [
                IconButton(icon: const Icon(Icons.qr_code_scanner), onPressed: () { /* TODO */ }),
                IconButton(icon: const Icon(Icons.settings), onPressed: () => context.go('/settings')),
              ],
            ),
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _calculateSelectedIndex(context),
                  onDestinationSelected: (index) => _onTap(index, context),
                  labelType: NavigationRailLabelType.all,
                  destinations: const <NavigationRailDestination>[
                    NavigationRailDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: Text('Home')),
                    NavigationRailDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: Text('Chats')),
                    NavigationRailDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map), label: Text('Map')),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: child), // The main content area
              ],
            ),
          );
        }
        // Otherwise, show a BottomNavigationBar (for mobile)
        return Scaffold(
          appBar: AppBar(
            title: const Text('Flutter Task'),
            actions: [
                IconButton(icon: const Icon(Icons.qr_code_scanner), onPressed: () { /* TODO */ }),
                IconButton(icon: const Icon(Icons.settings), onPressed: () => context.go('/settings')),
            ],
          ),
          body: child, // The main content area
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _calculateSelectedIndex(context),
            onTap: (index) => _onTap(index, context),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Chats'),
              BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
            ],
          ),
        );
      },
    );
  }
}
