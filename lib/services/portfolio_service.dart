import '../models/portfolio_item.dart';

class PortfolioService {
  static final List<PortfolioItem> _items = [
    PboCourseworkItem(
      id: 'pbo-01',
      title: 'Hirarki Akun Game FPS vs MOBA (UTS PBO)',
      shortDescription:
          'Implementasi superclass AkunGame dengan subclass AkunFPS & AkunMOBA menggunakan pewarisan, polimorfisme, dan enkapsulasi.',
      detailedDescription:
          'Proyek tugas ujian tengah semester mata kuliah PBO. Memodelkan sistem autentikasi dan status game multi-genre. Menggunakan enkapsulasi untuk menyembunyikan rumus MMR dan K/D ratio, serta polimorfisme untuk mencetak ringkasan stat pemain secara dinamis.',
      techStack: ['Java', 'Dart', 'OOP Architecture', 'UML Class Diagram'],
      dateCreated: 'Semester 4 • 2026',
      courseSemester: 'Tugas UTS PBO',
      pboPrinciplesUsed: ['Inheritance', 'Polymorphism', 'Encapsulation'],
      classHierarchyDescription: 'Superclass: AkunGame -> Subclasses: AkunFPS, AkunMOBA',
      sourceCodeSample: '''
// Contoh Source Code Hirarki PBO
class AkunGame {
  final String username;
  protected int level;
  public AkunGame(String u, int l) { this.username = u; this.level = l; }
  public String getStatRingkas() { return username + " (Lv." + level + ")"; }
}

class AkunFPS extends AkunGame {
  private double kdRatio;
  public AkunFPS(String u, int l, double kd) {
    super(u, l);
    this.kdRatio = kd;
  }
  @Override
  public String getStatRingkas() {
    return super.getStatRingkas() + " - K/D: " + kdRatio;
  }
}''',
      simulatedExecutionLog:
          '✓ Menguji objek AkunFPS ("Viper_X", Lv.50, KD: 3.4)\n✓ Menguji objek AkunMOBA ("LancelotGod", Lv.92, Mythic)\n✓ Menjalankan dispatch polimorfik method getStatRingkas().',
    ),
    PboCourseworkItem(
      id: 'pbo-02',
      title: 'Sistem Reservasi & Transaksi Bank OOP (UAS PBO)',
      shortDescription:
          'Arsitektur transaksi perbankan dengan antarmuka transfer abstrak, enkapsulasi mutasi saldo, dan penanganan exception.',
      detailedDescription:
          'Proyek akhir semester untuk mata kuliah PBO. Menerapkan design pattern Factory Method untuk pembuatan akun giro, tabungan, dan deposito. Dilengkapi proteksi concurrency dan validasi masukan terisolasi.',
      techStack: ['Dart', 'OOP Patterns', 'Exception Handling', 'Polymorphic Interface'],
      dateCreated: 'Semester 4 • 2026',
      courseSemester: 'Tugas UAS PBO',
      pboPrinciplesUsed: ['Abstraction', 'Encapsulation', 'Interface Contract'],
      classHierarchyDescription:
          'Interface: ITransaksi -> Abstract: AkunPerbankan -> Subclass: RekeningTabungan, RekeningGiro',
      sourceCodeSample: '''
abstract class AkunPerbankan implements ITransaksi {
  final String nomorRekening;
  double _saldo = 0.0;

  AkunPerbankan(this.nomorRekening, double saldoAwal) : _saldo = saldoAwal;

  double get saldo => _saldo;

  @override
  bool validasiLimit(double nominal);
}''',
      simulatedExecutionLog:
          '✓ Inisialisasi RekeningGiro dengan limit overdraft Rp 5.000.000\n✓ Menjalankan transfer antar-bank polimorfik\n✓ Enkapsulasi saldo berhasil mencegah mutasi negatif.',
    ),
    SoftwareAppItem(
      id: 'app-01',
      title: 'DevSpace - Developer Portfolio & Task Manager',
      shortDescription:
          'Aplikasi portofolio dan manajemen tugas lintas platform dengan animasi modern, visualisasi progress, dan sinkronisasi awan.',
      detailedDescription:
          'Aplikasi Flutter mutakhir yang mengkombinasikan arsitektur berorientasi objek yang rapi dengan antarmuka minimalis elegan. Menggunakan CustomPainter untuk animasi latar belakang dinamis.',
      category: PortfolioCategory.mobile,
      techStack: ['Flutter', 'Dart 3', 'CustomPainter', 'Provider'],
      dateCreated: '2026',
      platform: 'Cross-Platform (Web & Mobile)',
      totalStars: 124,
      isFeatured: true,
    ),
    SoftwareAppItem(
      id: 'app-02',
      title: 'Smart Campus Academic Portal',
      shortDescription:
          'Sistem portal nilai dan presensi mahasiswa dengan dashboard analitik berbasis komponen reusable OOP.',
      detailedDescription:
          'Aplikasi web responsif untuk pengelolaan KRS, absensi, dan unggah berkas tugas kuliah. Dibangun dengan struktur domain-driven design dan enkapsulasi service layer.',
      category: PortfolioCategory.web,
      techStack: ['Flutter Web', 'REST API', 'OOP Architecture', 'Material 3'],
      dateCreated: '2026',
      platform: 'Flutter Web & Cloud API',
      totalStars: 89,
    ),
    PboCourseworkItem(
      id: 'pbo-03',
      title: 'Simulasi Ekosistem & Predator-Prey (PBO Praktikum)',
      shortDescription:
          'Simulasi komputasi ekosistem hewan menggunakan polimorfisme perilaku makan, gerak, dan reproduksi.',
      detailedDescription:
          'Studi kasus praktikum PBO untuk mendemonstrasikan kekuatan polimorfisme dan dynamic binding. Setiap kelas turunan hewan memiliki implementasi unik dari fungsi berburu() dan bertahanHidup().',
      techStack: ['Java / Dart', 'Dynamic Binding', 'Simulation Algorithm'],
      dateCreated: 'Semester 4 • 2026',
      courseSemester: 'Praktikum PBO Lab 3',
      pboPrinciplesUsed: ['Polymorphism', 'Abstraction', 'Inheritance'],
      classHierarchyDescription: 'Abstract: MakhlukHidup -> Abstract: Hewan -> Subclass: Karnivora, Herbivora',
      sourceCodeSample: '''
abstract class MakhlukHidup {
  void siklusHidup();
  void adaptasi();
}

class Singa extends HewanKarnivora {
  @override
  void berburu() => print("Singa melacak mangsa secara berkelompok...");
}''',
      simulatedExecutionLog:
          '✓ Menghasilkan grid ekosistem 10x10\n✓ 15 MakhlukHidup mengeksekusi siklusHidup() secara polimorfik\n✓ Keseimbangan populasi tercapai.',
    ),
  ];

  static List<PortfolioItem> getAllItems() => List.unmodifiable(_items);

  static List<PortfolioItem> getItemsByCategory(PortfolioCategory category) {
    if (category == PortfolioCategory.all) {
      return List.unmodifiable(_items);
    }
    return _items.where((item) => item.category == category).toList();
  }

  static List<PboCourseworkItem> getPboCoursework() {
    return _items.whereType<PboCourseworkItem>().toList();
  }
}
