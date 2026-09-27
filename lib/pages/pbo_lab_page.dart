import 'package:flutter/material.dart';
import '../models/project_evaluation_model.dart';
import '../models/user_model.dart';
import '../theme/app_colors.dart';

/// ============================================================================
/// HALAMAN LABORATORIUM PBO (PBO LAB PAGE)
/// ============================================================================
/// Mengimplementasikan 3 fitur utama PBO & Flutter sesuai spesifikasi:
/// 1. ListView.builder (ListBuilder) - Rendering dinamis koleksi data evaluasi
/// 2. Functions (Fungsi & Metode) - Kalkulasi rata-rata, filtering, mutasi state
/// 3. Setter & Getter - Enkapsulasi private field, computed properties & validasi
/// ============================================================================
class PboLabPage extends StatefulWidget {
  final BaseUser currentUser;

  const PboLabPage({
    super.key,
    required this.currentUser,
  });

  @override
  State<PboLabPage> createState() => _PboLabPageState();
}

class _PboLabPageState extends State<PboLabPage> {
  // --- STATE KOLEKSI DATA EVALUASI PROYEK (Digunakan oleh ListView.builder) ---
  late List<ProjectEvaluationModel> _evaluasiList;
  String _searchQuery = '';
  bool _onlyPassedFilter = false;
  int _activeTabIndex = 0; // 0: Live Interactive Lab, 1: Inspektur Kode Sumber

  @override
  void initState() {
    super.initState();
    // Memanggil Function inisialisasi dataset awal
    _initDefaultDataset();
  }

  // ===========================================================================
  // FITUR 2: FUNCTIONS (FUNGSI & METODE DALAM CODINGAN)
  // ===========================================================================

  /// Function 1: Menginisialisasi list evaluasi proyek awal
  void _initDefaultDataset() {
    _evaluasiList = [
      ProjectEvaluationModel(
        projectId: 'PBO-01',
        projectTitle: 'Portofolio Digital & Blueprint Lab',
        evaluatorName: 'Dr. Hendra Saputra, M.Kom',
        skorArsitekturPbo: 98.0,
        skorEnkapsulasi: 96.0,
        skorPolimorfisme: 94.0,
        skorAntarmukaUi: 95.0,
        catatanEvaluasi: 'Arsitektur modular, setter getter tervalidasi dengan baik, dan UI clean minimalis.',
        isVerified: true,
      ),
      ProjectEvaluationModel(
        projectId: 'PBO-02',
        projectTitle: 'Sistem Enkapsulasi Digital Banking',
        evaluatorName: 'Prof. Bambang Subagyo',
        skorArsitekturPbo: 92.0,
        skorEnkapsulasi: 95.0,
        skorPolimorfisme: 88.0,
        skorAntarmukaUi: 90.0,
        catatanEvaluasi: 'Enkapsulasi saldo terlindungi dengan setter validasi mutasi nominal positif.',
        isVerified: true,
      ),
      ProjectEvaluationModel(
        projectId: 'PBO-03',
        projectTitle: 'Polymorphism RPG Hero Battles',
        evaluatorName: 'Ir. Nurul Hidayah, M.T',
        skorArsitekturPbo: 85.0,
        skorEnkapsulasi: 87.0,
        skorPolimorfisme: 96.0,
        skorAntarmukaUi: 89.0,
        catatanEvaluasi: 'Override method serang() dan bertahan() pada subclass turunan sangat dinamis.',
        isVerified: true,
      ),
      ProjectEvaluationModel(
        projectId: 'PBO-04',
        projectTitle: 'Gateway Abstraksi Multi-Vendor Payment',
        evaluatorName: 'Ahmad Fauzi, S.Kom, M.Cs',
        skorArsitekturPbo: 78.0,
        skorEnkapsulasi: 82.0,
        skorPolimorfisme: 80.0,
        skorAntarmukaUi: 75.0,
        catatanEvaluasi: 'Interface abstrak didefinisikan jelas, perlu optimalisasi error handling.',
        isVerified: false,
      ),
      ProjectEvaluationModel(
        projectId: 'PBO-05',
        projectTitle: 'Audit Setter & Getter Sensor IoT',
        evaluatorName: 'Dr. Rina Wulandari, S.T',
        skorArsitekturPbo: 68.0,
        skorEnkapsulasi: 65.0,
        skorPolimorfisme: 62.0,
        skorAntarmukaUi: 66.0,
        catatanEvaluasi: 'Rentang nilai suhu dan kelembaban perlu diperketat pada setter atribut.',
        isVerified: false,
      ),
    ];
  }

