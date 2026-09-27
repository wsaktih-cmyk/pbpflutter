import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

/// Model untuk Snippet Kode Implementasi PBO
class PboCodeSnippet {
  final String title;
  final String category;
  final String filePath;
  final IconData icon;
  final Color accentColor;
  final String conceptSummary;
  final String code;
  final List<String> keyPoints;

  const PboCodeSnippet({
    required this.title,
    required this.category,
    required this.filePath,
    required this.icon,
    required this.accentColor,
    required this.conceptSummary,
    required this.code,
    required this.keyPoints,
  });
}

/// Komponen Showcase Kode Sumber Implementasi PBO (Setter, Getter, Enkapsulasi, Functions)
/// Ditampilkan langsung di halaman web agar penilai/dosen dapat mengaudit kode asli.
class PboCodeShowcase extends StatefulWidget {
  const PboCodeShowcase({super.key});

  @override
  State<PboCodeShowcase> createState() => _PboCodeShowcaseState();
}

class _PboCodeShowcaseState extends State<PboCodeShowcase> {
  int _selectedIndex = 0;
  bool _isCopied = false;

  final List<PboCodeSnippet> _snippets = const [
    // 1. SETTER (VALIDASI ATURAN BISNIS & EXCEPTION)
    PboCodeSnippet(
      title: 'Setter Tervalidasi',
      category: 'Mutasi Terenkapsulasi',
      filePath: 'lib/models/student_model.dart',
      icon: Icons.tune_rounded,
      accentColor: AppColors.accentRose,
      conceptSummary:
          'Setter bertindak sebagai penjaga gerbang (gatekeeper) integritas data. '
          'Atribut privat tidak boleh diubah sembarangan tanpa melewati validasi aturan bisnis. '
          'Jika parameter melanggar batas (misal: IPK < 0.0 atau > 4.0), setter langsung melempar ArgumentError.',
      keyPoints: [
        'Enkapsulasi ketat: Mutasi atribut privat wajib melalui setter',
        'Validasi batas IPK 0.0 - 4.0 & Semester 1 - 14',
        'Exception handling: Melempar ArgumentError saat terjadi pelanggaran aturan',
        'Audit timestamp: Memperbarui _terakhirDiperbarui secara otomatis',
      ],
      code: '''// ===========================================================================
// PBO: SETTER TERVALIDASI DENGAN EXCEPTION HANDLING
// File: lib/models/student_model.dart
// ===========================================================================

/// Setter IPK dengan validasi ketat rentang 0.00 s/d 4.00
set ipk(double value) {
  if (value < 0.0 || value > 4.0) {
    throw ArgumentError(
      'Validasi Enkapsulasi Gagal: Nilai IPK harus berada dalam rentang 0.00 hingga 4.00 (Input: \$value)',
    );
  }
  _ipk = value;
  _terakhirDiperbarui = DateTime.now();
}

/// Setter Semester dengan batas wajar perkuliahan (Semester 1 s/d 14)
set semester(int value) {
  if (value < 1 || value > 14) {
    throw ArgumentError(
      'Validasi Enkapsulasi Gagal: Semester harus berada antara 1 hingga 14 (Input: \$value)',
    );
  }
  _semester = value;
  _terakhirDiperbarui = DateTime.now();
}

/// Setter Nama dengan pembersihan whitespace & verifikasi minimal 3 karakter
set nama(String value) {
  final sanitized = value.trim();
  if (sanitized.isEmpty) {
    throw ArgumentError('Validasi Enkapsulasi Gagal: Nama tidak boleh kosong.');
  }
  if (sanitized.length < 3) {
    throw ArgumentError('Validasi Enkapsulasi Gagal: Nama minimal 3 karakter.');
  }
  _nama = sanitized;
  _terakhirDiperbarui = DateTime.now();
}''',
    ),

    // 2. GETTER (READ-ONLY & COMPUTED PROPERTIES)
    PboCodeSnippet(
      title: 'Getter (Computed)',
      category: 'Akses Baca Terkontrol',
      filePath: 'lib/models/student_model.dart',
      icon: Icons.output_rounded,
      accentColor: AppColors.secondary,
      conceptSummary:
          'Getter menyediakan akses baca terkontrol ke atribut privat tanpa mengekspos mutasi langsung. '
          'Getter juga digunakan untuk menghitung nilai dinamis (computed property) seperti format 2 desimal, '
          'predikat kelulusan akademik (Cum Laude), dan sisa SKS kelulusan.',
      keyPoints: [
        'Read-only access: Mencegah perubahan data dari luar kelas',
        'Computed Property: Menghitung predikat kelulusan berdasarkan nilai IPK',
        'List.unmodifiable: Menjaga integritas List dari mutasi eksternal',
        'Kalkulasi real-time sisa SKS dari batas kelulusan 144 SKS',
      ],
      code: '''// ===========================================================================
// PBO: GETTER READ-ONLY & COMPUTED PROPERTIES
// File: lib/models/student_model.dart
// ===========================================================================

// 1. Getter baca atribut privat
String get nim => _nim;
String get nama => _nama;
double get ipk => _ipk;
int get semester => _semester;
int get totalSks => _totalSks;

// 2. Computed Getter: Format IPK menjadi 2 digit desimal
String get ipkFormatted => _ipk.toStringAsFixed(2);

// 3. Computed Getter: Menentukan predikat kelulusan akademik
String get predikatKelulusan {
  if (_ipk >= 3.80) return 'Dengan Pujian (Cum Laude)';
  if (_ipk >= 3.50) return 'Sangat Memuaskan';
  if (_ipk >= 3.00) return 'Memuaskan';
  return 'Cukup';
}

// 4. Computed Getter: Evaluasi boolean status Cum Laude
bool get isCumLaude => _ipk >= 3.80;

// 5. Computed Getter: Menghitung sisa SKS menuju kelulusan (Target 144 SKS)
int get sisaSksLulus {
  const int targetSksKelulusan = 144;
  final sisa = targetSksKelulusan - _totalSks;
  return sisa > 0 ? sisa : 0;
}

// 6. Getter unmodifiable list & map (Enkapsulasi Koleksi)
List<String> get keahlian => List.unmodifiable(_keahlian);
Map<String, double> get nilaiMataKuliah => Map.unmodifiable(_nilaiMataKuliah);''',
    ),

    // 3. ENKAPSULASI & CONSTRUCTORS
    PboCodeSnippet(
      title: 'Enkapsulasi & Blueprint',
      category: 'Deklarasi Objek',
      filePath: 'lib/models/student_model.dart',
      icon: Icons.lock_rounded,
      accentColor: AppColors.primaryLight,
      conceptSummary:
          'Enkapsulasi sejati diwujudkan dengan mendeklarasikan semua atribut kelas dengan awalan underscore (_). '
          'Kelas MahasiswaModel menyediakan beragam konstruktor (Default, Named Constructor, Factory Constructor) '
          'untuk fleksibilitas instansiasi objek.',
      keyPoints: [
        'Semua variabel instans diawali underscore (_) bersifat privat di Dart library',
        'Multiple Constructors: Default, Named (.freshman), dan Factory (.defaultStudent)',
        'Factory Deserialisasi JSON (.fromJson) untuk parsing data',
        'Penyembunyian detail implementasi internal (Information Hiding)',
      ],
      code: '''// ===========================================================================
// PBO: ENKAPSULASI ATRIBUT PRIVAT & MULTIPLE CONSTRUCTORS
// File: lib/models/student_model.dart
// ===========================================================================

class MahasiswaModel {
  // Seluruh atribut inti berstatus privat (Enkapsulasi)
  String _nim;
  String _nama;
  String _email;
  String _jurusan;
  int _semester;
  double _ipk;
  int _totalSks;
  final List<String> _keahlian;
  bool _isActive;
  DateTime _terakhirDiperbarui;

  /// 1. Default Constructor Lengkap
  MahasiswaModel({
    required String nim,
    required String nama,
    required String email,
    String jurusan = 'Teknik Informatika',
    int semester = 4,
    double ipk = 3.92,
    int totalSks = 84,
    List<String>? keahlian,
  })  : _nim = nim,
        _nama = nama,
        _email = email,
        _jurusan = jurusan,
        _semester = semester,
        _ipk = ipk,
        _totalSks = totalSks,
        _keahlian = keahlian ?? ['Dart', 'Flutter', 'PBO (OOP)'],
        _isActive = true,
        _terakhirDiperbarui = DateTime.now();

  /// 2. Named Constructor: Inisialisasi mahasiswa baru
  MahasiswaModel.freshman({
    required String nim,
    required String nama,
    required String email,
    String jurusan = 'Teknik Informatika',
  })  : _nim = nim,
        _nama = nama,
        _email = email,
        _jurusan = jurusan,
        _semester = 1,
        _ipk = 0.0,
        _totalSks = 0,
        _keahlian = ['Algoritma Dasar'],
        _isActive = true,
        _terakhirDiperbarui = DateTime.now();
}''',
    ),

    // 4. FUNCTIONS / METHODS OPERASIONAL
    PboCodeSnippet(
      title: 'Methods & Functions',
      category: 'Operasi Objek',
      filePath: 'lib/models/student_model.dart',
      icon: Icons.code_rounded,
      accentColor: AppColors.accent,
      conceptSummary:
          'Method/Function pada objek merepresentasikan perilaku (behavior) sistem. '
          'Setiap mutasi koleksi dan kalkulasi bisnis dieksekusi melalui method terenkapsulasi '
          'dengan validasi parameter input.',
      keyPoints: [
        'Method tambahSks(): Menambah kredit SKS dan mencegah input negatif',
        'Method tambahKeahlian(): Menambah skill dengan validasi pencegah duplikasi',
        'Method evaluasiKelayakanSkripsi(): Logika bisnis syarat akademik tugas akhir',
        'Method catatNilaiMataKuliah(): Pencatatan nilai dan kalkulasi rata-rata',
      ],
      code: '''// ===========================================================================
// PBO: FUNCTIONS / METHODS OPERASIONAL OBJEK
// File: lib/models/student_model.dart
// ===========================================================================

/// Method: Menambahkan kredit SKS dengan validasi nilai positif
void tambahSks(int sksTambahan) {
  if (sksTambahan <= 0) {
    throw ArgumentError('SKS tambahan harus berupa bilangan bulat positif (> 0).');
  }
  _totalSks += sksTambahan;
  _terakhirDiperbarui = DateTime.now();
}

/// Method: Menambahkan keahlian baru ke list privat (mencegah duplikasi)
bool tambahKeahlian(String skill) {
  final cleanSkill = skill.trim();
  if (cleanSkill.isEmpty) return false;
  if (_keahlian.any((item) => item.toLowerCase() == cleanSkill.toLowerCase())) {
    return false; // Mencegah duplikasi data
  }
  _keahlian.add(cleanSkill);
  _terakhirDiperbarui = DateTime.now();
  return true;
}

/// Method: Evaluasi kelayakan skripsi berdasarkan syarat SKS, IPK, dan semester
String evaluasiKelayakanSkripsi() {
  if (_totalSks >= 130 && _ipk >= 2.75 && _semester >= 7) {
    return 'LAYAK: Memenuhi seluruh syarat akademik skripsi';
  }
  return 'BELUM LAYAK: SKS minimal 130 (sekarang: \$_totalSks), IPK min 2.75, semester min 7';
}

/// Method: Menghitung rata-rata nilai seluruh mata kuliah
double hitungRataRataNilai() {
  if (_nilaiMataKuliah.isEmpty) return 0.0;
  final total = _nilaiMataKuliah.values.reduce((a, b) => a + b);
  return total / _nilaiMataKuliah.length;
}''',
    ),

    // 5. PEWARISAN & POLIMORFISME
    PboCodeSnippet(
      title: 'Pewarisan & Polimorfisme',
      category: 'Hierarki Kelas',
      filePath: 'lib/models/user_model.dart',
      icon: Icons.account_tree_rounded,
      accentColor: AppColors.primary,
      conceptSummary:
          'Prinsip Pewarisan (Inheritance) diwujudkan melalui kelas abstrak BaseUser yang diturunkan ke subclass '
          'seperti MahasiswaAuthorUser, AcademicEvaluatorUser, dan RecruiterUser. '
          'Polimorfisme diterapkan melalui override method untuk menentukan hak akses dan izin sesi secara dinamis.',
      keyPoints: [
        'Abstraksi: abstract class BaseUser sebagai cetak biru kontrak antarmuka',
        'Pewarisan: class MahasiswaAuthorUser extends BaseUser',
        'Polimorfisme: Override method getRoleTitle(), getClearanceLevel(), getPermissions()',
        'Dynamic Dispatch: Perilaku objek ditentukan saat runtime sesuai tipe turunan',
      ],
      code: '''// ===========================================================================
// PBO: PEWARISAN (INHERITANCE) & POLIMORFISME RUNTIME (@override)
// File: lib/models/user_model.dart
// ===========================================================================

/// 1. KELAS INDUK ABSTRAK (ABSTRAKSI)
abstract class BaseUser {
  final String id;
  final String username;
  final String displayName;
  final String avatarUrl;

  BaseUser({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatarUrl,
  });

  // Abstract methods yang wajib di-override oleh seluruh subclass (Polimorfisme)
  String getRoleTitle();
  String getClearanceLevel();
  Color getRoleColor();
  List<String> getPermissions();
}

/// 2. SUBCLASS TURUNAN: Mahasiswa Author & Pengembang
class MahasiswaAuthorUser extends BaseUser {
  final String nim;
  final String programStudi;
  final double ipk;

  MahasiswaAuthorUser({
    required super.id,
    required super.username,
    required super.displayName,
    required super.avatarUrl,
    required this.nim,
    required this.programStudi,
    required this.ipk,
  });

  // Polimorfisme Dinamis (@override)
  @override
  String getRoleTitle() => 'Mahasiswa Pengembang & Author PBO';

  @override
  String getClearanceLevel() => 'Level Administrator (Master Source & Rubrik PBO)';

  @override
  Color getRoleColor() => AppColors.secondary;

  @override
  List<String> getPermissions() => [
    'Akses Penuh Blueprint Model & Objek',
    'Uji Eksplorasi Setter & Getter Real-Time',
    'Ekspor & Unduh Dokumen Laporan PDF',
  ];
}''',
    ),
  ];

