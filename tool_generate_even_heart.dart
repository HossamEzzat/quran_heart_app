import 'dart:math';

void main() {
  // Evenly Spaced Concentric Heart Generator
  // Uses Numerical Arc-Length Sampling to ensure uniform point distribution.

  List<Point> points = [];

  // Counts derived from scale to maintain constant density
  // Outer (1.0): 48
  // Ring 2 (0.75): 36
  // Ring 3 (0.50): 22
  // Ring 4 (0.25): 8
  // Sum = 114

  points.addAll(generateEvenRing(1.0, 48));
  points.addAll(generateEvenRing(0.76, 36));
  points.addAll(generateEvenRing(0.53, 22));
  points.addAll(generateEvenRing(0.30, 8));

  double scaleFactor = 0.045;

  print("import 'dart:ui';");
  print("// Concentric Evenly-Spaced Heart (114 Points)");
  print("const List<Offset> heartPositions = [");

  // Sort Top-Down
  points.sort((a, b) => b.y.compareTo(a.y));

  for (var p in points) {
    double x = p.x * scaleFactor;
    double y = -p.y * scaleFactor; // Flip for screen
    y += 0.05; // Center vertically
    print("  Offset(${x.toStringAsFixed(3)}, ${y.toStringAsFixed(3)}),");
  }
  print("];");
}

List<Point> generateEvenRing(double scale, int count) {
  List<Point> ring = [];

  // 1. Calculate Total Arc Length of the Heart Curve
  // We'll approximate by summing distances of many small steps
  int segments = 1000;
  List<double> cumulativeLength = [0.0];
  List<double> tValues = [0.0];

  double totalLength = 0;
  Point prev = evalHeart(0, scale);

  for (int i = 1; i <= segments; i++) {
    double t = (i / segments) * 2 * pi;
    Point current = evalHeart(t, scale);
    double dist = sqrt(pow(current.x - prev.x, 2) + pow(current.y - prev.y, 2));
    totalLength += dist;
    cumulativeLength.add(totalLength);
    tValues.add(t);
    prev = current;
  }

  // 2. Sample points at uniform distances
  double stepLen = totalLength / count;

  // Start offset to ensure symmetry?
  // t=0 is top cusp. We want a point there?
  // Actually, usually avoid putting a point exactly in the sharp cleft if possible,
  // or put one exactly there.
  // With 48 points, one at top (0) and one at bottom (pi) is nice.

  for (int i = 0; i < count; i++) {
    double targetLen = i * stepLen;
    // Find t corresponding to targetLen
    double t = interpolateT(targetLen, cumulativeLength, tValues);
    ring.add(evalHeart(t, scale));
  }

  return ring;
}

Point evalHeart(double t, double scale) {
  // x = 16 sin^3 t
  // y = 13 cos t - 5 cos 2t - 2 cos 3t - cos 4t
  double x = 16 * pow(sin(t), 3).toDouble();
  double y = (13 * cos(t) - 5 * cos(2 * t) - 2 * cos(3 * t) - cos(4 * t));
  return Point(x * scale, y * scale);
}

double interpolateT(
  double targetLen,
  List<double> lengths,
  List<double> tVals,
) {
  // Binary search or linear scan
  // lengths is sorted.
  for (int i = 0; i < lengths.length - 1; i++) {
    if (targetLen >= lengths[i] && targetLen <= lengths[i + 1]) {
      // Interpolate
      double ratio = (targetLen - lengths[i]) / (lengths[i + 1] - lengths[i]);
      return tVals[i] + ratio * (tVals[i + 1] - tVals[i]);
    }
  }
  return tVals.last;
}

class Point {
  final double x, y;
  Point(this.x, this.y);
}
