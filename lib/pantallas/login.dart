import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../excepciones/error_api.dart';
import '../servicios/servicio_sesion.dart';
import '../tema.dart';
import '../utilidades/validaciones_sesion.dart';
import '../widgets/alerta_sesion.dart';

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});
  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final _formulario = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _contrasena = TextEditingController();
  final _sesion = ServicioSesion();
  bool _comprobando = true;
  bool _enviando = false;

  @override
  void initState() {
    super.initState();
    _comprobarSesion();
  }

  /// Al arrancar se ve solo este login; si el JWT guardado sirve, abre Bienvenida.
  Future<void> _comprobarSesion() async {
    bool valida = false;
    String? error;
    try {
      valida = await _sesion.restaurar();
    } on ErrorApi catch (e) {
      error = e.mensaje;
    }
    if (!mounted) return;
    setState(() => _comprobando = false);
    if (valida) {
      context.go('/');
    } else if (error != null) {
      await mostrarAlertaSesion(context, 'Comprobación de sesión', error);
    }
  }

  /// Valida, llama al servicio y muestra la respuesta antes de cambiar de pantalla.
  Future<void> _login() async {
    if (_enviando || _comprobando || !_formulario.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _enviando = true);
    String mensaje;
    bool correcto = false;
    try {
      mensaje = await _sesion.login(_email.text, _contrasena.text);
      correcto = true;
    } on ErrorApi catch (e) {
      mensaje = e.mensaje;
    }
    if (!mounted) return;
    setState(() => _enviando = false);
    await mostrarAlertaSesion(
        context, correcto ? 'Login exitoso' : 'Login fallido', mensaje);
    if (mounted && correcto) context.go('/');
  }

  @override
  void dispose() {
    _email.dispose();
    _contrasena.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ocupado = _comprobando || _enviando;
    return Scaffold(
      appBar: AppBar(
          title: const Text('Iniciar sesión'),
          automaticallyImplyLeading: false),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formulario,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.sports_soccer,
                        size: 48, color: ColoresApp.primario),
                    const SizedBox(height: 12),
                    const Text('Cancha Canaria',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: ColoresApp.primario)),
                    const SizedBox(height: 24),
                    TextFormField(
                      key: const ValueKey('email'),
                      controller: _email,
                      enabled: !ocupado,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          labelText: 'Email', border: OutlineInputBorder()),
                      validator: ValidacionesSesion.email,
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      key: const ValueKey('contrasena'),
                      controller: _contrasena,
                      enabled: !ocupado,
                      obscureText: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          border: OutlineInputBorder()),
                      validator: ValidacionesSesion.contrasenaLogin,
                    ),
                    const SizedBox(height: 24),
                    if (ocupado) ...[
                      const Center(child: CircularProgressIndicator()),
                      const SizedBox(height: 12),
                      Text(
                          _comprobando
                              ? 'Comprobando sesión…'
                              : 'Esperando respuesta de la API…',
                          textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                    ],
                    FilledButton(
                      key: const ValueKey('enviar-sesion'),
                      onPressed: ocupado ? null : _login,
                      child: const Text('Entrar'),
                    ),
                    TextButton(
                      onPressed: ocupado ? null : () => context.go('/registro'),
                      child: const Text('Crear una cuenta'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
