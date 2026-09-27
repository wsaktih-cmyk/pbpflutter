import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// ============================================================================
/// KONSEP PBO: Abstraction & Interface Contract untuk Item Portofolio
/// Menjamin setiap item portofolio memiliki struktur modular dan terstandarisasi.
/// ============================================================================

enum PortfolioCategory {
  all('Semua Koleksi', Icons.dashboard_rounded),
  pbo('Tugas Matkul PBO', Icons.account_tree_rounded),
  mobile('Aplikasi Mobile', Icons.phone_android_rounded),
  web('Web & Backend', Icons.language_rounded);

  final String label;
  final IconData icon;
  const PortfolioCategory(this.label, this.icon);
}

/// Interface untuk item yang dapat diuji coba secara interaktif
abstract class InteractiveDemonstrable {
  String runInteractiveDemonstration();
}

/// Kelas Abstrak Induk (Blueprint Item Portofolio)
abstract class PortfolioItem {
  final String id;
  final String title;
  final String shortDescription;
  final String detailedDescription;
  final PortfolioCategory category;
  final List<String> techStack;
  final String dateCreated;
  final bool isFeatured;

  // Enkapsulasi: State interaktif yang dimutasi via method & setter
  int _viewsCount;
  int _likesCount;
  double _rating;
  bool _isBookmarked;

  PortfolioItem({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.detailedDescription,
    required this.category,
    required this.techStack,
    required this.dateCreated,
    this.isFeatured = false,
    int viewsCount = 120,
    int likesCount = 28,
    double rating = 4.85,
    bool isBookmarked = false,
  })  : _viewsCount = viewsCount,
        _likesCount = likesCount,
        _rating = rating,
        _isBookmarked = isBookmarked;

  // --- GETTER PUBLIK ---
  int get viewsCount => _viewsCount;
  int get likesCount => _likesCount;
  double get rating => _rating;
  bool get isBookmarked => _isBookmarked;
  String get ratingFormatted => _rating.toStringAsFixed(1);

  // --- SETTER DENGAN VALIDASI ENKAPSULASI ---
  set rating(double value) {
    if (value < 0.0 || value > 5.0) {
      throw ArgumentError('Rating proyek harus bernilai antara 0.0 hingga 5.0 (Masukan: $value)');
    }
    _rating = value;
  }

  set viewsCount(int value) {
    if (value < 0) {
      throw ArgumentError('Jumlah views tidak boleh negatif.');
    }
    _viewsCount = value;
  }

  // --- FUNCTION / METHOD OPERASIONAL OBJEK ---
  void addLike() {
    _likesCount++;
  }

  void incrementViews() {
    _viewsCount++;
  }

  void toggleBookmark() {
    _isBookmarked = !_isBookmarked;
  }

  // Polimorfisme: Setiap kategori memiliki badge, aksen warna, dan metrik berbeda
  Color getCategoryColor();
  String getCategoryBadge();
  IconData getItemIcon();
  Map<String, String> getMetadataAttributes();
}

/// ============================================================================
/// SUBCLASS PBO: Tugas & Proyek Matkul Pemrograman Berorientasi Objek
/// Menghubungkan secara nyata materi kuliah PBO ke dalam arsitektur aplikasi
/// ============================================================================
class PboCourseworkItem extends PortfolioItem implements InteractiveDemonstrable {
  final String courseSemester; // Contoh: 'Semester 4 - PBO Kelas D'
  final List<String> pboPrinciplesUsed; // e.g., 'Inheritance', 'Polymorphism', 'Encapsulation'
  final String classHierarchyDescription;
  final String sourceCodeSample;
  final String simulatedExecutionLog;

  PboCourseworkItem({
    required super.id,
    required super.title,
    required super.shortDescription,
    required super.detailedDescription,
    required super.techStack,
    required super.dateCreated,
    required this.courseSemester,
    required this.pboPrinciplesUsed,
    required this.classHierarchyDescription,
    required this.sourceCodeSample,
    required this.simulatedExecutionLog,
    super.category = PortfolioCategory.pbo,
    super.isFeatured = true,
  });

  @override
  Color getCategoryColor() => AppColors.primaryLight;

  @override
  String getCategoryBadge() => 'MATKUL PBO • $courseSemester';

  @override
  IconData getItemIcon() => Icons.data_object_rounded;

  @override
  Map<String, String> getMetadataAttributes() => {
        'Mata Kuliah': 'Pemrograman Berorientasi Objek',
        'Pilar Digunakan': pboPrinciplesUsed.join(', '),
        'Hirarki Kelas': classHierarchyDescription,
        'Status Verifikasi': '✅ Lulus Evaluasi & Terkompilasi',
      };

  @override
  String runInteractiveDemonstration() {
    return '''
[PBO RUNTIME ENGINE]
- Menginstansiasi Objek Hirarki...
- Prinsip Aktif: ${pboPrinciplesUsed.join(' + ')}
$simulatedExecutionLog
- Status: Objek dialokasikan ke memori secara dinamis tanpa kebocoran.
''';
  }
}

/// ============================================================================
/// SUBCLASS: Proyek Aplikasi Software / Mobile
/// ============================================================================
class SoftwareAppItem extends PortfolioItem {
  final String platform;
  final String repoUrl;
  final String demoUrl;
  final int totalStars;

  SoftwareAppItem({
    required super.id,
    required super.title,
    required super.shortDescription,
    required super.detailedDescription,
    required super.category,
    required super.techStack,
    required super.dateCreated,
    required this.platform,
    this.repoUrl = 'https://github.com/developer/portfolio',
    this.demoUrl = 'https://demo.portfolio.dev',
    this.totalStars = 48,
    super.isFeatured = false,
  });

  @override
  Color getCategoryColor() => AppColors.secondaryLight;

  @override
  String getCategoryBadge() => 'PROYEK $platform';

  @override
  IconData getItemIcon() =>
      category == PortfolioCategory.mobile ? Icons.smartphone_rounded : Icons.code_rounded;

  @override
  Map<String, String> getMetadataAttributes() => {
        'Platform': platform,
        'Apresiasi': '⭐ $totalStars Stars',
        'Versi Rilis': 'v2.1.0-stable',
        'Arsitektur': 'Clean Architecture & BLoC/Provider',
      };
}