  void _copyCurrentCode() {
    Clipboard.setData(ClipboardData(text: _snippets[_selectedIndex].code));
    setState(() => _isCopied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kode ${_snippets[_selectedIndex].title} berhasil disalin!'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isCopied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeSnippet = _snippets[_selectedIndex];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface.withOpacity(0.85),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.12),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.code_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'KODE SUMBER IMPLEMENTASI PBO MURNI',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.secondary,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Implementasi PBO: Setter, Getter, Enkapsulasi & Functions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Text(
            'Berikut adalah kode sumber asli dari package lib/models/ yang membuktikan penerapan '
            'konsep Pemrograman Berorientasi Objek (PBO) secara nyata: mutasi data tervalidasi via Setter, '
            'perhitungan status dinamis via Getter, enkapsulasi atribut privat (_), dan polimorfisme runtime.',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.6),
          ),

          const SizedBox(height: 22),

          // Tab Selector Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_snippets.length, (index) {
                final snippet = _snippets[index];
                final isSelected = _selectedIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: () => setState(() => _selectedIndex = index),
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? snippet.accentColor.withOpacity(0.18) : AppColors.bgDark,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? snippet.accentColor : AppColors.glassBorder,
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            snippet.icon,
                            size: 16,
                            color: isSelected ? snippet.accentColor : AppColors.textMuted,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            snippet.title,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 18),

          // Code IDE Window
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0D1117), // GitHub / VS Code Dark
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Window Header Bar (macOS style dots + file path + copy button)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: const BoxDecoration(
                      color: Color(0xFF161B22),
                      border: Border(bottom: BorderSide(color: Color(0xFF30363D))),
                    ),
                    child: Row(
                      children: [
                        // macOS Traffic Light Dots
                        Row(
                          children: [
                            Container(width: 11, height: 11, decoration: const BoxDecoration(color: Color(0xFFFF5F56), shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            Container(width: 11, height: 11, decoration: const BoxDecoration(color: Color(0xFFFFBD2E), shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            Container(width: 11, height: 11, decoration: const BoxDecoration(color: Color(0xFF27C93F), shape: BoxShape.circle)),
                          ],
                        ),
                        const SizedBox(width: 14),
                        Icon(Icons.insert_drive_file_outlined, size: 14, color: activeSnippet.accentColor),
                        const SizedBox(width: 6),
                        Text(
                          activeSnippet.filePath,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: _copyCurrentCode,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.bgDark,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.glassBorder),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _isCopied ? Icons.check_rounded : Icons.content_copy_rounded,
                                  size: 13,
                                  color: _isCopied ? AppColors.accent : AppColors.textSecondary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _isCopied ? 'Tersalin!' : 'Salin Kode',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: _isCopied ? AppColors.accent : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Code Text Viewer Area
                  Container(
                    padding: const EdgeInsets.all(16),
                    constraints: const BoxConstraints(maxHeight: 380),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SelectableText.rich(
                          _buildSyntaxHighlightedSpan(activeSnippet.code, activeSnippet.accentColor),
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12.5,
                            height: 1.55,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // PBO Explanation Card Below Code
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgDark.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: activeSnippet.accentColor.withOpacity(0.35)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb_rounded, size: 18, color: activeSnippet.accentColor),
                    const SizedBox(width: 8),
                    Text(
                      'Penerapan Konsep PBO: ${activeSnippet.title} (${activeSnippet.category})',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: activeSnippet.accentColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  activeSnippet.conceptSummary,
                  style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.5),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: activeSnippet.keyPoints.map((point) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_rounded, size: 13, color: activeSnippet.accentColor),
                        const SizedBox(width: 6),
                        Text(
                          point,
                          style: const TextStyle(fontSize: 11.5, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Parser Sederhana untuk Syntax Highlighting Dart
  TextSpan _buildSyntaxHighlightedSpan(String code, Color accent) {
    final lines = code.split('\n');
    final spans = <TextSpan>[];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final lineNumber = '${(i + 1).toString().padLeft(2, ' ')}  ';

      // Line number
      spans.add(TextSpan(
        text: lineNumber,
        style: const TextStyle(color: Color(0xFF484F58)),
      ));

      // Comment line
      if (line.trim().startsWith('//') || line.trim().startsWith('///')) {
        spans.add(TextSpan(
          text: '$line\n',
          style: const TextStyle(color: Color(0xFF8B949E), fontStyle: FontStyle.italic),
        ));
        continue;
      }

      // Syntax tokens
      final matches = RegExp(r'(\s+|[(),;{}=><+\-*/!$])').allMatches(line);

      // Reconstruct line with styled spans
      int lastIndex = 0;
      for (final match in matches) {
        if (match.start > lastIndex) {
          final token = line.substring(lastIndex, match.start);
          spans.add(_styleToken(token, accent));
        }
        spans.add(TextSpan(
          text: match.group(0),
          style: const TextStyle(color: Color(0xFFE6EDF3)),
        ));
        lastIndex = match.end;
      }
      if (lastIndex < line.length) {
        spans.add(_styleToken(line.substring(lastIndex), accent));
      }
      spans.add(const TextSpan(text: '\n'));
    }

    return TextSpan(children: spans);
  }

  TextSpan _styleToken(String token, Color accent) {
    const keywords = {
      'set', 'get', 'class', 'void', 'return', 'throw', 'if', 'else', 'abstract',
      'extends', 'super', 'final', 'required', 'factory', 'bool', 'int', 'double',
      'String', 'DateTime', 'List', 'Map', 'true', 'false', 'null', 'const', 'new'
    };

    if (keywords.contains(token)) {
      return TextSpan(
        text: token,
        style: const TextStyle(color: Color(0xFFFF7B72), fontWeight: FontWeight.w700), // Keyword Red/Pink
      );
    } else if (token.startsWith('@')) {
      return TextSpan(
        text: token,
        style: const TextStyle(color: Color(0xFFD2A8FF), fontWeight: FontWeight.w700), // Annotation Purple
      );
    } else if (token.startsWith('_')) {
      return TextSpan(
        text: token,
        style: const TextStyle(color: Color(0xFF7EE787)), // Private Field Emerald
      );
    } else if (token.startsWith("'") || token.endsWith("'")) {
      return TextSpan(
        text: token,
        style: const TextStyle(color: Color(0xFFA5D6FF)), // String Blue
      );
    } else if (double.tryParse(token) != null || int.tryParse(token) != null) {
      return TextSpan(
        text: token,
        style: const TextStyle(color: Color(0xFFFFA657)), // Number Amber
      );
    }

    return TextSpan(
      text: token,
      style: const TextStyle(color: Color(0xFFE6EDF3)), // Default White
    );
  }
}
