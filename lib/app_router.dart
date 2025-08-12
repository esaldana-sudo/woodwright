import 'package:go_router/go_router.dart';
import 'features/home/home_screen.dart';
import 'features/planner/planner_screen.dart';
import 'features/calculator/bf_calculator_screen.dart';
import 'features/joinery/joinery_screen.dart';
import 'features/templates/templates_screen.dart';
import 'features/settings/settings_screen.dart';

class AppRouter {
  static GoRouter build() {
    return GoRouter(
      initialLocation: '/',
      routes: [
        ShellRoute(
          builder: (context, state, child) => HomeScreen(child: child),
          routes: [
            GoRoute(path: '/', builder: (context, state) => const PlannerScreen()),
            GoRoute(path: '/calculator', builder: (context, state) => const BoardFootCalculatorScreen()),
            GoRoute(path: '/joinery', builder: (context, state) => const JoineryScreen()),
            GoRoute(path: '/templates', builder: (context, state) => const TemplatesScreen()),
            GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
          ],
        ),
      ],
    );
  }
}
