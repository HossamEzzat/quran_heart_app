import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../providers/quran_provider.dart';
import '../data/heart_data.dart';
import '../models/surah.dart';
import 'islamic_painter.dart';

class HeartView extends StatefulWidget {
  const HeartView({super.key});

  @override
  State<HeartView> createState() => _HeartViewState();
}

class _HeartViewState extends State<HeartView> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  // Removed ParticleController (Static BG)

  // Victory Animation
  late AnimationController _victoryController;
  bool _showVictory = false;

  final List<VictoryParticle> _victoryParticles = [];

  // Performance: Pre-calculated connections
  List<List<int>> _meshConnections = [];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _victoryController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 1500),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            setState(() {
              _showVictory = false;
              _victoryParticles.clear();
            });
          }
        });

    _preCalculateMesh();
  }

  void _preCalculateMesh() {
    _meshConnections = [];
    // Convert normalized points to screen space for distance check
    // We can just check normalized distance.
    // Screen scale ~135. Threshold ~40.
    // Normalized Threshold ~ 40/135 = 0.29
    const double threshold = 0.29;

    for (int i = 0; i < heartPositions.length; i++) {
      _meshConnections.add([]);
      for (int j = i + 1; j < heartPositions.length; j++) {
        final double dist = (heartPositions[i] - heartPositions[j]).distance;
        if (dist < threshold) {
          _meshConnections[i].add(j);
        }
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _victoryController.dispose();
    super.dispose();
  }

  void _triggerVictory() {
    setState(() {
      _showVictory = true;
      _victoryParticles.clear();
      for (int i = 0; i < 40; i++) {
        _victoryParticles.add(VictoryParticle());
      }
    });
    _victoryController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    // Cache the static heart layout to avoid rebuilding 114 widgets every pulse frame
    final heartLayout = Consumer<QuranProvider>(
      builder: (context, provider, child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Mesh Layer - Optimized
            RepaintBoundary(
              child: CustomPaint(
                size: const Size(400, 480),
                painter: HeartMeshPainter(
                  points: heartPositions,
                  surahs: provider.surahs,
                  connections: _meshConnections,
                ),
              ),
            ),

            // Nodes Layer
            ...List.generate(provider.surahs.length, (index) {
              if (index >= heartPositions.length) return const SizedBox();

              final surah = provider.surahs[index];
              final offset = heartPositions[index];
              final isMemorized = surah.isMemorized;

              final double x = (offset.dx * 240) + 200;
              final double y = (offset.dy * 240) + 240;

              return Positioned(
                left: x - 10, // Center the 20px bubble
                top: y - 10,
                child: GestureDetector(
                  onTap: () => _showSurahInfo(context, surah, provider),
                  child: _buildSurahBubble(surah, isMemorized),
                ),
              );
            }),
          ],
        );
      },
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 0. Static Islamic Background
          Positioned.fill(
            child: RepaintBoundary(
              // Paint once
              child: CustomPaint(painter: IslamicPatternPainter()),
            ),
          ),

          // 1. Interactive Heart
          InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            boundaryMargin: const EdgeInsets.all(200),
            child: Center(
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: SizedBox(width: 400, height: 480, child: child),
                  );
                },
                child: heartLayout,
              ),
            ),
          ),

          // 2. Victory Celebration Layer
          if (_showVictory)
            IgnorePointer(
              child: AnimatedBuilder(
                animation: _victoryController,
                builder: (context, child) {
                  return CustomPaint(
                    size: MediaQuery.of(context).size,
                    painter: VictoryPainter(
                      _victoryParticles,
                      _victoryController.value,
                    ),
                  );
                },
              ),
            ),

          // 3. Progress Floating Card
          _buildProgressCard(),
        ],
      ),
    );
  }

  Widget _buildSurahBubble(Surah surah, bool isMemorized) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isMemorized
            ? const Color(0xFFD4AF37)
            : const Color(0xFFFFFFFF).withOpacity(0.1), // Fixed opacity use
        gradient: isMemorized
            ? const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFC5A028)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        border: Border.all(
          color: isMemorized ? Colors.white70 : Colors.white30,
          width: isMemorized ? 1.5 : 1.0,
        ),
        boxShadow: isMemorized
            ? [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withOpacity(0.5),
                  blurRadius: 8, // Reduced blur radius for performance
                  spreadRadius: 1,
                ),
              ]
            : null, // No shadow for unmemorized
      ),
      child: Center(
        child: Text(
          "${surah.number}",
          style: GoogleFonts.cairo(
            fontSize: 8.5,
            fontWeight: FontWeight.w900,
            height: 1.0,
            color: isMemorized ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Consumer<QuranProvider>(
      builder: (context, provider, child) {
        int memorizedCount = provider.surahs.where((s) => s.isMemorized).length;
        return Positioned(
          top: 40,
          left: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFD4AF37), width: 1),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withOpacity(0.2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.verified, color: Color(0xFFD4AF37), size: 20),
                const SizedBox(width: 8),
                Text(
                  "$memorizedCount / 114",
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "تم الحفظ",
                  style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSurahInfo(
    BuildContext context,
    Surah surah,
    QuranProvider provider,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F1E2C),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "سورة ${surah.name}",
              style: GoogleFonts.amiri(
                fontSize: 40,
                color: const Color(0xFFD4AF37),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "رقم السورة: ${surah.number}",
              style: GoogleFonts.cairo(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (!surah.isMemorized) {
                    _triggerVictory(); // CELEBRATE!
                  }
                  provider.toggleSurah(surah.number);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  surah.isMemorized ? "إلغاء الحفظ" : "إتمام الحفظ",
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Painters ---

class HeartMeshPainter extends CustomPainter {
  final List<Offset> points;
  final List<Surah> surahs;
  final List<List<int>> connections; // Optimization

  HeartMeshPainter({
    required this.points,
    required this.surahs,
    required this.connections,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Optimization: Reuse paints
    final Paint normalPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 0.5;

    final Paint goldPaint = Paint()
      ..color = const Color(0xFFD4AF37).withOpacity(0.4)
      ..strokeWidth = 1.5;

    // Convert Points to Screen Space ONCE
    // Actually we can just do (offset * scale) + center inline
    // But caching screen points might be faster?
    // Let's keep inline for memory efficiency, logic is cheap.

    for (int i = 0; i < connections.length && i < surahs.length; i++) {
      final p1 = points[i];
      final double x1 = (p1.dx * 240) + 200;
      final double y1 = (p1.dy * 240) + 240;

      for (int j in connections[i]) {
        if (j >= surahs.length) continue;

        final p2 = points[j];
        final double x2 = (p2.dx * 240) + 200;
        final double y2 = (p2.dy * 240) + 240;

        if (surahs[i].isMemorized && surahs[j].isMemorized) {
          canvas.drawLine(Offset(x1, y1), Offset(x2, y2), goldPaint);
        } else {
          canvas.drawLine(Offset(x1, y1), Offset(x2, y2), normalPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant HeartMeshPainter oldDelegate) {
    // Only repaint if memorization state changes significantly?
    // Actually Consumer handles rebuilds of this painter.
    return true;
  }
}

// Celebration Particles
class VictoryParticle {
  double x = 0.5; // Start center
  double y = 0.5;
  double angle = math.Random().nextDouble() * 2 * math.pi;
  double speed = math.Random().nextDouble() * 0.5 + 0.2;
  Color color = const Color(0xFFD4AF37);
}

class VictoryPainter extends CustomPainter {
  final List<VictoryParticle> particles;
  final double progress;
  final Paint _paint = Paint()..style = PaintingStyle.fill;

  VictoryPainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      double dist = p.speed * progress;
      double dx = 0.5 + math.cos(p.angle) * dist;
      double dy = 0.5 + math.sin(p.angle) * dist;

      _paint.color = p.color.withOpacity((1.0 - progress).clamp(0.0, 1.0));
      canvas.drawCircle(Offset(dx * size.width, dy * size.height), 3.0, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
