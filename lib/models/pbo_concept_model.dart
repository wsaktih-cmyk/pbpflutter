import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Model interaktif untuk menjelaskan dan menguji 4 Pilar Utama PBO
class PboConceptModel {
  final String title;
  final String subtitle;
  final String description;
  final String dartCodeSnippet;
  final IconData icon;
  final Color accentColor;
  final List<String> keyBenefits;
  final String Function() simulationCallback;

  PboConceptModel({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.dartCodeSnippet,
    required this.icon,
    required this.accentColor,
    required this.keyBenefits,
    required this.simulationCallback,
  });

  static List<PboConceptModel> getCoreConcepts() {
    return [
      PboConceptModel(
        title: 'Enkapsulasi',
        subtitle: 'Data Hiding & Validation Integrity',
        description:
            'Menyembunyikan atribut internal objek (menggunakan tanda "_" pada Dart) dan hanya mengizinkan modifikasi melalui getter & setter dengan validasi ketat untuk menjaga integritas status data.',
        icon: Icons.lock_outline_rounded,
        accentColor: AppColors.primary,
        keyBenefits: [
          'Melindungi data sensitif dari modifikasi luar ilegal',
          'Memvalidasi nilai masukan secara otomatis',
          'Mengurangi ketergantungan antar modul (loose coupling)',
        ],
        dartCodeSnippet: '''
class AkunBankPBO {
  // Properti privat (enkapsulasi)
  double _saldo = 0.0;

  // Getter terkontrol
  double get saldo => _saldo;

  // Setter dengan validasi ketat
  void setor(double jumlah) {
    if (jumlah <= 0) throw Exception("Jumlah setor harus > 0");
    _saldo += jumlah;
  }
}''',
        simulationCallback: () {
          // Simulasi langsung kode PBO
          final akun = _DemoBank(1500000);
          final mutasi1 = akun.setor(500000);
          final mutasi2 = akun.tarik(250000);
          return '''
[HASIL EKSEKUSI ENKAPSULASI]
1. Inisialisasi Akun: Saldo awal Rp 1.500.000 (disimpan aman di _saldo)
2. Transaksi Setor: +Rp 500.000 -> $mutasi1
3. Transaksi Tarik: -Rp 250.000 -> $mutasi2
4. Verifikasi: Saldo akhir terverifikasi konsisten = Rp ${akun.saldo.toStringAsFixed(0)}
''';
        },
      ),
      PboConceptModel(
        title: 'Pewarisan (Inheritance)',
        subtitle: 'Code Reusability & Logical Hierarchies',
        description:
            'Memungkinkan subclass mewarisi karakteristik, state, dan metode dari superclass, sehingga menghindari duplikasi kode dan membangun relasi taksonomi yang teratur.',
        icon: Icons.account_tree_rounded,
        accentColor: AppColors.secondary,
        keyBenefits: [
          'Meniadakan perulangan kode (DRY Principle)',
          'Mempermudah penambahan fitur baru di masa depan',
          'Membangun relasi "is-a" yang kuat antar entitas',
        ],
        dartCodeSnippet: '''
// Superclass umum
class AkunGame {
  String username;
  int level;
  AkunGame(this.username, this.level);
  void info() => print("\$username Lv.\$level");
}

// Subclass mewarisi superclass
class AkunFPS extends AkunGame {
  double killDeathRatio;
  AkunFPS(String u, int l, this.killDeathRatio) : super(u, l);
}''',
        simulationCallback: () {
          final fps = _DemoAkunFPS("SniperGhost", 42, 3.85);
          final moba = _DemoAkunMOBA("MythicWarrior", 78, "Glory 85 Stars");
          return '''
[HASIL EKSEKUSI PEWARISAN]
1. Menginstansiasi AkunFPS extends AkunGame:
   -> User: ${fps.username}, Level: ${fps.level}, K/D Ratio: ${fps.kdRatio}
2. Menginstansiasi AkunMOBA extends AkunGame:
   -> User: ${moba.username}, Level: ${moba.level}, Rank: ${moba.rankTier}
3. Keduanya mewarisi fungsi infoDasar() dari Superclass AkunGame!
''';
        },
      ),
      PboConceptModel(
        title: 'Polimorfisme (Polymorphism)',
        subtitle: 'Dynamic Method Dispatch & Flexibility',
        description:
            'Kemampuan satu entitas/fungsi induk untuk dieksekusi dengan perilaku yang berbeda-beda sesuai dengan tipe spesifik dari objek turunannya pada saat runtime (@override).',
        icon: Icons.hub_rounded,
        accentColor: AppColors.accent,
        keyBenefits: [
          'Fleksibilitas tinggi dalam memproses kumpulan objek heterogen',
          'Satu antarmuka seragam untuk beragam implementasi',
          'Mendukung prinsip Open/Closed pada SOLID',
        ],
        dartCodeSnippet: '''
abstract class Notifikasi {
  void kirimPesan(String pesan);
}

class EmailNotif extends Notifikasi {
  @override
  void kirimPesan(String p) => kirimViaSMTP(p);
}

class WhatsAppNotif extends Notifikasi {
  @override
  void kirimPesan(String p) => kirimViaApiWA(p);
}''',
        simulationCallback: () {
          final List<_DemoNotif> daftar = [
            _DemoEmailNotif(),
            _DemoTelegramNotif(),
            _DemoInAppNotif(),
          ];
          final logs = daftar.map((notif) => notif.kirim("Portofolio dibuka!")).join('\n');
          return '''
[HASIL EKSEKUSI POLIMORFISME]
Memproses antrian List<Notifikasi> yang berisi tipe turunan berbeda:
$logs
Semua objek dipanggil seragam melalui method .kirim(), namun masing-masing merespons dengan protokol unik!
''';
        },
      ),
      PboConceptModel(
        title: 'Abstraksi (Abstraction)',
        subtitle: 'Interface Contracts & Complexity Hiding',
        description:
            'Menyembunyikan detail teknis sistem yang rumit di balik antarmuka abstrak sederhana. Pengguna hanya perlu mengetahui fungsi yang tersedia tanpa pusing dengan mekanisme internalnya.',
        icon: Icons.auto_awesome_mosaic_rounded,
        accentColor: AppColors.accentRose,
        keyBenefits: [
          'Mereduksi kompleksitas sistem bagi antarmuka luar',
          'Memisahkan kontrak (apa yang dilakukan) dari implementasi (bagaimana caranya)',
          'Memudahkan pengujian unit (unit testing) dan mocking',
        ],
        dartCodeSnippet: '''
// Kontrak Abstraksi
abstract class RepositoryPortofolio {
  Future<List<PortfolioItem>> getItems();
  Future<void> simpanItem(PortfolioItem item);
}

// Implementasi nyata terisolasi
class LocalPortfolioRepo implements RepositoryPortofolio {
  @override
  Future<List<PortfolioItem>> getItems() async => [...];
}''',
        simulationCallback: () {
          return '''
[HASIL EKSEKUSI ABSTRAKSI]
- Kontrak PortfolioRepository dipanggil oleh UI layer.
- UI tidak perlu tahu apakah data diambil dari SQLite, API REST, atau InMemoryMock.
- Abstraksi berhasil mengisolasi kompleksitas IO dari representasi visual!
''';
        },
      ),
    ];
  }
}

