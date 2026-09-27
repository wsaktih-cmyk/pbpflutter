/// ============================================================================
/// BLUEPRINT ENTITAS: ProjectEvaluationModel (Model Blueprint Evaluasi Proyek)
/// ============================================================================
/// Mengimplementasikan prinsip Pemrograman Berorientasi Objek (PBO):
/// - Enkapsulasi: Skor dan atribut terlindungi dalam private fields
/// - Getter & Setter: Validasi rentang nilai rubrik 0.0 - 100.0
/// - Functions/Methods: Perhitungan nilai akhir berbobot, konversi grade, dan rekomendasi
/// ============================================================================

class ProjectEvaluationModel {
  // --- ATRIBUT PRIVAT TERENKAPSULASI ---
  String _projectId;
  String _projectTitle;
  String _evaluatorName;
  double _skorArsitekturPbo;   // Bobot: 35%
  double _skorEnkapsulasi;     // Bobot: 25%
  double _skorPolimorfisme;    // Bobot: 20%
  double _skorAntarmukaUi;     // Bobot: 20%
  String _catatanEvaluasi;
  bool _isVerified;
  DateTime _tanggalEvaluasi;

  /// Default Constructor
  ProjectEvaluationModel({
    required String projectId,
    required String projectTitle,
    required String evaluatorName,
    double skorArsitekturPbo = 95.0,
    double skorEnkapsulasi = 98.0,
    double skorPolimorfisme = 92.0,
    double skorAntarmukaUi = 94.0,
    String catatanEvaluasi = 'Implementasi arsitektur PBO sangat rapi, pemisahan blueprint model jelas, dan enkapsulasi setter/getter teruji optimal.',
    bool isVerified = true,
    DateTime? tanggalEvaluasi,
  })  : _projectId = projectId,
        _projectTitle = projectTitle,
        _evaluatorName = evaluatorName,
        _skorArsitekturPbo = skorArsitekturPbo,
        _skorEnkapsulasi = skorEnkapsulasi,
        _skorPolimorfisme = skorPolimorfisme,
        _skorAntarmukaUi = skorAntarmukaUi,
        _catatanEvaluasi = catatanEvaluasi,
        _isVerified = isVerified,
        _tanggalEvaluasi = tanggalEvaluasi ?? DateTime.now();

  /// Factory Constructor: Contoh evaluasi default untuk Portofolio PBO
  factory ProjectEvaluationModel.defaultAudit() {
    return ProjectEvaluationModel(
      projectId: 'PBO-FLUTTER-2026',
      projectTitle: 'Portofolio Minimalis Elegan & Laboratorium PBO',
      evaluatorName: 'Dr. Ir. Hendra Saputra, M.Kom (Dosen Pengampu PBO)',
      skorArsitekturPbo: 97.0,
      skorEnkapsulasi: 98.5,
      skorPolimorfisme: 95.0,
      skorAntarmukaUi: 96.0,
      catatanEvaluasi:
          'Struktur model blueprint sangat modular. Setter memvalidasi boundary data dengan tepat. '
          'Penggunaan ListView.builder dan desain kartu cyber memenuhi standar industri software engineering.',
      isVerified: true,
    );
  }

  // ===========================================================================
  // GETTER (READ ACCESS & COMPUTED ATTRIBUTES)
  // ===========================================================================

  String get projectId => _projectId;
  String get projectTitle => _projectTitle;
  String get evaluatorName => _evaluatorName;
  double get skorArsitekturPbo => _skorArsitekturPbo;
  double get skorEnkapsulasi => _skorEnkapsulasi;
  double get skorPolimorfisme => _skorPolimorfisme;
  double get skorAntarmukaUi => _skorAntarmukaUi;
  String get catatanEvaluasi => _catatanEvaluasi;
  bool get isVerified => _isVerified;
  DateTime get tanggalEvaluasi => _tanggalEvaluasi;

  /// Computed Getter: Menghitung Nilai Akhir dengan Pembobotan Standar Akademik
  /// Bobot: PBO 35% + Enkapsulasi 25% + Polimorfisme 20% + UI 20%
  double get nilaiAkhir {
    final bobotPbo = _skorArsitekturPbo * 0.35;
    final bobotEnkapsulasi = _skorEnkapsulasi * 0.25;
    final bobotPolimorfisme = _skorPolimorfisme * 0.20;
    final bobotUi = _skorAntarmukaUi * 0.20;
    return bobotPbo + bobotEnkapsulasi + bobotPolimorfisme + bobotUi;
  }

  /// Computed Getter: Format string nilai akhir 2 angka desimal
  String get nilaiAkhirFormatted => nilaiAkhir.toStringAsFixed(2);

