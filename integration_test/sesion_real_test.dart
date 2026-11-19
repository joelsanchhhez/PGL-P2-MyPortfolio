import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pgl_p2_myportfolio/main.dart';
import 'package:pgl_p2_myportfolio/servicios/almacen_token.dart';
import 'package:pgl_p2_myportfolio/servicios/api_sesion.dart';
import 'package:pgl_p2_myportfolio/sesion/controlador_sesion.dart';

// Reenvía a la API real; verifica el formulario sin imprimir ninguna credencial.
class _ClienteVerificado extends http.BaseClient {
  _ClienteVerificado(this.clave);
  final String clave;
  final http.Client _interno = http.Client();
  int intentos = 0;
  @override
  Future<http.StreamedResponse> send(http.BaseRequest req) {
    if (req is http.Request && req.method == 'POST') {
      final datos = jsonDecode(req.body) as Map<String, dynamic>;
      if (req.url.path.endsWith('register')) {
        expect(datos['pwd'] == clave, isTrue,
            reason: 'El registro debe enviar la clave escrita.');
      } else if (req.url.path.endsWith('login')) {
        intentos++;
        expect(datos['pwd'] == (intentos == 1 ? '${clave}incorrecta' : clave),
            isTrue,
            reason:
                'El intento de login $intentos debe enviar la clave que corresponde.');
      }
    }
    return _interno.send(req);
  }

  @override
  void close() => _interno.close();
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'Registro, login fallido, login correcto, bienvenida y restauración reales',
      (tester) async {
    const clave = String.fromEnvironment('DEMO_PASSWORD');
    expect(clave.isNotEmpty, isTrue,
        reason:
            'Pasa DEMO_PASSWORD con --dart-define-from-file fuera del repositorio.');
    final email = 'cancha.${DateTime.now().microsecondsSinceEpoch}@example.com';
    final almacen = AlmacenTokenSeguro();
    // Solo elimina el token de esta app en el emulador de pruebas.
    await almacen.eliminar();
    final inicial = ControladorSesion(
        api: ApiSesion(cliente: _ClienteVerificado(clave)), almacen: almacen);
    await tester.pumpWidget(CanchaCanariaApp(sesion: inicial));
    await tester.pumpAndSettle();
    // La API y el almacenamiento son reales. Solo se controla la entrada de texto
    // para que el teclado Android no sobrescriba valores inyectados por el test.
    binding.testTextInput.register();
    addTearDown(binding.testTextInput.unregister);
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();

    Future<void> captura(String nombre) async {
      await tester.pumpAndSettle();
      await binding.takeScreenshot(nombre);
    }

    Future<void> enviar() async {
      await tester.ensureVisible(find.byKey(const ValueKey('enviar-sesion')));
      await tester.tap(find.byKey(const ValueKey('enviar-sesion')));
      await tester.pumpAndSettle(const Duration(milliseconds: 100),
          EnginePhase.sendSemanticsUpdate, const Duration(minutes: 2));
    }

    Future<void> aceptar() async {
      await tester.tap(find.text('Aceptar'));
      await tester.pumpAndSettle();
    }

    expect(find.byIcon(Icons.menu), findsNothing);
    await tester.tap(find.text('Crear una cuenta'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const ValueKey('nombre')), 'Alumno Cancha Canaria');
    await tester.enterText(find.byKey(const ValueKey('email')), email);
    await tester.enterText(find.byKey(const ValueKey('contrasena')), clave);
    await enviar();
    expect(find.text('Registro exitoso'), findsOneWidget);
    await captura('tarea5_registro_exitoso');
    await aceptar();
    expect(find.text('Iniciar sesión'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('email')), email);
    await tester.enterText(
        find.byKey(const ValueKey('contrasena')), '${clave}incorrecta');
    await enviar();
    expect(find.text('Login fallido'), findsOneWidget);
    await captura('tarea5_login_fallido');
    await aceptar();
    await tester.enterText(find.byKey(const ValueKey('contrasena')), clave);
    expect(
        tester
                .widget<TextFormField>(find.byKey(const ValueKey('contrasena')))
                .controller!
                .text ==
            clave,
        isTrue,
        reason: 'Debe haberse actualizado el campo contraseña.');
    await enviar();
    final textoRespuesta = tester
        .widgetList<Text>(find.descendant(
            of: find.byType(AlertDialog), matching: find.byType(Text)))
        .map((t) => t.data ?? '')
        .join(' | ');
    expect(find.text('Login exitoso'), findsOneWidget, reason: textoRespuesta);
    expect(await almacen.leer(), isNotNull);
    await captura('tarea5_login_exitoso');
    await aceptar();
    expect(find.byIcon(Icons.menu), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('bienvenida-api')));
    await tester.pumpAndSettle(const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate, const Duration(minutes: 2));
    expect(find.text('Bienvenida de la API'), findsOneWidget);
    expect(find.textContaining('Alumno Cancha Canaria').last, findsOneWidget);
    await captura('tarea5_bienvenida_api');
    await aceptar();

    // Recrea la app con otro controlador: debe leer el JWT cifrado y validarlo de nuevo en la API.
    final restaurada =
        ControladorSesion(api: ApiSesion(), almacen: AlmacenTokenSeguro());
    await tester
        .pumpWidget(CanchaCanariaApp(key: UniqueKey(), sesion: restaurada));
    await tester.pumpAndSettle(const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate, const Duration(minutes: 2));
    expect(restaurada.autenticada, isTrue);
    expect(find.byIcon(Icons.menu), findsOneWidget);
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cerrar sesión'));
    await tester.pumpAndSettle();
    expect(await almacen.leer(), isNull);
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.byIcon(Icons.menu), findsNothing);
    restaurada.api.cerrar();
  }, timeout: const Timeout(Duration(minutes: 10)));
}
