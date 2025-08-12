import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  final Widget child;
  const HomeScreen({super.key, required this.child});

  static const _items = [
    _NavItem('/', Icons.design_services, 'Planner'),
    _NavItem('/calculator', Icons.calculate, 'Calculator'),
    _NavItem('/joinery', Icons.handyman, 'Joinery'),
    _NavItem('/templates', Icons.inventory_2, 'Templates'),
    _NavItem('/settings', Icons.settings, 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final current = GoRouterState.of(context).uri.toString();
    final index = _items.indexWhere((i) => i.path == current);
    final currentIndex = index < 0 ? 0 : index;
    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => context.go(_items[i].path),
        destinations: _items.map((i) => NavigationDestination(icon: Icon(i.icon), label: i.label)).toList(),
      ),
    );
  }
}

class _NavItem {
  final String path;
  final IconData icon;
  final String label;
  const _NavItem(this.path, this.icon, this.label);
}
