import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:http/testing.dart';
import 'package:pgl_p2_myportfolio/main.dart';
import 'package:pgl_p2_myportfolio/servicios/api_sesion.dart';
import 'package:pgl_p2_myportfolio/sesion/controlador_sesion.dart';

import 'ayuda/sesion_prueba.dart';

void main() {
  Future<void> montar(WidgetTester tester, ControladorSesion sesion) async {
    tester.view.physicalSize = const Size(420, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(CanchaCanariaApp(sesion: sesion));
    await tester.pumpAndSettle();
  }

  testWidgets(
      'Sin sesión solo login y rutas privadas protegidas; valida sin enviar',
      (tester) async {
    var llamadas = 0;
    final sesion = ControladorSesion(
        almacen: AlmacenMemoria(),
        api: ApiSesion(cliente: MockClient((_) async {
          llamadas++;
          return jsonRespuesta({'message': 'x'});
        })));
    await montar(tester, sesion);
    expect(find.byType(Drawer), findsNothing);
    expect(find.byIcon(Icons.menu), findsNothing);
    GoRouter.of(tester.element(find.byKey(const ValueKey('email'))))
        .go('/instalaciones');
    await tester.pumpAndSettle();
    expect(find.text('Iniciar sesión'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('enviar-sesion')));
    await tester.pumpAndSettle();
    expect(find.text('Introduce un email válido.'), findsOneWidget);
    expect(llamadas, 0);
  });

  testWidgets(
      'Registro y login muestran respuesta; logout elimina token y protege Atrás',
      (tester) async {
    final almacen = AlmacenMemoria();
    var correcto = false;
    final sesion = ControladorSesion(
        almacen: almacen,
        api: ApiSesion(cliente: MockClient((req) async {
          if (req.url.path.endsWith('register')) {
            return jsonRespuesta(
                {'message': 'Usuario registrado con éxito.'}, 201);
          }
          if (req.url.path.endsWith('login')) {
            return correcto
                ? jsonRespuesta({
                    'message': 'Inicio de sesión exitoso.',
                    'token': 'jwt',
                    'user': {'name': 'Alumno'}
                  })
                : jsonRespuesta({'message': 'Credenciales incorrectas.'}, 401);
          }
          return jsonRespuesta(
              {'message': '¡Bienvenido a la aplicación, Alumno!'});
        })));
    await montar(tester, sesion);
    await tester.tap(find.text('Crear una cuenta'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const ValueKey('nombre')), 'Alumno Prueba');
    await tester.enterText(
        find.byKey(const ValueKey('email')), 'alumno@example.com');
    await tester.enterText(
        find.byKey(const ValueKey('contrasena')), 'Clave123!');
    await tester.ensureVisible(find.byKey(const ValueKey('enviar-sesion')));
    await tester.tap(find.byKey(const ValueKey('enviar-sesion')));
    await tester.pumpAndSettle();
    expect(find.text('Registro exitoso'), findsOneWidget);
    await tester.tap(find.text('Aceptar'));
    await tester.pumpAndSettle();
    expect(find.text('Iniciar sesión'), findsOneWidget);
    await tester.enterText(
        find.byKey(const ValueKey('email')), 'alumno@example.com');
    await tester.enterText(
        find.byKey(const ValueKey('contrasena')), 'incorrecta');
    await tester.tap(find.byKey(const ValueKey('enviar-sesion')));
    await tester.pumpAndSettle();
    expect(find.text('Login fallido'), findsOneWidget);
    expect(almacen.token, isNull);
    await tester.tap(find.text('Aceptar'));
    await tester.pumpAndSettle();
    correcto = true;
    await tester.tap(find.byKey(const ValueKey('enviar-sesion')));
    await tester.pumpAndSettle();
    expect(find.text('Login exitoso'), findsOneWidget);
    expect(almacen.token, 'jwt');
    expect(find.byIcon(Icons.menu), findsNothing);
    await tester.tap(find.text('Aceptar'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.menu), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('bienvenida-api')));
    await tester.pumpAndSettle();
    expect(find.text('¡Bienvenido a la aplicación, Alumno!'), findsOneWidget);
    await tester.tap(find.text('Aceptar'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cerrar sesión'));
    await tester.pumpAndSettle();
    expect(almacen.token, isNull);
    expect(find.text('Iniciar sesión'), findsOneWidget);
    GoRouter.of(tester.element(find.byKey(const ValueKey('email'))))
        .go('/portfolio');
    await tester.pumpAndSettle();
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Mientras se comprueba un token no aparece contenido privado',
      (tester) async {
    final respuesta = Completer<void>();
    final sesion = ControladorSesion(
        almacen: AlmacenMemoria('jwt'),
        api: ApiSesion(cliente: MockClient((_) async {
          await respuesta.future;
          return jsonRespuesta({'message': 'Token válido.'});
        })));
    await tester.pumpWidget(CanchaCanariaApp(sesion: sesion));
    await tester.pump();
    expect(find.text('Comprobando sesión…'), findsOneWidget);
    expect(find.byIcon(Icons.menu), findsNothing);
    respuesta.complete();
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.menu), findsOneWidget);
  });
}
