class ValidacionesSesion {
  static String? nombre(String? valor) {
    final texto = valor?.trim() ?? '';
    if (texto.length < 3 || texto.length > 100) {
      return 'Introduce tu nombre completo (3 a 100 caracteres).';
    }
    return null;
  }

  static String? email(String? valor) =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(valor?.trim() ?? '')
          ? null
          : 'Introduce un email válido.';

  /// La contraseña de login solo se exige: no imponemos reglas nuevas a cuentas existentes.
  static String? contrasenaLogin(String? valor) =>
      valor == null || valor.isEmpty ? 'Introduce tu contraseña.' : null;

  static String? contrasenaRegistro(String? valor) {
    final texto = valor ?? '';
    if (texto.length < 8 ||
        texto.length > 64 ||
        !RegExp(r'[A-Z]').hasMatch(texto) ||
        !RegExp(r'[a-z]').hasMatch(texto) ||
        !RegExp(r'[0-9]').hasMatch(texto) ||
        !RegExp(r'[^a-zA-Z0-9\s]').hasMatch(texto)) {
      return 'Usa 8 a 64 caracteres, mayúscula, minúscula, número y símbolo.';
    }
    return null;
  }
}
