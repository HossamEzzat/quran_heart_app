import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/surah.dart';

class SurahRepository {
  static const String _storageKey = 'quran_heart_progress';

  // Complete list of 114 Surahs
  static final List<Map<String, dynamic>> _surahData = [
    {'number': 1, 'name': 'الفاتحة', 'english': 'Al-Fatiha'},
    {'number': 2, 'name': 'البقرة', 'english': 'Al-Baqarah'},
    {'number': 3, 'name': 'آل عمران', 'english': 'Ali Imran'},
    {'number': 4, 'name': 'النساء', 'english': 'An-Nisa'},
    {'number': 5, 'name': 'المائدة', 'english': 'Al-Maidah'},
    {'number': 6, 'name': 'الأنعام', 'english': 'Al-Anam'},
    {'number': 7, 'name': 'الأعراف', 'english': 'Al-Araf'},
    {'number': 8, 'name': 'الأنفال', 'english': 'Al-Anfal'},
    {'number': 9, 'name': 'التوبة', 'english': 'At-Tawbah'},
    {'number': 10, 'name': 'يونس', 'english': 'Yunus'},
    {'number': 11, 'name': 'هود', 'english': 'Hud'},
    {'number': 12, 'name': 'يوسف', 'english': 'Yusuf'},
    {'number': 13, 'name': 'الرعد', 'english': 'Ar-Rad'},
    {'number': 14, 'name': 'إبراهيم', 'english': 'Ibrahim'},
    {'number': 15, 'name': 'الحجر', 'english': 'Al-Hijr'},
    {'number': 16, 'name': 'النحل', 'english': 'An-Nahl'},
    {'number': 17, 'name': 'الإسراء', 'english': 'Al-Isra'},
    {'number': 18, 'name': 'الكهف', 'english': 'Al-Kahf'},
    {'number': 19, 'name': 'مريم', 'english': 'Maryam'},
    {'number': 20, 'name': 'طه', 'english': 'Taha'},
    {'number': 21, 'name': 'الأنبياء', 'english': 'Al-Anbiya'},
    {'number': 22, 'name': 'الحج', 'english': 'Al-Hajj'},
    {'number': 23, 'name': 'المؤمنون', 'english': 'Al-Muminun'},
    {'number': 24, 'name': 'النور', 'english': 'An-Nur'},
    {'number': 25, 'name': 'الفرقان', 'english': 'Al-Furqan'},
    {'number': 26, 'name': 'الشعراء', 'english': 'Ash-Shuara'},
    {'number': 27, 'name': 'النمل', 'english': 'An-Naml'},
    {'number': 28, 'name': 'القصص', 'english': 'Al-Qasas'},
    {'number': 29, 'name': 'العنكبوت', 'english': 'Al-Ankabut'},
    {'number': 30, 'name': 'الروم', 'english': 'Ar-Rum'},
    {'number': 31, 'name': 'لقمان', 'english': 'Luqman'},
    {'number': 32, 'name': 'السجدة', 'english': 'As-Sajdah'},
    {'number': 33, 'name': 'الأحزاب', 'english': 'Al-Ahzab'},
    {'number': 34, 'name': 'سبأ', 'english': 'Saba'},
    {'number': 35, 'name': 'فاطر', 'english': 'Fatir'},
    {'number': 36, 'name': 'يس', 'english': 'Ya-Sin'},
    {'number': 37, 'name': 'الصافات', 'english': 'As-Saffat'},
    {'number': 38, 'name': 'ص', 'english': 'Sad'},
    {'number': 39, 'name': 'الزمر', 'english': 'Az-Zumar'},
    {'number': 40, 'name': 'غافر', 'english': 'Ghafir'},
    {'number': 41, 'name': 'فصلت', 'english': 'Fussilat'},
    {'number': 42, 'name': 'الشورى', 'english': 'Ash-Shura'},
    {'number': 43, 'name': 'الزخرف', 'english': 'Az-Zukhruf'},
    {'number': 44, 'name': 'الدخان', 'english': 'Ad-Dukhan'},
    {'number': 45, 'name': 'الجاثية', 'english': 'Al-Jathiyah'},
    {'number': 46, 'name': 'الأحقاف', 'english': 'Al-Ahqaf'},
    {'number': 47, 'name': 'محمد', 'english': 'Muhammad'},
    {'number': 48, 'name': 'الفتح', 'english': 'Al-Fath'},
    {'number': 49, 'name': 'الحجرات', 'english': 'Al-Hujurat'},
    {'number': 50, 'name': 'ق', 'english': 'Qaf'},
    {'number': 51, 'name': 'الذاريات', 'english': 'Ad-Dhariyat'},
    {'number': 52, 'name': 'الطور', 'english': 'At-Tur'},
    {'number': 53, 'name': 'النجم', 'english': 'An-Najm'},
    {'number': 54, 'name': 'القمر', 'english': 'Al-Qamar'},
    {'number': 55, 'name': 'الرحمن', 'english': 'Ar-Rahman'},
    {'number': 56, 'name': 'الواقعة', 'english': 'Al-Waqiah'},
    {'number': 57, 'name': 'الحديد', 'english': 'Al-Hadid'},
    {'number': 58, 'name': 'المجادلة', 'english': 'Al-Mujadila'},
    {'number': 59, 'name': 'الحشر', 'english': 'Al-Hashr'},
    {'number': 60, 'name': 'الممتحنة', 'english': 'Al-Mumtahanah'},
    {'number': 61, 'name': 'الصف', 'english': 'As-Saff'},
    {'number': 62, 'name': 'الجمعة', 'english': 'Al-Jumuah'},
    {'number': 63, 'name': 'المنافقون', 'english': 'Al-Munafiqun'},
    {'number': 64, 'name': 'التغابن', 'english': 'At-Taghabun'},
    {'number': 65, 'name': 'الطلاق', 'english': 'At-Talaq'},
    {'number': 66, 'name': 'التحريم', 'english': 'At-Tahrim'},
    {'number': 67, 'name': 'الملك', 'english': 'Al-Mulk'},
    {'number': 68, 'name': 'القلم', 'english': 'Al-Qalam'},
    {'number': 69, 'name': 'الحاقة', 'english': 'Al-Haqqah'},
    {'number': 70, 'name': 'المعارج', 'english': 'Al-Maarij'},
    {'number': 71, 'name': 'نوح', 'english': 'Nuh'},
    {'number': 72, 'name': 'الجن', 'english': 'Al-Jinn'},
    {'number': 73, 'name': 'المزمل', 'english': 'Al-Muzzammil'},
    {'number': 74, 'name': 'المدثر', 'english': 'Al-Muddaththir'},
    {'number': 75, 'name': 'القيامة', 'english': 'Al-Qiyamah'},
    {'number': 76, 'name': 'الإنسان', 'english': 'Al-Insan'},
    {'number': 77, 'name': 'المرسلات', 'english': 'Al-Mursalat'},
    {'number': 78, 'name': 'النبأ', 'english': 'An-Naba'},
    {'number': 79, 'name': 'النازعات', 'english': 'An-Naziat'},
    {'number': 80, 'name': 'عبس', 'english': 'Abasa'},
    {'number': 81, 'name': 'التكوير', 'english': 'At-Takwir'},
    {'number': 82, 'name': 'الإنفطار', 'english': 'Al-Infitar'},
    {'number': 83, 'name': 'المطففين', 'english': 'Al-Mutaffifin'},
    {'number': 84, 'name': 'الإنشقاق', 'english': 'Al-Inshiqaq'},
    {'number': 85, 'name': 'البروج', 'english': 'Al-Buruj'},
    {'number': 86, 'name': 'الطارق', 'english': 'At-Tariq'},
    {'number': 87, 'name': 'الأعلى', 'english': 'Al-Ala'},
    {'number': 88, 'name': 'الغاشية', 'english': 'Al-Ghashiyah'},
    {'number': 89, 'name': 'الفجر', 'english': 'Al-Fajr'},
    {'number': 90, 'name': 'البلد', 'english': 'Al-Balad'},
    {'number': 91, 'name': 'الشمس', 'english': 'Ash-Shams'},
    {'number': 92, 'name': 'الليل', 'english': 'Al-Lail'},
    {'number': 93, 'name': 'الضحى', 'english': 'Ad-Duhaa'},
    {'number': 94, 'name': 'الشرح', 'english': 'Ash-Sharh'},
    {'number': 95, 'name': 'التين', 'english': 'At-Tin'},
    {'number': 96, 'name': 'العلق', 'english': 'Al-Alaq'},
    {'number': 97, 'name': 'القدر', 'english': 'Al-Qadr'},
    {'number': 98, 'name': 'البينة', 'english': 'Al-Bayyinah'},
    {'number': 99, 'name': 'الزلزلة', 'english': 'Az-Zalzalah'},
    {'number': 100, 'name': 'العاديات', 'english': 'Al-Adiyat'},
    {'number': 101, 'name': 'القارعة', 'english': 'Al-Qariah'},
    {'number': 102, 'name': 'التكاثر', 'english': 'At-Takathur'},
    {'number': 103, 'name': 'العصر', 'english': 'Al-Asr'},
    {'number': 104, 'name': 'الهمزة', 'english': 'Al-Humazah'},
    {'number': 105, 'name': 'الفيل', 'english': 'Al-Fil'},
    {'number': 106, 'name': 'قريش', 'english': 'Quraish'},
    {'number': 107, 'name': 'الماعون', 'english': 'Al-Maun'},
    {'number': 108, 'name': 'الكوثر', 'english': 'Al-Kawthar'},
    {'number': 109, 'name': 'الكافرون', 'english': 'Al-Kafirun'},
    {'number': 110, 'name': 'النصر', 'english': 'An-Nasr'},
    {'number': 111, 'name': 'المسد', 'english': 'Al-Masad'},
    {'number': 112, 'name': 'الإخلاص', 'english': 'Al-Ikhlas'},
    {'number': 113, 'name': 'الفلق', 'english': 'Al-Falaq'},
    {'number': 114, 'name': 'الناس', 'english': 'An-Nas'},
  ];

  Future<List<Surah>> getSurahs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedData = prefs.getString(_storageKey);
    Map<int, bool> memorizedMap = {};

    if (storedData != null) {
      try {
        final List<dynamic> decoded = jsonDecode(storedData);
        for (var item in decoded) {
          memorizedMap[item['number']] = item['isMemorized'];
        }
      } catch (e) {
        // Handle error or ignore corrupt data
      }
    }

    return _surahData.map((data) {
      return Surah(
        number: data['number'],
        name: data['name'],
        englishName: data['english'],
        isMemorized: memorizedMap[data['number']] ?? false,
      );
    }).toList();
  }

  Future<void> saveProgress(List<Surah> surahs) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> data = surahs
        .where((s) => s.isMemorized)
        .map((s) => s.toJson())
        .toList();
    await prefs.setString(_storageKey, jsonEncode(data));
  }
}
