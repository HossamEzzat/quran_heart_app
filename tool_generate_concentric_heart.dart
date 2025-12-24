import 'dart:math';

void main() {
  // Concentric Parametric Heart Generator
  // Explicitly places points on heart curves to guarantee the shape.
  // Formula:
  // x = 16 * sin(t)^3
  // y = 13 * cos(t) - 5*cos(2*t) - 2*cos(3*t) - cos(4*t)

  List<Point> points = [];

  // Target: 114 points.
  // We can treat this as "shells".
  // Shell 1 (Outer): t goes 0..2pi
  // Shell 2 (Inner): scaled down ...

  // Let's create uniform density.
  // Circumference approx proportional to Scale.
  // C ~ 2 * pi * R_avg

  // Let's manually tune layers for 114 total.
  // Layer 4 (Outermost): Scale 1.0. Count ~ 48
  // Layer 3: Scale 0.75. Count ~ 36
  // Layer 2: Scale 0.50. Count ~ 22
  // Layer 1 (Center): Scale 0.25. Count ~ 8
  // Total: 48+36+22+8 = 114. perfect.

  points.addAll(generateRing(1.0, 48));
  points.addAll(generateRing(0.76, 36));
  points.addAll(generateRing(0.53, 22));
  points.addAll(generateRing(0.30, 8)); // 114 total

  // Center is empty? 114 is exact.

  // Normalize points to approx range -0.8 to 0.8 for the view
  // The parametric formula produces values up to ~16.
  // We need to scale down by ~ 1/20.

  double scaleFactor = 0.045;

  // Generate output
  print("import 'dart:ui';");
  print("// Concentric Parametric Heart (114 Points)");
  print("const List<Offset> heartPositions = [");

  // We should SORT them so Surah 1 is at top?
  // User didn't specify, but usually top-to-bottom or center-out is good.
  // Let's sort Top-Down (highest Y first). Note: In our formula +Y is up.
  // Screen Y is down. So we flip Y when printing.

  // Sort by Y descending (Top of heart to bottom tip)
  points.sort((a, b) => b.y.compareTo(a.y));

  for (var p in points) {
    double x = p.x * scaleFactor;
    double y = -p.y * scaleFactor; // Flip for screen coords

    // Shift Y slightly to center it vertically in the view
    y += 0.05;

    print("  Offset(${x.toStringAsFixed(3)}, ${y.toStringAsFixed(3)}),");
  }
  print("];");
}

List<Point> generateRing(double scale, int count) {
  List<Point> ring = [];
  for (int i = 0; i < count; i++) {
    // t from 0 to 2pi
    // Add slight offset based on layer to stagger them?
    // i/count gives fraction.
    // We start from pi/2 (top) to ensure symmetry?
    // Actually 0 is top in this formula?

    // x = 16 sin^3 t.
    // if t=0, x=0, y= 13-5-2-1 = 5. (Top Dip)
    // Wait, y(0) = 5.
    // y(pi) = 13(-1) - 5(1) -2(-1) -1 = -13 -5 +2 -1 = -17 (Bottom Tip)
    // So t=0 is the "Cusp" at the top.
    // We want to distribute EVNELY along the curve length, not just t.
    // But uniform t is "okay" for this shape usually.

    double t = (i / count) * 2 * pi;

    // Apply Formula
    double x = 16 * pow(sin(t), 3) * scale;
    double y =
        (13 * cos(t) - 5 * cos(2 * t) - 2 * cos(3 * t) - cos(4 * t)) * scale;

    ring.add(Point(x, y));
  }
  return ring;
}

class Point {
  final double x, y;
  Point(this.x, this.y);
}
