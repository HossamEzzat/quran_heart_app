import 'dart:math';
import 'dart:io';

void main() {
  // Structured Heart Generator using Phyllotaxis (Sunflower Pattern)
  // This creates a perfectly even, non-random distribution.

  List<Point> points = [];
  int n = 114;
  double c = 0.08; // Scaling factor

  // We generate points using the Golden Angle, then map them to a Heart Shape.
  // Standard disk phyllotaxis: r = c * sqrt(i), theta = i * 137.5 deg

  for (int i = 0; i < n; i++) {
    // 1. Generate point on a disk
    double r = c * sqrt(i + 1); // +1 to avoid 0
    double theta = i * 2.39996; // Golden angle in radians

    // 2. Map Disk (u, v) to Heart (x, y)
    // Disk coordinates
    double u = r * cos(theta);
    double v = r * sin(theta);

    // Apply Heart Distortion to the disk points
    // A simple way is to treat 'u' as x, and modify 'v' based on 'u' to pinch the bottom and hump the top.

    // Let's use a rejection method on a deterministic spiral?
    // No, mapping is cleaner.

    // Let's try filling a defined Heart Shape with a Grid or Spiral deterministically.

    // Rejection Sampling on a dense Spiral is best for "even" feel.
    // Let's generate 500 spiral points and keep the ones inside the heart equation.
  }

  points = [];
  int count = 0;
  int i = 0;

  // Heart Formula: (x^2 + y^2 - 1)^3 - x^2 * y^3 = 0
  // Bounds approx -1.5 to +1.5

  while (points.length < 114) {
    // Spiral grow
    double r = 0.06 * sqrt(i);
    double theta = i * 2.39996;

    double x = r * cos(theta);
    double y = r * sin(theta);

    // Adjust y to make the spread heart-like BEFORE testing bounds?
    // Let's just test bounds on the raw spiral.
    // The spiral is circular. A heart is not.
    // We need to squish the "circle" of the spiral into a "heart".

    // Heart Polar Equation approx: r = 2 - 2sin(t) + sin(t)(sqrt(|cos(t)|)/(sin(t)+1.4))
    // Too complex.

    // Simple Squish:
    // y' = y + |x|*0.5  -> transforms circle to heart-ish
    double y_heart = y + x.abs() * 0.7; // shift down upper lobes
    // Actually let's just use the inside-test on a higher density grid.

    i++;
  }

  // Let's try Grid approach for perfect order.
  // Or just optimize the "Inside" Points.

  List<Point> allPoints = [];
  // Generate a dense hexagonal grid
  double hStep = 0.12;
  for (double y = 1.3; y >= -1.3; y -= hStep * 0.866) {
    // hex height
    for (double x = -1.5; x <= 1.5; x += hStep) {
      // Offset every other row
      double xx = x;
      if ((y / (hStep * 0.866)).round() % 2 != 0) xx += hStep / 2;

      // Check Heart
      if (isInsideHeart(xx, y)) {
        allPoints.add(Point(xx, y));
      }
    }
  }

  // Sort by distance from center or top-down?
  // Sorting top-down makes it readable.
  allPoints.sort((a, b) => b.y.compareTo(a.y));

  // Pick exactly 114 from the center outwards? Or just decimate?
  // If we have too many, pick the center 114.
  // Using 'Center' heuristic: distance to (0, 0.5) (approx center of heart lobes)

  if (allPoints.length > 114) {
    // Sort by distance to "Visual Center" of heart
    // Heart visual center is approx (0, 0.2)
    allPoints.sort((a, b) {
      double da = dist(a.x, a.y, 0, 0.3);
      double db = dist(b.x, b.y, 0, 0.3);
      return da.compareTo(db);
    });
    // Take closest 114
    points = allPoints.sublist(0, 114);

    // Re-sort Top-Down for index assignment logic (Surah 1 at top)
    points.sort((a, b) => b.y.compareTo(a.y));
  } else {
    print(
      "Error: Grid too sparse, only found ${allPoints.length}. Decrease step size.",
    );
    points = allPoints;
    return;
  }

  print("import 'dart:ui';");
  print("// Structured Hex-Grid Heart");
  print("const List<Offset> heartPositions = [");
  for (var p in points) {
    // Negate Y for screen
    print("  Offset(${p.x.toStringAsFixed(3)}, ${(-p.y).toStringAsFixed(3)}),");
  }
  print("];");
}

bool isInsideHeart(double x, double y) {
  // Reverting squeeze.
  // Standard Heart: (x^2 + y^2 - 1)^3 - x^2*y^3 <= 0
  // To make it less triangle-like and more round, we typically want to EMPHASIZE the y^3 term effect or widen x.

  double xx = x;
  double yy = y;

  // Let's try the Dot's Heart Equation variation for fuller lobes:
  // x^2 + (y - x^(2/3))^2 = 1 ?? No that's the 2D plot.

  // Let's stick to the implicit but maybe stretch Y a bit to make it taller?
  // Or actually squish Y to make it wider/rounder?
  // If it looks like a triangle, it's too pointy at bottom and flat at top.
  // Let's try modifying the input coordinates to 'squish' the theoretical processing space,
  // which results in a 'stretched' output shape.

  // checking: (x^2 + y^2 - 1)^3 - x^2*y^3 <= 0
  double v = pow((xx * xx + yy * yy - 1), 3) - (xx * xx * pow(yy, 3));
  return v <= 0;
}

double dist(double x1, double y1, double x2, double y2) {
  return sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2));
}

class Point {
  final double x, y;
  Point(this.x, this.y);
}
