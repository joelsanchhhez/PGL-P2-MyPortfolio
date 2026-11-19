import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Esta interfaz permite probar la sesión sin depender del almacenamiento nativo.
abstract class AlmacenToken {
  Future<String?> leer();
  Future<void> guardar(String token);
  Future<void> eliminar();
}

/// En Android usa los cifrados del plugin con claves protegidas por Android Keystore.
/// Solo guardamos el JWT: nunca se almacena la contraseña.
class AlmacenTokenSeguro implements AlmacenToken {
  AlmacenTokenSeguro({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();
  final FlutterSecureStorage _storage;
  static const _clave = 'cancha_canaria_jwt';

  @override
  Future<String?> leer() => _storage.read(key: _clave);
  @override
  Future<void> guardar(String token) =>
      _storage.write(key: _clave, value: token);
  @override
  Future<void> eliminar() => _storage.delete(key: _clave);
}
