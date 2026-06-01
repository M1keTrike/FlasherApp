import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../domain/entities/flashcard.dart';
import '../viewmodels/flashcards_viewmodel.dart';
import '../widgets/flashcard_tile.dart';

class FlashcardsListView extends StatefulWidget {
  const FlashcardsListView({super.key});

  @override
  State<FlashcardsListView> createState() => _FlashcardsListViewState();
}

class _FlashcardsListViewState extends State<FlashcardsListView> {
  @override
  void initState() {
    super.initState();
    // Carga inicial tras el primer frame (el ViewModel ya está provisto).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FlashcardsViewModel>().load();
    });
  }

  Future<void> _openForm({Flashcard? flashcard}) async {
    final changed = await Navigator.of(context).pushNamed(
      AppRoutes.flashcardForm,
      arguments: flashcard,
    );
    if (changed == true && mounted) {
      context.read<FlashcardsViewModel>().load();
    }
  }

  Future<void> _confirmDelete(Flashcard flashcard) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar tarjeta'),
        content: Text('¿Seguro que quieres eliminar "${flashcard.question}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final viewModel = context.read<FlashcardsViewModel>();
    final ok = await viewModel.delete(flashcard.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(ok ? 'Tarjeta eliminada' : (viewModel.errorMessage ?? 'Error')),
    ));
  }

  Future<void> _logout() async {
    await context.read<AuthViewModel>().logout();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FlashcardsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis tarjetas'),
        actions: [
          IconButton(
            tooltip: 'Modo estudio',
            icon: const Icon(Icons.school_outlined),
            onPressed: viewModel.flashcards.isEmpty
                ? null
                : () => Navigator.of(context).pushNamed(AppRoutes.study),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Nueva'),
      ),
      body: _buildBody(viewModel),
    );
  }

  Widget _buildBody(FlashcardsViewModel viewModel) {
    if (viewModel.isLoading && viewModel.flashcards.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null && viewModel.flashcards.isEmpty) {
      return _Message(
        icon: Icons.error_outline,
        title: 'Algo salió mal',
        subtitle: viewModel.errorMessage!,
        action: FilledButton(
          onPressed: viewModel.load,
          child: const Text('Reintentar'),
        ),
      );
    }

    if (viewModel.isEmpty) {
      return const _Message(
        icon: Icons.style_outlined,
        title: 'Aún no tienes tarjetas',
        subtitle: 'Toca "Nueva" para crear tu primera flashcard.',
      );
    }

    return RefreshIndicator(
      onRefresh: viewModel.load,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 88),
        itemCount: viewModel.flashcards.length,
        itemBuilder: (context, index) {
          final flashcard = viewModel.flashcards[index];
          return FlashcardTile(
            flashcard: flashcard,
            onEdit: () => _openForm(flashcard: flashcard),
            onDelete: () => _confirmDelete(flashcard),
          );
        },
      ),
    );
  }
}

/// Estado vacío / de error reutilizable.
class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: scheme.outline),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
