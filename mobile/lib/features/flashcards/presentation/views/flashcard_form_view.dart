import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/flashcard.dart';
import '../viewmodels/flashcards_viewmodel.dart';

/// Misma pantalla para crear y editar una flashcard.
///
/// Si recibe una [flashcard] => modo edición; si es null => modo creación.
class FlashcardFormView extends StatefulWidget {
  const FlashcardFormView({super.key, this.flashcard});

  final Flashcard? flashcard;

  @override
  State<FlashcardFormView> createState() => _FlashcardFormViewState();
}

class _FlashcardFormViewState extends State<FlashcardFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _questionController;
  late final TextEditingController _answerController;
  late final TextEditingController _categoryController;

  bool get _isEditing => widget.flashcard != null;

  @override
  void initState() {
    super.initState();
    _questionController =
        TextEditingController(text: widget.flashcard?.question ?? '');
    _answerController =
        TextEditingController(text: widget.flashcard?.answer ?? '');
    _categoryController =
        TextEditingController(text: widget.flashcard?.category ?? '');
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final viewModel = context.read<FlashcardsViewModel>();
    final question = _questionController.text.trim();
    final answer = _answerController.text.trim();
    final category = _categoryController.text.trim();

    final ok = _isEditing
        ? await viewModel.update(
            id: widget.flashcard!.id,
            question: question,
            answer: answer,
            category: category,
          )
        : await viewModel.create(
            question: question,
            answer: answer,
            category: category,
          );

    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(viewModel.errorMessage ?? 'No se pudo guardar'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FlashcardsViewModel>();
    final saving = viewModel.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar tarjeta' : 'Nueva tarjeta'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _questionController,
                  minLines: 2,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Pregunta',
                    prefixIcon: Icon(Icons.help_outline),
                    alignLabelWithHint: true,
                  ),
                  validator: (v) =>
                      (v?.trim() ?? '').isEmpty ? 'Ingresa la pregunta' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _answerController,
                  minLines: 2,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Respuesta',
                    prefixIcon: Icon(Icons.check_circle_outline),
                    alignLabelWithHint: true,
                  ),
                  validator: (v) =>
                      (v?.trim() ?? '').isEmpty ? 'Ingresa la respuesta' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _categoryController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Categoría',
                    prefixIcon: Icon(Icons.label_outline),
                  ),
                  validator: (v) =>
                      (v?.trim() ?? '').isEmpty ? 'Ingresa la categoría' : null,
                ),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: saving ? null : _submit,
                  icon: saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(_isEditing ? 'Guardar cambios' : 'Crear tarjeta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
