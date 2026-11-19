import 'package:flutter/foundation.dart';

import '../servicios/almacen_token.dart';
import '../servicios/api_sesion.dart';

/// Coordina la sesión y avisa a go_router cuando cambia el acceso permitido.
class ControladorSesion extends ChangeNotifier {
  ControladorSesion({required this.api, required this.almacen});
  final ApiSesion api;
  final AlmacenToken almacen;
  bool comprobando = true;
  bool autenticada = false;
  String? nombre;
  String? errorInicial;
  String? _token;
  bool _eliminado = false;

  void _avisar() {
    if (!_eliminado) notifyListeners();
  }

  /// La API decide si el JWT sirve. Un fallo de red no borra una sesión guardada.
  Future<void> restaurar() async {
    comprobando = true;
    errorInicial = null;
    _avisar();
    try {
      final token = await almacen.leer();
      if (token != null && token.isNotEmpty) {
        await api.comprobarToken(token);
        _token = token;
        autenticada = true;
      }
    } on ErrorSesion catch (error) {
      autenticada = false;
      _token = null;
      if (error.tokenRechazado) {
        try {
          await almacen.eliminar();
        } catch (_) {
          errorInicial =
              'No se ha podido eliminar la sesión caducada del dispositivo.';
        }
      }
      errorInicial ??= error.mensaje;
    } catch (_) {
      errorInicial =
          'No se ha podido leer la sesión guardada. Puedes iniciar sesión de nuevo.';
    } finally {
      comprobando = false;
      _avisar();
    }
  }

  Future<String> registrar(String nombre, String email, String contrasena) =>
      api.registrar(nombre, email, contrasena);

  /// Se guarda antes de abrir el acceso. Si falla el guardado, no entra en la app.
  Future<String> login(String email, String contrasena) async {
    final resultado = await api.login(email, contrasena);
    try {
      await almacen.guardar(resultado.token);
    } catch (_) {
      throw const ErrorSesion(
          'No se ha podido guardar la sesión de forma segura. Inténtalo de nuevo.');
    }
    _token = resultado.token;
    nombre = resultado.nombre;
    return resultado.mensaje;
  }

  /// La pantalla llama después de que el usuario cierre la alerta de login exitoso.
  void abrirAcceso() {
    autenticada = _token != null;
    _avisar();
  }

  Future<String> bienvenida() async {
    if (_token == null) {
      throw const ErrorSesion('Debes iniciar sesión.', codigo: 401);
    }
    return api.bienvenida(_token!);
  }

  Future<void> cerrarSesion() async {
    try {
      await almacen.eliminar();
    } catch (_) {
      throw const ErrorSesion(
          'No se ha podido borrar la sesión del dispositivo. Inténtalo de nuevo.');
    }
    _token = null;
    nombre = null;
    autenticada = false;
    _avisar();
  }

  @override
  void dispose() {
    _eliminado = true;
    super.dispose();
  }
}