  /// Function 2: Menghitung rata-rata nilai akhir dari seluruh item yang ada
  double calculateAverageNilaiAkhir(List<ProjectEvaluationModel> items) {
    if (items.isEmpty) return 0.0;
    // Mengakses Getter .nilaiAkhir dari masing-masing objek
    final total = items.fold(0.0, (sum, item) => sum + item.nilaiAkhir);
    return total / items.length;
  }

  /// Function 3: Menghitung persentase proyek yang lulus (menggunakan Getter .isLulus)
  double calculatePersentaseKelulusan(List<ProjectEvaluationModel> items) {
    if (items.isEmpty) return 0.0;
    final lulusCount = items.where((item) => item.isLulus).length;
    return (lulusCount / items.length) * 100.0;
  }

  /// Function 4: Memfilter daftar evaluasi berdasarkan query dan status kelulusan
  List<ProjectEvaluationModel> filterEvaluasiList() {
    return _evaluasiList.where((item) {
      final matchesQuery = item.projectTitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.projectId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.evaluatorName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _onlyPassedFilter ? item.isLulus : true;
      return matchesQuery && matchesFilter;
    }).toList();
  }

  /// Function 5: Menambahkan evaluasi baru ke dalam List
  void addNewEvaluation({
    required String title,
    required String evaluator,
    required double skorPbo,
    required double skorEnkap,
    required double skorPoli,
    required double skorUi,
    required String catatan,
  }) {
    final newId = 'PBO-${(_evaluasiList.length + 1).toString().padLeft(2, '0')}';
    final modelBaru = ProjectEvaluationModel(
      projectId: newId,
      projectTitle: title,
      evaluatorName: evaluator,
      skorArsitekturPbo: skorPbo,
      skorEnkapsulasi: skorEnkap,
      skorPolimorfisme: skorPoli,
      skorAntarmukaUi: skorUi,
      catatanEvaluasi: catatan,
      isVerified: true,
    );

    setState(() {
      _evaluasiList.insert(0, modelBaru);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Berhasil menambahkan evaluasi proyek baru: $newId'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  /// Function 6: Mengupdate skor menggunakan FITUR 3: SETTER dengan validasi try-catch
  void updateSkorWithSetter(
    ProjectEvaluationModel item, {
    required double skorPbo,
    required double skorEnkap,
    required double skorPoli,
    required double skorUi,
    required String catatan,
  }) {
    try {
      // Memanggil SETTER dari ProjectEvaluationModel yang memicu validasi 0 - 100
      setState(() {
        item.skorArsitekturPbo = skorPbo;     // Memanggil setter: set skorArsitekturPbo(val)
        item.skorEnkapsulasi = skorEnkap;         // Memanggil setter: set skorEnkapsulasi(val)
        item.skorPolimorfisme = skorPoli;       // Memanggil setter: set skorPolimorfisme(val)
        item.skorAntarmukaUi = skorUi;           // Memanggil setter: set skorAntarmukaUi(val)
        item.catatanEvaluasi = catatan;          // Memanggil setter: set catatanEvaluasi(val)
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 Setter berhasil memutasi skor [${item.projectId}]. Nilai Akhir: ${item.nilaiAkhirFormatted}'),
          backgroundColor: AppColors.secondary,
        ),
      );
    } catch (e) {
      // Menangkap ArgumentError yang dilempar dari dalam setter
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Gagal memutasi nilai (Validasi Setter): $e'),
          backgroundColor: AppColors.accentRose,
        ),
      );
    }
  }

  /// Function 7: Menghapus item dari list
  void deleteEvaluation(int indexInFullList) {
    final deleted = _evaluasiList.removeAt(indexInFullList);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🗑️ Evaluasi proyek [${deleted.projectId}] dihapus.'),
        backgroundColor: AppColors.glassBorder,
      ),
    );
  }

  // ===========================================================================
  // BUILD METHOD UTAMA
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    final filteredList = filterEvaluasiList();
    final avgScore = calculateAverageNilaiAkhir(_evaluasiList);
    final passRate = calculatePersentaseKelulusan(_evaluasiList);

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Banner Ringkasan Statistik Nilai PBO
          _buildMetricsSummaryBar(avgScore, passRate),

          // Tab Pilihan: Live ListBuilder vs Kode Sumber PBO
          _buildTabSelector(),

          // Konten Utama
          Expanded(
            child: _activeTabIndex == 0
                ? _buildListBuilderContent(filteredList)
                : _buildSourceCodeInspector(),
          ),
        ],
      ),
      floatingActionButton: _activeTabIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => _showAddProjectDialog(context),
              backgroundColor: const Color(0xFF00A3FF),
              icon: const Icon(Icons.add_task_rounded, color: Colors.white),
              label: const Text(
                'Tambah Evaluasi',
                style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
              ),
            )
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.bgSurface.withOpacity(0.9),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
        tooltip: 'Kembali ke Portofolio',
      ),
      title: const Row(
        children: [
          Icon(Icons.terminal_rounded, color: Color(0xFF00A3FF), size: 22),
          SizedBox(width: 10),
          Text(
            'Laboratorium PBO: ListBuilder, Function & Setter-Getter',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: AppColors.textMuted),
          tooltip: 'Reset Data ke Awal (Function Test)',
          onPressed: () {
            setState(() {
              _initDefaultDataset();
              _searchQuery = '';
              _onlyPassedFilter = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Dataset berhasil di-reset ulang via Function.')),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildMetricsSummaryBar(double avgScore, double passRate) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bgSurface.withOpacity(0.6),
        border: const Border(bottom: BorderSide(color: AppColors.glassBorder)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildStatItem('Total Proyek', '${_evaluasiList.length}', Icons.folder_special_rounded, const Color(0xFF00A3FF)),
            const SizedBox(width: 14),
            _buildStatItem('Rata-rata Nilai', avgScore.toStringAsFixed(1), Icons.analytics_rounded, const Color(0xFF10B981)),
            const SizedBox(width: 14),
            _buildStatItem('Tingkat Lulus', '${passRate.toStringAsFixed(0)}%', Icons.verified_rounded, AppColors.secondary),
            const SizedBox(width: 20),
            // Filter Switch
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Hanya Lulus (Getter .isLulus):',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                const SizedBox(width: 6),
                Switch(
                  value: _onlyPassedFilter,
                  activeColor: const Color(0xFF00A3FF),
                  onChanged: (val) => setState(() => _onlyPassedFilter = val),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
              Text(
                value,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      color: Colors.black.withOpacity(0.2),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildTabButton(
              title: '1. Antarmuka Dinamis (ListView.builder)',
              index: 0,
              icon: Icons.view_list_rounded,
            ),
            const SizedBox(width: 12),
            _buildTabButton(
              title: '2. Kode Sumber PBO (ListBuilder, Function, Setter/Getter)',
              index: 1,
              icon: Icons.code_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton({required String title, required int index, required IconData icon}) {
    final isSelected = _activeTabIndex == index;
    return InkWell(
      onTap: () => setState(() => _activeTabIndex = index),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00A3FF).withOpacity(0.25) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF00A3FF) : AppColors.glassBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: isSelected ? const Color(0xFF00A3FF) : AppColors.textMuted),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // FITUR 1: LISTVIEW.BUILDER (LISTBUILDER IMPLEMENTATION)
  // ===========================================================================
  Widget _buildListBuilderContent(List<ProjectEvaluationModel> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded, size: 54, color: AppColors.textMuted),
            const SizedBox(height: 12),
            const Text(
              'Tidak ada evaluasi proyek yang cocok.',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => setState(() {
                _searchQuery = '';
                _onlyPassedFilter = false;
              }),
              child: const Text('Reset Filter Pencarian'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final fullIndex = _evaluasiList.indexOf(item);
        return _buildProjectEvaluationCard(item, fullIndex);
      },
    );
  }

  Widget _buildProjectEvaluationCard(ProjectEvaluationModel item, int fullIndex) {
    // FITUR 3: PENGGUNAAN GETTER DALAM UI
    final projectId = item.projectId;                         // Getter: String get projectId
    final title = item.projectTitle;                         // Getter: String get projectTitle
    final evaluator = item.evaluatorName;                     // Getter: String get evaluatorName
    final skorPbo = item.skorArsitekturPbo;                   // Getter: double get skorArsitekturPbo
    final skorEnkap = item.skorEnkapsulasi;                   // Getter: double get skorEnkapsulasi
    final skorPoli = item.skorPolimorfisme;                   // Getter: double get skorPolimorfisme
    final skorUi = item.skorAntarmukaUi;                     // Getter: double get skorAntarmukaUi
    final naFormatted = item.nilaiAkhirFormatted;             // Computed Getter: String get nilaiAkhirFormatted
    final grade = item.hurufMutu;                             // Computed Getter: String get hurufMutu
    final isLulus = item.isLulus;                             // Computed Getter: bool get isLulus
    final catatan = item.catatanEvaluasi;                     // Getter: String get catatanEvaluasi
    final statusColor = isLulus ? const Color(0xFF10B981) : AppColors.accentRose;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLulus ? const Color(0xFF00A3FF).withOpacity(0.35) : AppColors.accentRose.withOpacity(0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris Atas: ID Proyek, Status Kelulusan, & Badge Nilai Akhir
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A3FF).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.5)),
                  ),
                  child: Text(
                    projectId,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF00A3FF),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: statusColor.withOpacity(0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(isLulus ? Icons.check_circle : Icons.warning_amber_rounded, size: 14, color: statusColor),
                      const SizedBox(width: 5),
                      Text(
                        'NA: $naFormatted ($grade)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Text(
              'Evaluator: $evaluator',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),

            const SizedBox(height: 14),

            // Indikator 4 Skor Rubrik PBO (Diambil via Getter)
            Row(
              children: [
                Expanded(child: _buildRubrikScoreIndicator('PBO Arsitektur (35%)', skorPbo)),
                const SizedBox(width: 8),
                Expanded(child: _buildRubrikScoreIndicator('Enkapsulasi (25%)', skorEnkap)),
                const SizedBox(width: 8),
                Expanded(child: _buildRubrikScoreIndicator('Polimorfisme (20%)', skorPoli)),
                const SizedBox(width: 8),
                Expanded(child: _buildRubrikScoreIndicator('UI Flutter (20%)', skorUi)),
              ],
            ),

            const SizedBox(height: 14),

            // Catatan Evaluasi (Getter .catatanEvaluasi)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Text(
                'Catatan: "$catatan"',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
              ),
            ),

            const SizedBox(height: 14),

            // Tombol Aksi: Uji Setter, Cetak Laporan (Function), & Hapus
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _showAuditReportDialog(item),
                  icon: const Icon(Icons.description_rounded, size: 15, color: Color(0xFF00A3FF)),
                  label: const Text('Cetak Laporan', style: TextStyle(color: Color(0xFF00A3FF), fontSize: 12)),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _showEditScoreSetterDialog(item),
                  icon: const Icon(Icons.tune_rounded, size: 15),
                  label: const Text('Uji Setter Skor', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A3FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => deleteEvaluation(fullIndex),
                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.accentRose),
                  tooltip: 'Hapus Item (Function deleteEvaluation)',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRubrikScoreIndicator(String label, double score) {
    final percent = (score / 100.0).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                label,
                style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              score.toStringAsFixed(1),
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 5,
            backgroundColor: Colors.white.withOpacity(0.08),
            valueColor: AlwaysStoppedAnimation<Color>(
              score >= 80 ? const Color(0xFF10B981) : (score >= 70 ? const Color(0xFF00A3FF) : AppColors.accentRose),
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // DIALOG UJI FITUR 3: SETTER DENGAN VALIDASI ENKAPSULASI
  // ===========================================================================
  void _showEditScoreSetterDialog(ProjectEvaluationModel item) {
    double pbo = item.skorArsitekturPbo;
    double enkap = item.skorEnkapsulasi;
    double poli = item.skorPolimorfisme;
    double ui = item.skorAntarmukaUi;
    final catatanController = TextEditingController(text: item.catatanEvaluasi);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          // Preview computed getter secara real-time
          final tempModel = ProjectEvaluationModel(
            projectId: item.projectId,
            projectTitle: item.projectTitle,
            evaluatorName: item.evaluatorName,
            skorArsitekturPbo: pbo,
            skorEnkapsulasi: enkap,
            skorPolimorfisme: poli,
            skorAntarmukaUi: ui,
          );

          return AlertDialog(
            backgroundColor: AppColors.bgSurface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                const Icon(Icons.tune_rounded, color: Color(0xFF00A3FF), size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Uji Setter Nilai [${item.projectId}]',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: 480,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ubah slider di bawah untuk menguji mutasi nilai melalui Setter PBO. '
                      'Setter akan memvalidasi rentang angka 0.0 - 100.0.',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 16),

                    _buildSliderSetter('Skor PBO (Bobot 35%)', pbo, (v) => setModalState(() => pbo = v)),
                    _buildSliderSetter('Skor Enkapsulasi (Bobot 25%)', enkap, (v) => setModalState(() => enkap = v)),
                    _buildSliderSetter('Skor Polimorfisme (Bobot 20%)', poli, (v) => setModalState(() => poli = v)),
                    _buildSliderSetter('Skor UI Flutter (Bobot 20%)', ui, (v) => setModalState(() => ui = v)),

                    const SizedBox(height: 10),
                    TextField(
                      controller: catatanController,
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Catatan Evaluasi (Setter catatanEvaluasi)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 16),
                    // Live Computed Getter Preview
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A3FF).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hasil Computed Getter .nilaiAkhir:',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${tempModel.nilaiAkhirFormatted} • ${tempModel.hurufMutu}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: tempModel.isLulus ? const Color(0xFF10B981) : AppColors.accentRose,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  // Memanggil Function pemutasi setter
                  updateSkorWithSetter(
                    item,
                    skorPbo: pbo,
                    skorEnkap: enkap,
                    skorPoli: poli,
                    skorUi: ui,
                    catatan: catatanController.text,
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00A3FF)),
                child: const Text('Terapkan via Setter'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliderSetter(String label, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
            Text(
              value.toStringAsFixed(1),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF00A3FF)),
            ),
          ],
        ),
        Slider(
          value: value,
          min: 0.0,
          max: 100.0,
          divisions: 100,
          activeColor: const Color(0xFF00A3FF),
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _showAddProjectDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final evalCtrl = TextEditingController(text: 'Dosen Penguji PBO');
    double pbo = 90.0;
    double enkap = 90.0;
    double poli = 85.0;
    double ui = 88.0;
    final catCtrl = TextEditingController(text: 'Evaluasi proyek mahasiswa dengan standar PBO.');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          backgroundColor: AppColors.bgSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Tambah Evaluasi Proyek Baru (PBO)', style: TextStyle(fontWeight: FontWeight.w800)),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 440,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Judul Proyek',
                      hintText: 'Contoh: Sistem Inventaris Toko PBO',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: evalCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Nama Evaluator / Dosen'),
                  ),
                  const SizedBox(height: 12),
                  _buildSliderSetter('Skor PBO', pbo, (v) => setModalState(() => pbo = v)),
                  _buildSliderSetter('Skor Enkapsulasi', enkap, (v) => setModalState(() => enkap = v)),
                  _buildSliderSetter('Skor Polimorfisme', poli, (v) => setModalState(() => poli = v)),
                  _buildSliderSetter('Skor UI', ui, (v) => setModalState(() => ui = v)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: catCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Catatan Evaluasi'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty) return;
                Navigator.pop(ctx);
                // Memanggil Function addNewEvaluation
                addNewEvaluation(
                  title: titleCtrl.text.trim(),
                  evaluator: evalCtrl.text.trim(),
                  skorPbo: pbo,
                  skorEnkap: enkap,
                  skorPoli: poli,
                  skorUi: ui,
                  catatan: catCtrl.text.trim(),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00A3FF)),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAuditReportDialog(ProjectEvaluationModel item) {
    // Memanggil Function / Method: generateLaporanRingkas()
    final report = item.generateLaporanRingkas();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Laporan Hasil Audit [${item.projectId}]', style: const TextStyle(fontWeight: FontWeight.w700)),
        content: Container(
          width: 500,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: SingleChildScrollView(
            child: Text(
              report,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Color(0xFF00A3FF),
                height: 1.4,
              ),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00A3FF)),
            child: const Text('Tutup Laporan'),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // INSPEKTUR KODE SUMBER PBO (DOKUMENTASI KODINGAN UNTUK DOSEN / PENGUJI)
  // ===========================================================================
  Widget _buildSourceCodeInspector() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildCodeCard(
          title: 'FITUR 1: ListView.builder (ListBuilder)',
          description: 'Membangun daftar evaluasi proyek secara efisien dan dinamis berdasarkan panjang koleksi list.',
          code: '''
// Contoh Implementasi ListView.builder pada PboLabPage:
ListView.builder(
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  itemCount: items.length, // Menentukan jumlah baris dinamis
  itemBuilder: (context, index) {
    final item = items[index];
    // Membaca data item menggunakan Getter
    return _buildProjectEvaluationCard(item, index);
  },
);
''',
        ),
        const SizedBox(height: 16),
        _buildCodeCard(
          title: 'FITUR 2: Functions (Fungsi & Metode Perhitungan)',
          description: 'Fungsi kalkulasi rata-rata nilai kelas, kalkulasi tingkat kelulusan, dan filtering data.',
          code: '''
// Function: Menghitung rata-rata nilai akhir
double calculateAverageNilaiAkhir(List<ProjectEvaluationModel> items) {
  if (items.isEmpty) return 0.0;
  final total = items.fold(0.0, (sum, item) => sum + item.nilaiAkhir);
  return total / items.length;
}

// Function: Menghitung persentase kelulusan dengan Getter .isLulus
double calculatePersentaseKelulusan(List<ProjectEvaluationModel> items) {
  if (items.isEmpty) return 0.0;
  final lulusCount = items.where((item) => item.isLulus).length;
  return (lulusCount / items.length) * 100.0;
}
''',
        ),
        const SizedBox(height: 16),
        _buildCodeCard(
          title: 'FITUR 3: Setter & Getter (Enkapsulasi Private Field)',
          description: 'Private fields (_skor, _catatan) terlindungi dan hanya bisa diakses via Getter serta dimutasi dengan Setter tervalidasi.',
          code: '''
class ProjectEvaluationModel {
  // 1. Private Fields Terenkapsulasi
  double _skorArsitekturPbo;
  double _skorEnkapsulasi;

  // 2. Getter (Read Access & Computed Property)
  double get skorArsitekturPbo => _skorArsitekturPbo;
  
  double get nilaiAkhir {
    // Computed Getter: Perhitungan berbobot otomatis
    return (_skorArsitekturPbo * 0.35) + (_skorEnkapsulasi * 0.25) + ...;
  }
  
  bool get isLulus => nilaiAkhir >= 70.0;

  // 3. Setter (Write Access dengan Validasi Logika Bisnis)
  set skorArsitekturPbo(double value) {
    if (value < 0.0 || value > 100.0) {
      throw ArgumentError('Nilai harus di rentang 0.0 - 100.0');
    }
    _skorArsitekturPbo = value; // Berhasil dimutasi
  }
}
''',
        ),
      ],
    );
  }

  Widget _buildCodeCard({required String title, required String description, required String code}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF00A3FF))),
            const SizedBox(height: 4),
            Text(description, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.65),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: SelectableText(
                code,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11.5,
                  color: Color(0xFF38BDF8),
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
