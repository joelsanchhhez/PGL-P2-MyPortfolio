import 'dart:io';

import 'package:pgl_p2_myportfolio/servicios/api_sesion.dart';

Future<void> main() async {
  final api = ApiSesion(baseUrl: 'http://127.0.0.1:4505/usuarios');
  final email = 'prueba.${DateTime.now().microsecondsSinceEpoch}@example.com';
  // Datos descartables usados únicamente por el servidor simulado local.
  const clave = 'ClaveLocal123!';
  final registro = await api.registrar('Alumno Simulado', email, clave);
  if (!registro.contains('registrado')) throw StateError('Fallo de registro');
  try {
    await api.login(email, 'equivocada');
    throw StateError('Se ha aceptado una contraseña incorrecta');
  } on ErrorSesion catch (error) {
    if (error.codigo != 401) rethrow;
  }
  final login = await api.login(email, clave);
  await api.comprobarToken(login.token);
  if (!(await api.bienvenida(login.token)).contains('Alumno Simulado')) {
    throw StateError('Fallo de bienvenida');
  }
  try {
    await api.comprobarToken('token-invalido');
    throw StateError('Se ha aceptado un token inválido');
  } on ErrorSesion catch (error) {
    if (!error.tokenRechazado) rethrow;
  }
  final caida = ApiSesion(baseUrl: 'http://127.0.0.1:4505/caida');
  try {
    await caida.login(email, clave);
    throw StateError('No se ha detectado el 503');
  } on ErrorSesion catch (error) {
    if (error.codigo != 503) rethrow;
  }
  final lenta = ApiSesion(
      baseUrl: 'http://127.0.0.1:4505/lenta',
      tiempoEspera: const Duration(milliseconds: 50));
  try {
    await lenta.comprobarToken('jwt');
    throw StateError('No se ha detectado el timeout');
  } on ErrorSesion catch (error) {
    if (!error.mensaje.contains('Render')) rethrow;
  }
  api.cerrar();
  caida.cerrar();
  lenta.cerrar();
  stdout.writeln(
      'PASS: HTTP real local, registro/login/Bearer, token inválido, 503 y timeout.');
}
