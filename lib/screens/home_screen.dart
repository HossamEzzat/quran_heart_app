import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'surah_list_view.dart';
import 'heart_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Arabic Numbers converter if needed, or use Locale
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "قلب القرآن",
            style: GoogleFonts.amiri(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFD4AF37), // Gold
            ),
          ),
          bottom: TabBar(
            indicatorColor: const Color(0xFFD4AF37),
            labelColor: const Color(0xFFD4AF37),
            unselectedLabelColor: Colors.white60,
            labelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(icon: Icon(Icons.favorite), text: "القلب"), // The Heart
              Tab(icon: Icon(Icons.grid_view), text: "السور"), // The Surahs
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              colors: [
                Color(0xFF1F3A4D), // Lighter Navy
                Color(0xFF0F1E2C), // Darker Navy
              ],
            ),
          ),
          child: const TabBarView(children: [HeartView(), SurahListView()]),
        ),
      ),
    );
  }
}
