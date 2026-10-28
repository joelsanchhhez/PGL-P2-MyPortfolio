import 'package:flutter/material.dart';

/// Ilustración vectorial de la cancha de la propuesta visual de la práctica 1.
/// No necesita fotografías externas y se adapta a cualquier tamaño de pantalla.
class CanchaFondo extends StatelessWidget {
  const CanchaFondo({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _PintorCancha());
  }
}

class _PintorCancha extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width, size.height);

    final cielo = Paint()..color = const Color(0xFF8ED6F2);
    canvas.drawRect(const Rect.fromLTWH(0, 0, 1, 1), cielo);

    Path poligono(List<Offset> puntos) {
      final p = Path()..moveTo(puntos.first.dx, puntos.first.dy);
      for (final punto in puntos.skip(1)) {
        p.lineTo(punto.dx, punto.dy);
      }
      return p..close();
    }

    canvas.drawPath(
      poligono(const [
        Offset(0, .37),
        Offset(.17, .22),
        Offset(.31, .32),
        Offset(.52, .14),
        Offset(.83, .40),
        Offset(1, .27),
        Offset(1, .63),
        Offset(0, .63),
      ]),
      Paint()..color = const Color(0xFF516780),
    );

    canvas.drawPath(
      poligono(const [
        Offset(0, .53),
        Offset(1, .43),
        Offset(1, 1),
        Offset(0, 1),
      ]),
      Paint()..color = const Color(0xFFC3A980),
    );

    final pista = poligono(const [
      Offset(.09, .60),
      Offset(.89, .55),
      Offset(.985, .95),
      Offset(.015, .99),
    ]);
    canvas.drawPath(pista, Paint()..color = const Color(0xFF206B61));
    canvas.drawPath(
      pista,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = .008,
    );

    final trazos = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = .005;
    canvas.drawLine(const Offset(.055, .78), const Offset(.94, .745), trazos);
    canvas.drawOval(const Rect.fromLTWH(.37, .73, .25, .10), trazos);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
