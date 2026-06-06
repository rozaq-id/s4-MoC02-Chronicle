import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:chronicle/features/auth/pages/login_page.dart';
import 'package:chronicle/features/chronicle/pages/blank_nav_page.dart';
import 'package:chronicle/features/chronicle/pages/event_detail_page.dart';
import 'package:chronicle/features/chronicle/pages/home_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/explore',
      builder: (context, state) => const BlankNavPage(currentIndex: 1),
    ),
    GoRoute(
      path: '/bookmarks',
      builder: (context, state) => const BlankNavPage(currentIndex: 2),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const BlankNavPage(currentIndex: 3),
    ),
    GoRoute(
      path: '/detail/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'wwii-end';
        final year = state.uri.queryParameters['year'] ?? '';
        return EventDetailPage(
          args: EventDetailArgs(id: id, year: year),
        );
      },
    ),
  ],
);
