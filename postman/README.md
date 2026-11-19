# Pruebas HTTP locales de sesión

Contrato: `docs/api_sesion.openapi.json`, contrastado con el código público del
profesor (9f2dc04). El generador de Postman produjo el esqueleto y se adaptó el
handler para que registro y login compartan estado. No reproduce firmas JWT:
los tokens con prefijo `simulado-` solo sirven en este servidor local.

El catálogo Orbit no encontró esta API educativa. No se descargó un mock de
un tercero: se utiliza el contrato del profesor. Esta instalación del CLI no
dispone de `postman status` y el generador mostró un error del llavero después
de escribir los archivos; las pruebas locales funcionan con `--no-history` y
no requieren iniciar sesión ni publicar nada en un workspace.

Ejecutar la simulación y, en otra terminal, el servicio Dart:

```bash
postman simulation run postman/simulations/sesion.sim.yaml --port 4505 --no-history
dart run tool/probar_api_simulada.dart
```

La prueba ejecutada valida registro, login incorrecto y correcto, cabecera
Bearer, token inválido, respuesta 503 y timeout con HTTP real local.
Las condiciones y el alcance de la evidencia están en `sesion.context.yaml`.

La prueba de integración de Android usa la API real, no esta simulación.
No deben añadirse credenciales reales, tokens ni logs de ejecución al repositorio.
