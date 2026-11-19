import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pgl_p2_myportfolio/app_router.dart';
import 'package:pgl_p2_myportfolio/main.dart';

void main() {
  testWidgets('Sin token solo se ve login y se impide abrir una ruta privada',
      (tester) async {
    FlutterSecureStorage.setMockInitialValues({});
    await tester.pumpWidget(const CanchaCanariaApp());
    await tester.pumpAndSettle();
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.byIcon(Icons.menu), findsNothing);
    AppRouter.router.go('/instalaciones');
    await tester.pumpAndSettle();
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Tus instalaciones'), findsNothing);
    await tester.tap(find.byKey(const ValueKey('enviar-sesion')));
    await tester.pumpAndSettle();
    expect(find.text('Introduce un email válido.'), findsOneWidget);
    expect(find.text('Introduce tu contraseña.'), findsOneWidget);
  });
}
