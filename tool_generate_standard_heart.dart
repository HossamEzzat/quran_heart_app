import 'dart:math';
import 'dart:io';

void main() {
  // Generator to match the Standard Heart Outline Image
  // We will fill the shape
  // Formula: (x^2 + y^2 - 1)^3 - x^2*y^3 <= 0

  List<Point> candidates = [];
  // Use a slightly larger step for rough count, or dense + decimate
  double step = 0.05;

  for (double y = 1.3; y >= -1.2; y -= step) {
    for (double x = -1.3; x <= 1.3; x += step) {
      double xx = x * 1.0;
      double yy = y * 1.0; // Math coordinates
      double val = pow((xx * xx + yy * yy - 1), 3) - xx * xx * pow(yy, 3);

      // Inner margin to not touch the border too much
      if (val <= -0.05) {
        candidates.add(Point(x, y));
      }
    }
  }

  // Sort top-down
  candidates.sort((a, b) => b.y.compareTo(a.y));

  List<Point> finalPoints = [];
  if (candidates.length > 114) {
    double s = candidates.length / 114;
    for (int i = 0; i < 114; i++) {
      finalPoints.add(candidates[(i * s).floor()]);
    }
  } else {
    finalPoints = candidates;
  }

  print("import 'dart:ui';");
  print("const List<Offset> heartPositions = [");
  for (var p in finalPoints) {
    // Math Y up -> Screen Y down
    // The image has a standard aspect ratio.
    print("  Offset(${p.x.toStringAsFixed(3)}, ${(-p.y).toStringAsFixed(3)}),");
  }
  print("];");
}

class Point {
  final double x;
  final double y;
  Point(this.x, this.y);
}
