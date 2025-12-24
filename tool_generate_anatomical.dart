import 'dart:math';
import 'dart:io';

void main() {
  // Skeleton + Volume Heart Generator V3
  List<Point> finalPoints = [];

  // 1. Define Arteries (Tubes) as paths
  // We place points explicitly along these curves to ensure they look like tubes.
  // Vena Cava (Top Left)
  finalPoints.addAll(
    generatePath(
      start: Point(-0.4, 0.8),
      end: Point(-0.6, 1.3),
      count: 6,
      width: 0.15,
    ),
  );

  // Aorta (Top Center/Right) - Arching
  finalPoints.addAll(
    generatePath(
      start: Point(0.0, 0.9),
      end: Point(0.1, 1.4),
      count: 6,
      width: 0.15,
    ),
  );

  // Pulmonary Artery (Top Right)
  finalPoints.addAll(
    generatePath(
      start: Point(0.5, 0.7),
      end: Point(1.0, 1.0),
      count: 6,
      width: 0.15,
    ),
  );

  // 2. Define Main Body (Volume)
  // We use a dense hex packing but strictly constrained to the ventricle shapes.
  List<Point> bodyPoints = [];
  double gap = 0.13;

  // Bounding box for body
  for (double y = 0.9; y >= -1.5; y -= (gap * 0.866)) {
    bool oddRow = ((y / (gap * 0.866)).round() % 2 == 0);
    double rowOffset = oddRow ? (gap / 2) : 0;
    for (double x = -1.2; x <= 1.2; x += gap) {
      double px = x + rowOffset;
      if (isInsideBody(px, y)) {
        // Avoid overlap with existing artery points
        if (!isTooClose(Point(px, y), finalPoints, 0.1)) {
          bodyPoints.add(Point(px, y));
        }
      }
    }
  }

  // 3. Merge
  finalPoints.addAll(bodyPoints);

  print("// Generated ${finalPoints.length} points.");

  // 4. Sort roughly by Y to maintain order (Top to Bottom)
  // Actually, anatomy numbers often go spiraling or specific ways, but Y-sort is a decent heuristic for "filling".
  // Let's sort top-down.
  finalPoints.sort((a, b) => b.y.compareTo(a.y));

  // 5. Truncate/Select to 114
  List<Point> exportPoints = [];
  if (finalPoints.length > 114) {
    // Pick evenly to preserve shape density
    double step = finalPoints.length / 114;
    for (int i = 0; i < 114; i++) {
      exportPoints.add(finalPoints[(i * step).floor()]);
    }
  } else {
    exportPoints = finalPoints;
  }

  print("import 'dart:ui';");
  print("const List<Offset> heartPositions = [");
  for (var p in exportPoints) {
    print("  Offset(${p.x.toStringAsFixed(3)}, ${(-p.y).toStringAsFixed(3)}),");
  }
  print("];");
}

List<Point> generatePath({
  required Point start,
  required Point end,
  required int count,
  required double width,
}) {
  List<Point> path = [];
  for (int i = 0; i < count; i++) {
    double t = i / (count - 1);
    double x = start.x + (end.x - start.x) * t;
    double y = start.y + (end.y - start.y) * t;
    // Add jitter width
    // Actually, for a "tube", we might want 2 columns? Let's just do single thick column for now, or zigzag.
    path.add(Point(x, y));
    // Add a neighbor to make it thicker?
    if (width > 0) {
      path.add(Point(x + 0.1, y)); // Simple thickening
    }
  }
  return path;
}

bool isInsideBody(double x, double y) {
  // Main Vestricle (Tilted Oval)
  if (isPointInEllipse(
    x,
    y,
    cx: -0.1,
    cy: -0.4,
    rx: 0.8,
    ry: 0.9,
    angle: -10,
  )) {
    return true;
  }

  // Left Atrium (Bulge Left)
  if (isPointInEllipse(x, y, cx: -0.7, cy: 0.3, rx: 0.4, ry: 0.4, angle: 0)) {
    return true;
  }

  // Right Atrium (Bulge Right)
  if (isPointInEllipse(x, y, cx: 0.6, cy: 0.2, rx: 0.45, ry: 0.5, angle: 20)) {
    return true;
  }

  // Apex sharp tip
  if (isPointInEllipse(x, y, cx: 0.15, cy: -1.2, rx: 0.35, ry: 0.5, angle: 0)) {
    return true;
  }

  return false;
}

bool isTooClose(Point p, List<Point> others, double minDist) {
  for (var o in others) {
    if (pow(p.x - o.x, 2) + pow(p.y - o.y, 2) < pow(minDist, 2)) return true;
  }
  return false;
}

bool isPointInEllipse(
  double x,
  double y, {
  required double cx,
  required double cy,
  required double rx,
  required double ry,
  required double angle,
}) {
  double rad = angle * pi / 180;
  double dx = x - cx;
  double dy = y - cy;
  double rotX = dx * cos(rad) - dy * sin(rad);
  double rotY = dx * sin(rad) + dy * cos(rad);

  return (pow(rotX / rx, 2) + pow(rotY / ry, 2)) <= 1.0;
}

class Point {
  final double x;
  final double y;
  Point(this.x, this.y);
}
