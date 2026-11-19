import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../excepciones/error_api.dart';
import 'api_sesion.dart';

/// Singleton sencillo, como en los apuntes: comparte la sesión entre pantallas.
class ServicioSesion {
  ServicioSesion._();
  static final ServicioSesion _instancia = ServicioSesion._();
  factory ServicioSesion() => _instancia;

  final _api = ApiSesion();
  final _almacen = const FlutterSecureStorage();
  static const _clave = 'cancha_canaria_jwt';
  String? _token;
  bool get autenticada => _token != null;

  /// Leer el token no basta: solo se permite entrar si la API confirma su validez.
  Future<bool> restaurar() async {
    _token = null;
    final String? guardado;
    try {
      guardado = await _almacen.read(key: _clave);
    } catch (_) {
      throw const ErrorApi('No se ha podido leer la sesión del dispositivo.');
    }
    if (guardado == null || guardado.isEmpty) return false;
    try {
      await _api.comprobarToken(guardado);
    } on ErrorApi catch (error) {
      if (error.codigo == 401 || error.codigo == 403) {
        await cerrarSesion();
      }
      // Un fallo de red no elimina el token guardado, pero tampoco permite entrar.
      rethrow;
    }
    _token = guardado;
    return true;
  }

  Future<String> login(String email, String contrasena) async {
    final respuesta = await _api.login(email, contrasena);
    try {
      await _almacen.write(key: _clave, value: respuesta.token);
    } catch (_) {
      throw const ErrorApi('No se ha podido guardar el token de forma segura.');
    }
    _token = respuesta.token;
    return respuesta.mensaje;
  }

  Future<String> bienvenida() async {
    if (_token == null) {
      throw const ErrorApi('Debes iniciar sesión.', codigo: 401);
    }
    return _api.bienvenida(_token!);
  }

  /// Primero borra el JWT del dispositivo. Nunca se guarda la contraseña.
  Future<void> cerrarSesion() async {
    try {
      await _almacen.delete(key: _clave);
    } catch (_) {
      throw const ErrorApi(
          'No se ha podido eliminar la sesión. Inténtalo de nuevo.');
    }
    _token = null;
  }
}
