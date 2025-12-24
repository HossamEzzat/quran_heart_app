import 'dart:math';

void main() {
  // Heart formula: (x^2 + y^2 - 1)^3 - x^2 * y^3 <= 0
  // Bounding box roughly x: [-1.5, 1.5], y: [-1.5, 1.5]

  double xMin = -1.5, xMax = 1.5;
  double yMin = -1.2, yMax = 1.4;

  List<Point> validPoints = [];

  // Hexagonal Packing Parameters
  // Horizontal spacing = r * sqrt(3)
  // Vertical spacing = r * 1.5 (or similar depending on orientation)
  // Let's just use simple alternating rows.

  // Tuning parameter: density.
  // We need ~114 points.
  // Area of heart is roughly... well, bounding box is 3x3=9. Heart is maybe 3-4?
  // 114 points. Density approx 30 points per unit area.
  // gap approx 0.15 to 0.18

  double gap = 0.16; // Trial and error to get close to 114

  bool oddRow = false;
  for (double y = yMax; y >= yMin; y -= (gap * 0.866)) {
    // 0.866 is sin(60)
    double rowOffset = oddRow ? (gap / 2) : 0;
    for (double x = xMin + rowOffset; x <= xMax; x += gap) {
      // Check Heart Formula
      double val = pow((x * x + y * y - 1), 3) - x * x * pow(y, 3);
      if (val <= 0) {
        validPoints.add(Point(x, y));
      }
    }
    oddRow = !oddRow;
  }

  print("// Generated ${validPoints.length} points.");

  // We need exactly 114.
  // Strategy:
  // 1. If > 114, sort by distance to center (0, 0.4??) and keep closest? No that shrinks the heart
  // 2. Randomly remove?
  // 3. Just trim the edges?

  // Optimizing gap to get close approx:
  // Let's try to just output what we have, and in the UI we handle the count.
  // Actually, for the mapping to work (Surah 1..114), we need 114 points.
  // If we have more, we can drop the ones "furthest from the heart boundary" (inner ones) or "closest to boundary"?
  // Let's drop random ones to maintain density? No, looks patchy.

  // Let's drop points that are "least stable"?
  // Simplest: Resize the list to 114 by taking evenly spaced indices if count > 114.

  List<Point> finalPoints = [];
  if (validPoints.length > 114) {
    // Downsample evenly
    double step = validPoints.length / 114;
    for (int i = 0; i < 114; i++) {
      finalPoints.add(validPoints[(i * step).floor()]);
    }
  } else if (validPoints.length < 114) {
    print("// ERROR: Not enough points. Decrease gap.");
    // Fallback: use all and duplicate last? No.
    finalPoints = validPoints;
  } else {
    finalPoints = validPoints;
  }

  print("import 'dart:ui';");
  print("const List<Offset> heartPositions = [");
  for (var p in finalPoints) {
    // Negate Y and output
    print("  Offset(${p.x.toStringAsFixed(3)}, ${(-p.y).toStringAsFixed(3)}),");
  }
  print("];");
}

class Point {
  final double x;
  final double y;
  Point(this.x, this.y);
}
