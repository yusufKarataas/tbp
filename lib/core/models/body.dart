import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class Body {
  Vector3 position;
  Vector3 velocity;
  Vector3 acceleration;
  double mass;
  double radius;
  Color color;

  Body({
    required this.position,
    required this.velocity,
    required this.acceleration,
    required this.mass,
    required this.radius,
    required this.color,
  });
}
