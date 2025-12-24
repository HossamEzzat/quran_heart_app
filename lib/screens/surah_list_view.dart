import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/quran_provider.dart';

class SurahListView extends StatelessWidget {
  const SurahListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuranProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          itemCount: provider.surahs.length,
          itemBuilder: (context, index) {
            final surah = provider.surahs[index];
            final isMemorized = surah.isMemorized;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isMemorized
                    ? const Color(0xFFD4AF37).withOpacity(0.1) // Gold tint
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isMemorized ? const Color(0xFFD4AF37) : Colors.white10,
                  width: 1,
                ),
              ),
              child: ListTile(
                onTap: () {
                  provider.toggleSurah(surah.number);
                },
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isMemorized
                        ? const Color(0xFFD4AF37)
                        : Colors.transparent,
                    border: Border.all(color: const Color(0xFFD4AF37)),
                  ),
                  child: Center(
                    child: Text(
                      surah.number.toString(),
                      style: GoogleFonts.cairo(
                        color: isMemorized
                            ? Colors.black
                            : const Color(0xFFD4AF37),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  surah.name,
                  style: GoogleFonts.amiri(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                trailing: Icon(
                  isMemorized ? Icons.check_circle : Icons.circle_outlined,
                  color: isMemorized ? const Color(0xFFD4AF37) : Colors.white24,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
