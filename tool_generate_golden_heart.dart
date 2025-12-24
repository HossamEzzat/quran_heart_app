import 'dart:math';

void main() {
  const int totalSurahs = 114;
  List<Point> points = [];
  Random random = Random();

  // 1. Defined boundary logic to match the uploaded anatomical image
  bool isInsideAnatomicalHeart(double x, double y) {
    // Main asymmetric body
    double mainBody = pow(x + 0.1, 2) / 0.9 + pow(y + 0.2, 2) / 1.3;

    // Left Bulge (the "thick" side of the heart in your image)
    bool leftBulge = pow(x + 0.6, 2) / 0.4 + pow(y - 0.2, 2) / 0.6 < 0.5;

    // Top Vessels (The 'tubes' at the top of the image)
    bool vessel1 = (x > -0.15 && x < 0.2 && y > 0.8 && y < 1.8); // Center
    bool vessel2 = (x < -0.3 && x > -0.7 && y > 0.5 && y < 1.5); // Left
    bool vessel3 = (x > 0.4 && x < 0.9 && y > 0.2 && y < 1.1); // Right

    // Bottom Taper (The 'Apex')
    if (y < -0.6) {
      double taper = (y + 1.5) * 0.6;
      if (x.abs() > taper) return false;
    }

    return mainBody < 1.0 || leftBulge || vessel1 || vessel2 || vessel3;
  }

  // 2. Initial Random Seed
  while (points.length < totalSurahs) {
    double rx = (random.nextDouble() * 3) - 1.5;
    double ry = (random.nextDouble() * 3) - 1.5;
    if (isInsideAnatomicalHeart(rx, ry)) {
      points.add(Point(rx, ry));
    }
  }

  // 3. Relaxation Step (The "Organic Cell" Look)
  // This pushes points away from each other so they don't overlap
  for (int step = 0; step < 150; step++) {
    for (int i = 0; i < points.length; i++) {
      double fx = 0, fy = 0;
      for (int j = 0; j < points.length; j++) {
        if (i == j) continue;
        double dx = points[i].x - points[j].x;
        double dy = points[i].y - points[j].y;
        double d = sqrt(dx * dx + dy * dy);
        if (d < 0.25) {
          // Repulsion radius
          fx += (dx / d) * 0.015;
          fy += (dy / d) * 0.015;
        }
      }
      double nx = points[i].x + fx;
      double ny = points[i].y + fy;
      if (isInsideAnatomicalHeart(nx, ny)) {
        points[i] = Point(nx, ny);
      }
    }
  }

  // 4. Output as Flutter Offsets
  print("// Anatomical Qur'aan Heart Points");
  print("const List<Offset> quranHeart = [");
  for (var p in points) {
    // Adjusted and scaled for a 400x400 coordinate system
    double screenX = (p.x * 120) + 200;
    double screenY = (-p.y * 120) + 200;
    print(
      "  Offset(${screenX.toStringAsFixed(2)}, ${screenY.toStringAsFixed(2)}),",
    );
  }
  print("];");
}

class Point {
  double x, y;
  Point(this.x, this.y);
}
