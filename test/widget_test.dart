import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pgl_p2_myportfolio/main.dart';
import 'ayuda/sesion_prueba.dart';

void main() {
  testWidgets('El Drawer abre el portfolio y la lista de instalaciones',
      (tester) async {
    await tester.pumpWidget(CanchaCanariaApp(sesion: sesionPrueba()));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Portfolio de Joel').last);
    await tester.pumpAndSettle();
    expect(find.text('Sobre mí'), findsOneWidget);
    expect(find.text('Mis proyectos'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Instalaciones').last);
    await tester.pumpAndSettle();

    expect(find.text('Tus instalaciones'), findsOneWidget);
    expect(find.text('Total: 2'), findsOneWidget);
    expect(find.text('Cancha del barrio'), findsOneWidget);
    expect(find.text('Pabellón del norte'), findsOneWidget);
  });

  testWidgets('El formulario se abre en un Dialog con los campos exigidos',
      (tester) async {
    await tester.pumpWidget(CanchaCanariaApp(sesion: sesionPrueba()));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Instalaciones').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Añadir instalación'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Nombre *'), findsOneWidget);
    expect(find.text('Descripción breve *'), findsOneWidget);
    expect(find.text('Categoría *'), findsOneWidget);
    expect(find.text('Guardar'), findsOneWidget);
  });
  testWidgets(
      'Validación, alta, edición, cancelación, navegación y eliminación',
      (tester) async {
    await tester.pumpWidget(CanchaCanariaApp(sesion: sesionPrueba()));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Instalaciones').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Añadir instalación'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Introduce el nombre'), findsOneWidget);
    expect(find.text('Introduce una descripción'), findsOneWidget);
    expect(find.text('Selecciona una categoría'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(0), 'Campo de prueba');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'Entrenamiento local');
    await tester.ensureVisible(find.text('Categoría *'));
    await tester.tap(find.text('Categoría *'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Campo de fútbol').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Total: 3'), findsOneWidget);
    expect(find.text('Campo de prueba'), findsOneWidget);
    final imagen = tester.widgetList<Image>(find.byType(Image)).any((i) =>
        i.image is AssetImage &&
        (i.image as AssetImage).assetName.endsWith('categoria_campo.png'));
    expect(imagen, isTrue);
    await tester.tap(find.byTooltip('Editar Campo de prueba'));
    await tester.pumpAndSettle();
    expect(
        tester
            .widget<TextFormField>(find.byType(TextFormField).at(1))
            .controller!
            .text,
        'Entrenamiento local');
    await tester.enterText(
        find.byType(TextFormField).first, 'Campo actualizado');
    await tester.tap(find.text('Actualizar'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.text('Campo actualizado'), findsOneWidget);
    expect(find.text('Total: 3'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Portfolio de Joel').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Instalaciones').last);
    await tester.pumpAndSettle();
    expect(find.text('Campo actualizado'), findsOneWidget);
    await tester.tap(find.byTooltip('Eliminar Campo actualizado'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.text('Total: 3'), findsOneWidget);
    await tester.tap(find.byTooltip('Eliminar Campo actualizado'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();
    expect(find.text('Campo actualizado'), findsNothing);
    expect(find.text('Total: 2'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Borrar todos'));
    await tester.pumpAndSettle();
    expect(find.text('¿Borrar todas las instalaciones?'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.text('Total: 2'), findsOneWidget);
    expect(find.text('Cancha del barrio'), findsOneWidget);
    expect(find.text('Pabellón del norte'), findsOneWidget);
    await tester.tap(find.text('Borrar todos'));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(TextButton, 'Borrar todos')));
    await tester.pumpAndSettle();
    expect(find.text('Total: 0'), findsOneWidget);
    expect(find.text('Aún no hay instalaciones'), findsOneWidget);
    expect(
        tester
            .widget<TextButton>(find.widgetWithText(TextButton, 'Borrar todos'))
            .onPressed,
        isNull);

    await tester.tap(find.text('Añadir instalación'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.text('Total: 0'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
