import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pgl_p2_myportfolio/app_router.dart';
import 'package:pgl_p2_myportfolio/main.dart';

void main() {
  testWidgets('Navegación completa y pestañas del portfolio', (tester) async {
    AppRouter.router.go('/');
    await tester.pumpWidget(const CanchaCanariaApp());
    await tester.pumpAndSettle();
    expect(find.text('¡Bienvenido, Joel!'), findsOneWidget);

    // El botón de bienvenida usa la misma ruta que el menú.
    await tester.tap(find.text('Ver instalaciones'));
    await tester.pumpAndSettle();
    expect(AppRouter.router.routeInformationProvider.value.uri.path,
        '/instalaciones');

    Future<void> abrirDestino(String titulo, String ruta) async {
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ListTile, titulo));
      await tester.pumpAndSettle();
      expect(AppRouter.router.routeInformationProvider.value.uri.path, ruta);
      expect(find.byType(Drawer), findsNothing);
      expect(tester.takeException(), isNull);
    }

    await abrirDestino('Portfolio de Joel', '/portfolio');
    expect(find.text('Mis actividades'), findsOneWidget);
    await tester.tap(find.text('Mis proyectos'));
    await tester.pumpAndSettle();
    expect(find.text('Mis proyectos web'), findsOneWidget);
    await tester.tap(find.text('Sobre mí'));
    await tester.pumpAndSettle();
    expect(find.text('Mis actividades'), findsOneWidget);
    await abrirDestino('Ajustes', '/ajustes');
    await abrirDestino('Instalaciones', '/instalaciones');
    await abrirDestino('Inicio', '/');
    // Pulsar el destino activo debe cerrar el Drawer sin cambiar la ruta.
    await abrirDestino('Inicio', '/');
    expect(find.text('¡Bienvenido, Joel!'), findsOneWidget);
  });
}