  /// Computed Getter: Konversi ke Huruf Mutu Standar Kampus
  String get hurufMutu {
    final na = nilaiAkhir;
    if (na >= 85.0) return 'A (Sangat Istimewa)';
    if (na >= 80.0) return 'A- (Amat Baik)';
    if (na >= 75.0) return 'B+ (Lebih Baik)';
    if (na >= 70.0) return 'B (Baik)';
    if (na >= 65.0) return 'B- (Cukup Baik)';
    if (na >= 60.0) return 'C+ (Cukup)';
    if (na >= 55.0) return 'C (Kurang Cukup)';
    return 'D / E (Belum Memenuhi Syarat Lulus)';
  }

  /// Computed Getter: Status kelulusan proyek (Batas minimal nilai 70.0)
  bool get isLulus => nilaiAkhir >= 70.0;

  // ===========================================================================
  // SETTER (MUTASI STATUS DENGAN VALIDASI ENKAPSULASI)
  // ===========================================================================

  set skorArsitekturPbo(double value) {
    _validasiSkor(value, 'Skor Arsitektur PBO');
    _skorArsitekturPbo = value;
    _tanggalEvaluasi = DateTime.now();
  }

  set skorEnkapsulasi(double value) {
    _validasiSkor(value, 'Skor Enkapsulasi');
    _skorEnkapsulasi = value;
    _tanggalEvaluasi = DateTime.now();
  }

  set skorPolimorfisme(double value) {
    _validasiSkor(value, 'Skor Polimorfisme');
    _skorPolimorfisme = value;
    _tanggalEvaluasi = DateTime.now();
  }

  set skorAntarmukaUi(double value) {
    _validasiSkor(value, 'Skor Antarmuka UI');
    _skorAntarmukaUi = value;
    _tanggalEvaluasi = DateTime.now();
  }

  set catatanEvaluasi(String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError('Catatan evaluasi tidak boleh kosong.');
    }
    _catatanEvaluasi = value.trim();
    _tanggalEvaluasi = DateTime.now();
  }

  set isVerified(bool value) {
    _isVerified = value;
    _tanggalEvaluasi = DateTime.now();
  }

  /// Private Helper Function: Validasi rentang angka 0.0 - 100.0
  void _validasiSkor(double skor, String namaKomponen) {
    if (skor < 0.0 || skor > 100.0) {
      throw ArgumentError(
        'Validasi Enkapsulasi Gagal: $namaKomponen harus berada di rentang 0.0 - 100.0 (Input: $skor)',
      );
    }
  }

  // ===========================================================================
  // FUNCTIONS / METHODS
  // ===========================================================================

  /// Method: Membuat ringkasan laporan hasil evaluasi PBO
  String generateLaporanRingkas() {
    return '''
===========================================================
HASIL AUDIT & PENILAIAN PROYEK PBO
===========================================================
Proyek         : $_projectTitle [ID: $_projectId]
Evaluator      : $_evaluatorName
Tanggal        : ${_tanggalEvaluasi.day}/${_tanggalEvaluasi.month}/${_tanggalEvaluasi.year}

[KOMPONEN RUBRIK PENILAIAN]
1. Arsitektur & Hierarki PBO (35%) : ${_skorArsitekturPbo.toStringAsFixed(1)} / 100
2. Enkapsulasi & Getter-Setter (25%): ${_skorEnkapsulasi.toStringAsFixed(1)} / 100
3. Polimorfisme & Abstraksi (20%)   : ${_skorPolimorfisme.toStringAsFixed(1)} / 100
4. Antarmuka UI Flutter (20%)       : ${_skorAntarmukaUi.toStringAsFixed(1)} / 100

Nilai Akhir    : $nilaiAkhirFormatted ($hurufMutu)
Status Proyek  : ${isLulus ? '✅ LULUS DENGAN PRESTASI UNGGUL' : '⚠️ PERLU REVISI'}
Verifikasi     : ${_isVerified ? 'Telah Diverifikasi Resmi Dosen' : 'Draft / Menunggu'}

Catatan Penguji:
"$_catatanEvaluasi"
===========================================================
''';
  }

  Map<String, dynamic> toMap() {
    return {
      'projectId': _projectId,
      'projectTitle': _projectTitle,
      'evaluatorName': _evaluatorName,
      'skorArsitekturPbo': _skorArsitekturPbo,
      'skorEnkapsulasi': _skorEnkapsulasi,
      'skorPolimorfisme': _skorPolimorfisme,
      'skorAntarmukaUi': _skorAntarmukaUi,
      'nilaiAkhir': nilaiAkhir,
      'hurufMutu': hurufMutu,
      'isLulus': isLulus,
      'catatanEvaluasi': _catatanEvaluasi,
      'isVerified': _isVerified,
      'tanggalEvaluasi': _tanggalEvaluasi.toIso8601String(),
    };
  }
}
