import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pgl_p2_myportfolio/servicios/api_sesion.dart';
import 'package:pgl_p2_myportfolio/sesion/controlador_sesion.dart';
import 'package:pgl_p2_myportfolio/utilidades/validaciones_sesion.dart';

import 'ayuda/sesion_prueba.dart';

void main() {
  test(
      'Serializa fullName/email/pwd y añade Bearer solo a las rutas protegidas',
      () async {
    final llamadas = <http.Request>[];
    final api = ApiSesion(cliente: MockClient((req) async {
      llamadas.add(req);
      return jsonRespuesta({
        'message': 'Respuesta de la API',
        if (req.url.path.endsWith('login')) ...{
          'token': 'jwt-test',
          'user': {'name': 'Alumno de prueba'}
        }
      });
    }));
    await api.registrar(
        ' Alumno de prueba ', ' alumno@example.com ', ' NoRecortar1! ');
    final login = await api.login('alumno@example.com', ' NoRecortar1! ');
    await api.comprobarToken(login.token);
    await api.bienvenida(login.token);
    expect(jsonDecode(llamadas[0].body), {
      'fullName': 'Alumno de prueba',
      'email': 'alumno@example.com',
      'pwd': ' NoRecortar1! '
    });
    expect(llamadas.map((r) => r.url.path), [
      '/users/register',
      '/users/login',
      '/users/check-token',
      '/users/welcome'
    ]);
    expect(llamadas[0].headers.containsKey('Authorization'), isFalse);
    expect(llamadas[2].headers['Authorization'], 'Bearer jwt-test');
    expect(login.nombre, 'Alumno de prueba');
    api.cerrar();
  });

  test('Conserva el mensaje HTTP y controla HTML o token ausente', () async {
    final error = ApiSesion(
        cliente: MockClient((_) async =>
            jsonRespuesta({'message': 'Correo ya registrado.'}, 409)));
    await expectLater(
        error.registrar('Alumno', 'a@b.es', 'Clave123!'),
        throwsA(isA<ErrorSesion>()
            .having((e) => e.mensaje, 'mensaje', 'Correo ya registrado.')
            .having((e) => e.codigo, 'HTTP', 409)));
    final html = ApiSesion(
        cliente: MockClient(
            (_) async => http.Response('<html>Bad gateway</html>', 502)));
    await expectLater(
        html.login('a@b.es', 'x'),
        throwsA(isA<ErrorSesion>()
            .having((e) => e.mensaje, 'mensaje', contains('HTTP 502'))));
    final sinToken = ApiSesion(
        cliente: MockClient((_) async => jsonRespuesta({'message': 'Login'})));
    await expectLater(
        sinToken.login('a@b.es', 'x'), throwsA(isA<ErrorSesion>()));
  });

  test('Controla timeout y desconexión sin mostrar detalles técnicos',
      () async {
    final lenta = ApiSesion(
        tiempoEspera: const Duration(milliseconds: 1),
        cliente: MockClient((_) async {
          await Future<void>.delayed(const Duration(milliseconds: 10));
          return jsonRespuesta({'message': 'tarde'});
        }));
    await expectLater(
        lenta.comprobarToken('jwt'),
        throwsA(isA<ErrorSesion>()
            .having((e) => e.mensaje, 'mensaje', contains('Render'))));
    final sinRed = ApiSesion(
        cliente:
            MockClient((_) async => throw http.ClientException('internal')));
    await expectLater(
        sinRed.login('a@b.es', 'x'),
        throwsA(isA<ErrorSesion>()
            .having((e) => e.mensaje, 'mensaje', contains('conexión'))));
  });

  test('Arranque sin token no consulta la API y arranque válido abre acceso',
      () async {
    var llamadas = 0;
    final almacen = AlmacenMemoria();
    final sesion = ControladorSesion(
        almacen: almacen,
        api: ApiSesion(cliente: MockClient((_) async {
          llamadas++;
          return jsonRespuesta({'message': 'Token válido.'});
        })));
    await sesion.restaurar();
    expect(llamadas, 0);
    expect(sesion.autenticada, isFalse);
    almacen.token = 'jwt';
    await sesion.restaurar();
    expect(llamadas, 1);
    expect(sesion.autenticada, isTrue);
  });

  test(
      'Token rechazado se borra; fallo de red conserva token pero no da acceso',
      () async {
    for (final estado in [401, 503]) {
      final almacen = AlmacenMemoria('jwt');
      final sesion = ControladorSesion(
          almacen: almacen,
          api: ApiSesion(
              cliente: MockClient((_) async =>
                  jsonRespuesta({'message': 'Error API'}, estado))));
      await sesion.restaurar();
      expect(sesion.autenticada, isFalse);
      expect(sesion.comprobando, isFalse);
      expect(almacen.token, estado == 401 ? null : 'jwt');
    }
  });

  test('Login guarda antes de entrar y logout borra antes de cerrar el acceso',
      () async {
    final almacen = AlmacenMemoria();
    final sesion = ControladorSesion(
        almacen: almacen,
        api: ApiSesion(
            cliente: MockClient((_) async =>
                jsonRespuesta({'message': 'Login correcto', 'token': 'jwt'}))));
    almacen.fallarGuardado = true;
    await expectLater(
        sesion.login('a@b.es', 'clave'), throwsA(isA<ErrorSesion>()));
    sesion.abrirAcceso();
    expect(sesion.autenticada, isFalse);
    almacen.fallarGuardado = false;
    await sesion.login('a@b.es', 'clave');
    expect(almacen.token, 'jwt');
    expect(sesion.autenticada, isFalse);
    sesion.abrirAcceso();
    expect(sesion.autenticada, isTrue);
    almacen.fallarBorrado = true;
    await expectLater(sesion.cerrarSesion(), throwsA(isA<ErrorSesion>()));
    expect(sesion.autenticada, isTrue);
    almacen.fallarBorrado = false;
    await sesion.cerrarSesion();
    expect(almacen.token, isNull);
    expect(sesion.autenticada, isFalse);
  });

  test(
      'Validaciones de nombre/email y contraseña de registro; login admite cuentas previas',
      () {
    expect(ValidacionesSesion.nombre(' '), isNotNull);
    expect(ValidacionesSesion.email('sin-email'), isNotNull);
    expect(ValidacionesSesion.email(' alumno@example.com '), isNull);
    for (final valor in [
      'corta',
      'solominusculas1!',
      'SOLOMAYUSCULAS1!',
      'SinNumero!',
      'SinSimbolo123',
      'x' * 65
    ]) {
      expect(ValidacionesSesion.contrasenaRegistro(valor), isNotNull);
    }
    expect(ValidacionesSesion.contrasenaRegistro('Valida123!'), isNull);
    expect(ValidacionesSesion.contrasenaLogin('legacy'), isNull);
    expect(ValidacionesSesion.contrasenaLogin(''), isNotNull);
  });
}
