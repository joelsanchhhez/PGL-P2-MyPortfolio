import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../servicios/api_sesion.dart';
import '../sesion/controlador_sesion.dart';
import '../tema.dart';
import '../utilidades/validaciones_sesion.dart';
import '../widgets/alerta_sesion.dart';

/// Dos destinos (login y registro) comparten campos y comportamiento del formulario.
/// Se muestran fuera del ShellRoute: no tienen Drawer ni acceso al contenido privado.
class PantallaSesion extends StatefulWidget {
  const PantallaSesion(
      {super.key, required this.sesion, this.registro = false});
  final ControladorSesion sesion;
  final bool registro;

  @override
  State<PantallaSesion> createState() => _PantallaSesionState();
}

class _PantallaSesionState extends State<PantallaSesion> {
  final _formulario = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _email = TextEditingController();
  final _contrasena = TextEditingController();
  bool _enviando = false;
  bool _mostrandoRespuesta = false;
  bool _ocultar = true;
  String? _errorMostrado;

  @override
  void initState() {
    super.initState();
    widget.sesion.addListener(_comprobarErrorInicial);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _comprobarErrorInicial());
  }

  void _comprobarErrorInicial() {
    final error = widget.sesion.errorInicial;
    if (widget.registro ||
        widget.sesion.comprobando ||
        error == null ||
        error == _errorMostrado) {
      return;
    }
    _errorMostrado = error;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        mostrarAlertaSesion(context, 'Comprobación de sesión', error);
      }
    });
  }

  /// Valida antes de enviar y espera a cerrar la alerta antes de cambiar de ruta.
  Future<void> _enviar() async {
    if (_enviando ||
        widget.sesion.comprobando ||
        !_formulario.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _enviando = true);
    try {
      final mensaje = widget.registro
          ? await widget.sesion
              .registrar(_nombre.text, _email.text, _contrasena.text)
          : await widget.sesion.login(_email.text, _contrasena.text);
      if (!mounted) return;
      setState(() => _mostrandoRespuesta = true);
      await mostrarAlertaSesion(context,
          widget.registro ? 'Registro exitoso' : 'Login exitoso', mensaje);
      if (!mounted) return;
      if (widget.registro) {
        context.go('/login');
      } else {
        widget.sesion.abrirAcceso();
      }
    } on ErrorSesion catch (error) {
      if (mounted) {
        setState(() => _mostrandoRespuesta = true);
        await mostrarAlertaSesion(
            context,
            widget.registro ? 'No se ha podido registrar' : 'Login fallido',
            error.mensaje);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _mostrandoRespuesta = true);
        await mostrarAlertaSesion(context, 'No se ha podido completar',
            'Ha ocurrido un error. Inténtalo de nuevo.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _enviando = false;
          _mostrandoRespuesta = false;
        });
      }
    }
  }

  @override
  void dispose() {
    widget.sesion.removeListener(_comprobarErrorInicial);
    _nombre.dispose();
    _email.dispose();
    _contrasena.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.sesion,
      builder: (context, _) {
        final bloqueado = _enviando || widget.sesion.comprobando;
        return PopScope(
          canPop: !bloqueado,
          child: Scaffold(
            appBar: AppBar(
                title:
                    Text(widget.registro ? 'Crear cuenta' : 'Iniciar sesión'),
                automaticallyImplyLeading: false),
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: AutofillGroup(
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
                            const SizedBox(height: 8),
                            Text(
                                widget.registro
                                    ? 'Tu cuenta para descubrir el deporte en las islas.'
                                    : 'Accede para descubrir tu próxima cancha.',
                                textAlign: TextAlign.center),
                            const SizedBox(height: 28),
                            if (widget.registro) ...[
                              TextFormField(
                                key: const ValueKey('nombre'),
                                controller: _nombre,
                                enabled: !bloqueado,
                                autofillHints: const [AutofillHints.name],
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                    labelText: 'Nombre completo',
                                    prefixIcon: Icon(Icons.person_outline),
                                    border: OutlineInputBorder()),
                                validator: ValidacionesSesion.nombre,
                              ),
                              const SizedBox(height: 18),
                            ],
                            TextFormField(
                              key: const ValueKey('email'),
                              controller: _email,
                              enabled: !bloqueado,
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              autofillHints: const [AutofillHints.email],
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.alternate_email),
                                  border: OutlineInputBorder()),
                              validator: ValidacionesSesion.email,
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              key: const ValueKey('contrasena'),
                              controller: _contrasena,
                              enabled: !bloqueado,
                              obscureText: _ocultar,
                              autocorrect: false,
                              enableSuggestions: false,
                              autofillHints: [
                                widget.registro
                                    ? AutofillHints.newPassword
                                    : AutofillHints.password
                              ],
                              onFieldSubmitted: (_) => _enviar(),
                              decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  border: const OutlineInputBorder(),
                                  errorMaxLines: 3,
                                  suffixIcon: IconButton(
                                    tooltip: _ocultar
                                        ? 'Mostrar contraseña'
                                        : 'Ocultar contraseña',
                                    onPressed: bloqueado
                                        ? null
                                        : () => setState(
                                            () => _ocultar = !_ocultar),
                                    icon: Icon(_ocultar
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined),
                                  )),
                              validator: widget.registro
                                  ? ValidacionesSesion.contrasenaRegistro
                                  : ValidacionesSesion.contrasenaLogin,
                            ),
                            if (widget.registro) ...[
                              const SizedBox(height: 8),
                              const Text(
                                  '8 a 64 caracteres: mayúscula, minúscula, número y símbolo.',
                                  style: TextStyle(fontSize: 12)),
                            ],
                            const SizedBox(height: 24),
                            FilledButton.icon(
                              key: const ValueKey('enviar-sesion'),
                              onPressed: bloqueado ? null : _enviar,
                              icon: bloqueado && !_mostrandoRespuesta
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2))
                                  : Icon(widget.registro
                                      ? Icons.person_add_outlined
                                      : Icons.login),
                              label: Text(widget.sesion.comprobando
                                  ? 'Comprobando sesión…'
                                  : _enviando && !_mostrandoRespuesta
                                      ? 'Esperando respuesta…'
                                      : widget.registro
                                          ? 'Registrarme'
                                          : 'Entrar'),
                            ),
                            if (bloqueado && !_mostrandoRespuesta) ...[
                              const SizedBox(height: 12),
                              const Text(
                                  'La primera petición puede tardar hasta 60 segundos mientras Render despierta.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12)),
                            ],
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: bloqueado
                                  ? null
                                  : () => context.go(
                                      widget.registro ? '/login' : '/registro'),
                              child: Text(widget.registro
                                  ? 'Ya tengo cuenta. Iniciar sesión'
                                  : 'Crear una cuenta'),
                            ),
                            if (!widget.registro &&
                                widget.sesion.errorInicial != null)
                              TextButton.icon(
                                onPressed: bloqueado
                                    ? null
                                    : () {
                                        _errorMostrado = null;
                                        widget.sesion.restaurar();
                                      },
                                icon: const Icon(Icons.refresh),
                                label: const Text('Reintentar sesión guardada'),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
