import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pgl_p2_myportfolio/main.dart';

void main() {
  testWidgets('Drawer permite acceder al portfolio', (tester) async {
    await tester.pumpWidget(const CanchaCanariaApp());
    await tester.pumpAndSettle();

    expect(find.text('¡Bienvenido, Joel!'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Portfolio de Joel').last);
    await tester.pumpAndSettle();
    expect(find.text('Sobre mí'), findsOneWidget);
    expect(find.text('Mis proyectos'), findsOneWidget);
  });
}
