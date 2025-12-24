import 'dart:math';
import 'dart:io';

void main() {
  // Standard Parametric Heart Curve (Cardioid-like)
  // x = 16sin^3(t)
  // y = 13cos(t) - 5cos(2t) - 2cos(3t) - cos(4t)

  List<Point> validPoints = [];
  double gap = 0.5; // Tuning for filling

  // To fill it, we can just scan a grid and check inside polygon?
  // Or just generate the boundary and fill?
  // Let's use rejection sampling against the formula boundary.

  // Boundary function:
  // Not easy to test "inside" parametric curve analytically without polygonality.
  // Alternative: Implicit formula: (x^2 + y^2 - 1)^3 - x^2*y^3 <= 0.
  // This is the classic heart.

  double xMin = -1.5, xMax = 1.5;
  double yMin = -1.5, yMax = 1.5;
  double step = 0.12; // Tuned for ~114

  bool oddRow = false;
  for (double y = yMax; y >= yMin; y -= (step * 0.866)) {
    double rowOffset = oddRow ? (step / 2) : 0;
    for (double x = xMin + rowOffset; x <= xMax; x += step) {
      // Heart Formula
      // Scale x a bit to make it wider/nicer
      double xx = x * 1.0;
      double yy = y * 1.0;
      double val = pow((xx * xx + yy * yy - 1), 3) - xx * xx * pow(yy, 3);
      if (val <= 0) {
        validPoints.add(Point(x, y));
      }
    }
    oddRow = !oddRow;
  }

  print("// Classic Heart: Generated ${validPoints.length} points.");

  // Sort Top-Down (Y decreasing)
  validPoints.sort((a, b) => b.y.compareTo(a.y)); // Higher Y first

  // Select 114
  List<Point> finalPoints = [];
  if (validPoints.length > 114) {
    // Even sampling
    double s = validPoints.length / 114;
    for (int i = 0; i < 114; i++) {
      finalPoints.add(validPoints[(i * s).floor()]);
    }
  } else {
    finalPoints = validPoints;
  }

  print("import 'dart:ui';");
  print("const List<Offset> heartPositions = [");
  for (var p in finalPoints) {
    // Math Y is up, Screen Y is down.
    // In math heart, peaks are at y > 0.
    // We want peaks at top. So we negate Y.
    print("  Offset(${p.x.toStringAsFixed(3)}, ${(-p.y).toStringAsFixed(3)}),");
  }
  print("];");
}

class Point {
  final double x;
  final double y;
  Point(this.x, this.y);
}
