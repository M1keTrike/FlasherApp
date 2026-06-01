import 'package:flutter/material.dart';

import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/register_view.dart';
import '../../features/flashcards/domain/entities/flashcard.dart';
import '../../features/flashcards/presentation/views/flashcard_form_view.dart';
import '../../features/flashcards/presentation/views/flashcards_list_view.dart';
import '../../features/flashcards/presentation/views/study_view.dart';
import 'app_routes.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return _page(const LoginView(), settings);

      case AppRoutes.register:
        return _page(const RegisterView(), settings);

      case AppRoutes.flashcards:
        return _page(const FlashcardsListView(), settings);

      case AppRoutes.flashcardForm:
        final flashcard = settings.arguments as Flashcard?;
        return _page(FlashcardFormView(flashcard: flashcard), settings);

      case AppRoutes.study:
        return _page(const StudyView(), settings);

      default:
        return _page(
          Scaffold(
            body: Center(child: Text('Ruta no encontrada: ${settings.name}')),
          ),
          settings,
        );
    }
  }

  static MaterialPageRoute<dynamic> _page(
    Widget child,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => child,
      settings: settings,
    );
  }
}
