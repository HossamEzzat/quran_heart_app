class Surah {
  final int number;
  final String name; // Arabic name
  final String englishName;
  bool isMemorized;

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    this.isMemorized = false,
  });

  Map<String, dynamic> toJson() => {
    'number': number,
    'isMemorized': isMemorized,
  };

  factory Surah.fromJson(
    Map<String, dynamic> json,
    String name,
    String englishName,
  ) {
    return Surah(
      number: json['number'],
      name: name,
      englishName: englishName,
      isMemorized: json['isMemorized'] ?? false,
    );
  }
}
