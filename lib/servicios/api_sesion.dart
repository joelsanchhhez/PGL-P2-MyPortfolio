import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../excepciones/error_api.dart';
import '../modelos/respuesta_login.dart';

/// Todas las peticiones HTTP están aquí; los widgets solo muestran sus resultados.
class ApiSesion {
  static const _url = 'https://my-users-api.onrender.com/users';
  static const _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  Future<String> registrar(
      String nombre, String email, String contrasena) async {
    final datos = await _leerRespuesta(http.post(
      Uri.parse('$_url/register'),
      headers: _headers,
      body: jsonEncode({
        'fullName': nombre.trim(),
        'email': email.trim(),
        'pwd': contrasena
      }),
    ));
    return datos['message'] as String;
  }

  Future<RespuestaLogin> login(String email, String contrasena) async {
    final datos = await _leerRespuesta(http.post(
      Uri.parse('$_url/login'),
      headers: _headers,
      body: jsonEncode({'email': email.trim(), 'pwd': contrasena}),
    ));
    return RespuestaLogin.fromJson(datos);
  }

  Future<String> comprobarToken(String token) => _get('check-token', token);
  Future<String> bienvenida(String token) => _get('welcome', token);

  /// La API identifica la sesión mediante esta cabecera, no mediante el formulario.
  Future<String> _get(String endpoint, String token) async {
    final datos = await _leerRespuesta(http.get(
      Uri.parse('$_url/$endpoint'),
      headers: {..._headers, 'Authorization': 'Bearer $token'},
    ));
    return datos['message'] as String;
  }

  /// Centraliza JSON y errores HTTP. El timeout es de 90 s porque Render puede tardar 60 s.
  Future<Map<String, dynamic>> _leerRespuesta(
      Future<http.Response> peticion) async {
    try {
      final respuesta = await peticion.timeout(const Duration(seconds: 90));
      Map<String, dynamic>? datos;
      try {
        final json = jsonDecode(utf8.decode(respuesta.bodyBytes));
        if (json is Map<String, dynamic>) datos = json;
      } on FormatException {
        // Si un servidor intermedio devuelve HTML, mostramos un error legible.
      }
      if (respuesta.statusCode < 200 || respuesta.statusCode >= 300) {
        throw ErrorApi(
            datos?['message'] is String
                ? datos!['message'] as String
                : 'El servidor no está disponible (HTTP ${respuesta.statusCode}).',
            codigo: respuesta.statusCode);
      }
      if (datos == null || datos['message'] is! String) {
        throw const ErrorApi('La API ha enviado una respuesta no válida.');
      }
      return datos;
    } on TimeoutException {
      throw const ErrorApi(
          'La API ha tardado demasiado. Render puede estar despertando; inténtalo de nuevo en un momento.');
    } on http.ClientException {
      throw const ErrorApi(
          'No se ha podido conectar con la API. Comprueba tu conexión.');
    }
  }
}
