class Phrase {
  final String id;
  final String chinese;
  final String pinyin;
  final String translation;
  final String categoryId;
  final String? audioAssetPath; // For future real audio files
  
  const Phrase({
    required this.id,
    required this.chinese,
    required this.pinyin,
    required this.translation,
    required this.categoryId,
    this.audioAssetPath,
  });
}

class Category {
  final String id;
  final String name;
  final String icon; // Using emoji for simplicity/lightweight
  final String description;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });
}
