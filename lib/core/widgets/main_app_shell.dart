// File: lib/core/widgets/main_app_shell.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/features/2_chat/cubit/chat_list/chat_list_cubit.dart';
import 'package:flutter_task/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Watch the single, app-wide ChatListCubit instance for the badge count
        final totalUnreadCount = context.select((ChatListCubit cubit) =>
            cubit.state.chatRooms.fold<int>(0, (sum, room) => sum + room.unreadCount));

        if (constraints.maxWidth > 600) {
          // Large screen layout (Tablet/Web)
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.appTitle),
              actions: [
                IconButton(icon: const Icon(Icons.qr_code_scanner), tooltip: l10n.scanQrCode, onPressed: () => context.push('/scanner')),
                IconButton(icon: const Icon(Icons.settings), tooltip: l10n.settings, onPressed: () => context.push('/settings')),
              ],
            ),
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _calculateSelectedIndex(context),
                  onDestinationSelected: (index) => _onTap(index, context),
                  labelType: NavigationRailLabelType.all,
                  destinations: <NavigationRailDestination>[
                    NavigationRailDestination(
                      icon: const Icon(Icons.home_outlined),
                      selectedIcon: const Icon(Icons.home),
                      label: Text(l10n.home),
                    ),
                    NavigationRailDestination(
                      icon: Badge(
                        label: Text(totalUnreadCount.toString()),
                        isLabelVisible: totalUnreadCount > 0,
                        child: const Icon(Icons.chat_bubble_outline),
                      ),
                      selectedIcon: Badge(
                        label: Text(totalUnreadCount.toString()),
                        isLabelVisible: totalUnreadCount > 0,
                        child: const Icon(Icons.chat_bubble),
                      ),
                      label: Text(l10n.chats),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.map_outlined),
                      selectedIcon: const Icon(Icons.map),
                      label: Text(l10n.map),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: child),
              ],
            ),
          );
        } else {
          // Small screen layout (Mobile)
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.appTitle),
              actions: [
                IconButton(icon: const Icon(Icons.qr_code_scanner), tooltip: l10n.scanQrCode, onPressed: () => context.push('/scanner')),
                IconButton(icon: const Icon(Icons.settings), tooltip: l10n.settings, onPressed: () => context.push('/settings')),
              ],
            ),
            body: child,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _calculateSelectedIndex(context),
              onTap: (index) => _onTap(index, context),
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: const Icon(Icons.home), label: l10n.home),
                BottomNavigationBarItem(
                  icon: Badge(
                    label: Text(totalUnreadCount.toString()),
                    isLabelVisible: totalUnreadCount > 0,
                    child: const Icon(Icons.chat_bubble),
                  ),
                  label: l10n.chats,
                ),
                BottomNavigationBarItem(icon: const Icon(Icons.map), label: l10n.map),
              ],
            ),
          );
        }
      },
    );
  }
}
