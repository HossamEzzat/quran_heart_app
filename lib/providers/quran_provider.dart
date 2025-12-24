import 'package:flutter/material.dart';
import '../models/surah.dart';
import '../data/surah_repository.dart';

class QuranProvider with ChangeNotifier {
  final SurahRepository _repository = SurahRepository();
  List<Surah> _surahs = [];
  bool _isLoading = true;

  List<Surah> get surahs => _surahs;
  bool get isLoading => _isLoading;

  int get memorizedCount => _surahs.where((s) => s.isMemorized).length;

  QuranProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();
    _surahs = await _repository.getSurahs();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleSurah(int number) async {
    final index = _surahs.indexWhere((s) => s.number == number);
    if (index != -1) {
      _surahs[index].isMemorized = !_surahs[index].isMemorized;
      notifyListeners();
      await _repository.saveProgress(_surahs);
    }
  }
}
