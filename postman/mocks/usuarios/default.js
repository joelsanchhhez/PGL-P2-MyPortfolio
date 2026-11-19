// Simulación local basada en las rutas del profesor. No valida firmas JWT reales.
const http = require('http');
const crypto = require('crypto');
const hash = (text) => crypto.createHash('sha256').update(text).digest('hex');
const enviar = (res, status, datos) => {
  res.writeHead(status, {'Content-Type': 'application/json; charset=utf-8'});
  res.end(JSON.stringify(datos));
};
http.createServer(async (req, res) => {
  try {
    const ruta = new URL(req.url, 'http://localhost').pathname;
    const usuarios = await pm.state.get('usuarios.registros') || {};
    const datos = req.body || {};
    if (req.method === 'POST' && ruta === '/users/register') {
      if (!datos.fullName || !datos.email || !datos.pwd) return enviar(res, 400, {message: 'Todos los campos son obligatorios.'});
      if (usuarios[datos.email]) return enviar(res, 409, {message: 'Este correo electrónico ya está registrado.'});
      usuarios[datos.email] = {name: datos.fullName, email: datos.email, hash: hash(datos.pwd)};
      await pm.state.set('usuarios.registros', usuarios);
      return enviar(res, 201, {message: 'Usuario registrado con éxito.'});
    }
    if (req.method === 'POST' && ruta === '/users/login') {
      const usuario = usuarios[datos.email];
      if (!usuario) return enviar(res, 404, {message: 'Usuario no encontrado.'});
      if (usuario.hash !== hash(datos.pwd)) return enviar(res, 401, {message: 'Credenciales de usuario incorrectas.'});
      const token = 'simulado-' + crypto.randomUUID();
      await pm.state.set('usuarios.token.' + token, {name: usuario.name, email: usuario.email});
      return enviar(res, 200, {message: 'Inicio de sesión exitoso.', token, user: {name: usuario.name, email: usuario.email}});
    }
    if (req.method === 'GET' && ['/users/check-token', '/users/welcome'].includes(ruta)) {
      const token = (req.headers.authorization || '').replace(/^Bearer /, '');
      const usuario = token && await pm.state.get('usuarios.token.' + token);
      if (!usuario) return enviar(res, 401, {message: 'Token inválido o expirado'});
      return enviar(res, 200, {message: ruta.endsWith('welcome') ? `¡Bienvenido a la aplicación, ${usuario.name}!` : 'Token válido.'});
    }
    return enviar(res, 501, {message: 'Ruta no modelada en esta simulación.'});
  } catch (_) {
    return enviar(res, 500, {message: 'Error en la simulación local.'});
  }
}).listen(process.env.PORT || 4505);
