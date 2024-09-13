import 'package:ToDo/screens/recycle_bin.dart';
import 'package:ToDo/screens/tabs_screen.dart';
import 'package:ToDo/screens/pending_tasks_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route? OnGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RecycleBin.id:
        return MaterialPageRoute(
          builder: (_) => const RecycleBin(),
        );
      case TabsScreen.id:
        return MaterialPageRoute(
          builder: (_) => TabsScreen(),
        );
      default:
        return null;
    }
  }
}
