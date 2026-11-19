import 'package:flutter_test/flutter_test.dart';
import 'package:pgl_p2_myportfolio/excepciones/error_api.dart';
import 'package:pgl_p2_myportfolio/modelos/respuesta_login.dart';
import 'package:pgl_p2_myportfolio/utilidades/validaciones_sesion.dart';

void main() {
  test('La respuesta de login exige token y conserva el mensaje de la API', () {
    final respuesta = RespuestaLogin.fromJson(
        {'message': 'Login correcto', 'token': 'jwt-de-prueba'});
    expect(respuesta.mensaje, 'Login correcto');
    expect(respuesta.token, 'jwt-de-prueba');
    expect(() => RespuestaLogin.fromJson({'message': 'Sin token'}),
        throwsA(isA<ErrorApi>()));
  });

  test('Los formularios validan nombre, email y contraseña', () {
    expect(ValidacionesSesion.nombre('  '), isNotNull);
    expect(ValidacionesSesion.nombre('Alumno Prueba'), isNull);
    expect(ValidacionesSesion.email('sin-email'), isNotNull);
    expect(ValidacionesSesion.email('alumno@example.com'), isNull);
    expect(ValidacionesSesion.contrasenaLogin(''), isNotNull);
    expect(ValidacionesSesion.contrasenaLogin('cuenta-anterior'), isNull);
    for (final texto in [
      'corta',
      'sinmayuscula1!',
      'SINMINUSCULA1!',
      'SinNumero!',
      'SinSimbolo123'
    ]) {
      expect(ValidacionesSesion.contrasenaRegistro(texto), isNotNull);
    }
    expect(ValidacionesSesion.contrasenaRegistro('Valida123!'), isNull);
  });
}
