import 'package:flutter/material.dart';

import 'core/router.dart';
import 'core/state.dart';
import 'core/theme.dart';

void main() async {
  // Ensure Flutter engine bindings are initialized for SharedPreferences operations
  WidgetsFlutterBinding.ensureInitialized();
  
  // Asynchronously load collected stamps from local storage
  // Wrapped in a safe try-catch to guarantee the app launches even if storage is corrupt
  try {
    await stampManager.init();
  } catch (e) {
    debugPrint('Critical Failure during StampManager initialization: $e');
  }

  runApp(const ARBudayaKepriApp());
}

class ARBudayaKepriApp extends StatelessWidget {
  const ARBudayaKepriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AR Budaya Kepri',
      
      // Theme settings
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Dynamically tracks OS user settings
      
      // GoRouter Configuration
      routerConfig: appRouter,
      
      // Performance flags
      debugShowCheckedModeBanner: false,
    );
  }
}