// --- Kelas Demo Internal untuk Membuktikan Eksekusi PBO Nyata ---
class _DemoBank {
  double _saldo;
  _DemoBank(this._saldo);
  double get saldo => _saldo;
  String setor(double jml) {
    _saldo += jml;
    return "Berhasil setor Rp ${jml.toStringAsFixed(0)}, saldo sekarang Rp ${_saldo.toStringAsFixed(0)}";
  }
  String tarik(double jml) {
    if (_saldo >= jml) {
      _saldo -= jml;
      return "Berhasil tarik Rp ${jml.toStringAsFixed(0)}, saldo sekarang Rp ${_saldo.toStringAsFixed(0)}";
    }
    return "Gagal tarik: Saldo tidak cukup!";
  }
}

class _DemoAkunGame {
  final String username;
  final int level;
  _DemoAkunGame(this.username, this.level);
}

class _DemoAkunFPS extends _DemoAkunGame {
  final double kdRatio;
  _DemoAkunFPS(super.username, super.level, this.kdRatio);
}

class _DemoAkunMOBA extends _DemoAkunGame {
  final String rankTier;
  _DemoAkunMOBA(super.username, super.level, this.rankTier);
}

abstract class _DemoNotif {
  String kirim(String pesan);
}

class _DemoEmailNotif extends _DemoNotif {
  @override
  String kirim(String pesan) => "📧 [SMTP Service]: Terkirim ke email dosen -> '$pesan'";
}

class _DemoTelegramNotif extends _DemoNotif {
  @override
  String kirim(String pesan) => "✈️ [Telegram Bot API]: Webhook terpicu -> '$pesan'";
}

class _DemoInAppNotif extends _DemoNotif {
  @override
  String kirim(String pesan) => "🔔 [In-App Toast]: Notifikasi popup ditampilkan -> '$pesan'";
}
