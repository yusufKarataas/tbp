import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tbp/core/models/body.dart';
import 'package:tbp/physics/physics.dart';

class SimulationScreen extends StatefulWidget {
  const SimulationScreen({super.key});

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  Duration _lastElapsed = Duration.zero;
  final Physics _physics = Physics();

  @override
  void initState() {
    // TODO: implement initState

    _ticker = createTicker((elapsed) {
      final double dt = (_lastElapsed == Duration.zero)
          ? 0.016
          : (elapsed - _lastElapsed).inMilliseconds / 1000.0;
      _lastElapsed = elapsed;

      setState(() {
        _physics.updatePhysics(_physics.bodies, dt.clamp(0.0, 0.033));
      });
    });
    _ticker.start();
    super.initState();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomPaint(
        painter: SpacePainter(bodies: _physics.bodies),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class SpacePainter extends CustomPainter {
  final List<Body> bodies;

  SpacePainter({required this.bodies});
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const double cameraDistance = 200.0;

    for (var body in bodies) {
      double z = body.position.z;

      double scale = cameraDistance / (cameraDistance + z);

      if (scale <= 0) continue;

      double projectedX = center.dx + body.position.x * scale;
      double projectedY = center.dy + body.position.y * scale;
      double projectedRadius = body.radius * scale;

      final paint = Paint()
        ..color = body.color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(projectedX, projectedY),
        projectedRadius > 0 ? projectedRadius : 1,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
