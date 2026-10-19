import 'dart:ui';

import 'package:tbp/core/models/body.dart';
import 'package:vector_math/vector_math_64.dart';

class Physics {
  List<Body> bodies = [
    // 1. Cisim (Kırmızı)
    Body(
      position: Vector3(-120.0, 30.0, 0.0),
      velocity: Vector3(48.0, 44.0, 0.0),
      acceleration: Vector3(0, 0, 0),
      mass: 50.0, // Üç cismin de kütlesi eşit olmalı!
      radius: 8.0,
      color: Color(0xFFFF5252),
    ),

    // 2. Cisim (Mavi) - 1. cismin simetriği
    Body(
      position: Vector3(120.0, -30.0, 0.0),
      velocity: Vector3(48.0, 44.0, 0.0),
      acceleration: Vector3(0, 0, 0),
      mass: 50.0,
      radius: 8.0,
      color: Color(0xFF448AFF),
    ),

    // 3. Cisim (Yeşil) - Merkezdeki dengeleyici cisim
    Body(
      position: Vector3(0.0, 0.0, 0.0),
      velocity: Vector3(-96.0, -88.0, 0.0),
      acceleration: Vector3(0, 0, 0),
      mass: 50.0,
      radius: 8.0,
      color: Color(0xFF69F0AE),
    ),
  ];
  void updatePhysics(List<Body> bodies, double dt) {
    for (var x = 0; x < bodies.length; x++) {
      bodies[x].acceleration.setZero();
    }
    for (var i = 0; i < bodies.length; i++) {
      for (var j = 0; j < bodies.length; j++) {
        if (j == i) continue;
        const double G = 100.0;
        Body bodyA = bodies[i];
        Body bodyB = bodies[j];
        double distance = bodyA.position.distanceTo(bodyB.position);
        double force = (G * bodyA.mass * bodyB.mass) / (distance * distance);
        Vector3 direction = bodyB.position - bodyA.position;
        direction.normalize();
        bodyA.acceleration += direction * force / bodyA.mass;
      }
    }
    for (var x = 0; x < bodies.length; x++) {
      bodies[x].velocity += bodies[x].acceleration * dt;
      bodies[x].position += bodies[x].velocity * dt;
      bodies[x].acceleration.setZero();
    }
  }
}
