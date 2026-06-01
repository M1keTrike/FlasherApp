import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/di/composition_root.dart';
import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final composition = CompositionRoot(prefs);

  runApp(FlasherApp(composition: composition));
}

class FlasherApp extends StatelessWidget {
  const FlasherApp({super.key, required this.composition});

  final CompositionRoot composition;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: composition.providers,
      child: MaterialApp(
        title: 'Flasher',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,

        initialRoute: composition.isAuthenticated
            ? AppRoutes.flashcards
            : AppRoutes.login,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
