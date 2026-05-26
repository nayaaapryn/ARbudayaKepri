import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/heritage/presentation/heritage_profile_screen.dart';
import '../features/heritage/presentation/scanner_screen.dart';
import '../features/gamification/presentation/logbook_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/heritage/presentation/ar_view_screen.dart';

/// Central application routing configuration using [GoRouter].
/// Supports deep linking parameter passing (e.g. `/heritage/:id?fromScan=true`).
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/heritage/:id',
      builder: (BuildContext context, GoRouterState state) {
        final id = state.pathParameters['id'] ?? '';
        // Extract optional scan tracking query param
        final fromScan = state.uri.queryParameters['fromScan'] == 'true';
        
        return HeritageProfileScreen(
          id: id,
          openedViaScan: fromScan,
        );
      },
    ),
    GoRoute(
      path: '/heritage/:id/ar',
      builder: (BuildContext context, GoRouterState state) {
        final id = state.pathParameters['id'] ?? '';
        return ARViewScreen(id: id);
      },
    ),
    GoRoute(
      path: '/scanner',
      builder: (BuildContext context, GoRouterState state) {
        return const ScannerScreen();
      },
    ),
    GoRoute(
      path: '/logbook',
      builder: (BuildContext context, GoRouterState state) {
        return const LogbookScreen();
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Route Not Found: ${state.uri.path}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('Back to Home'),
          ),
        ],
      ),
    ),
  ),
);
