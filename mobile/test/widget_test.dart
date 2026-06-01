// Smoke test básico de la app Flasher.
//
// Verifica que la app arranca en la pantalla de login cuando no hay sesión.
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flasher_mobile/core/di/composition_root.dart';
import 'package:flasher_mobile/main.dart';

void main() {
  testWidgets('Arranca en la pantalla de login sin sesión',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final composition = CompositionRoot(prefs);

    await tester.pumpWidget(FlasherApp(composition: composition));
    await tester.pump();

    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Flasher'), findsWidgets);
  });
}
