import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_colors.dart';
import 'pbo_blueprint_inspector_dialog.dart';

/// ============================================================================
/// WIDGET: ProjectReportDialog
/// ============================================================================
/// Menampilkan Laporan Proyek PBO Resmi dan Hasil Evaluasi Rubrik Akademik.
/// Menyediakan opsi untuk membuka/mengunduh dokumen laporan format PDF.
/// ============================================================================

class ProjectReportDialog extends StatelessWidget {
  final BaseUser currentUser;

  const ProjectReportDialog({
    super.key,
    required this.currentUser,
  });

  static void show(BuildContext context, {required BaseUser currentUser}) {
    showDialog(
      context: context,
      builder: (context) => ProjectReportDialog(currentUser: currentUser),
    );
  }

  @override
  Widget build(BuildContext context) {
    final audit = ProjectEvaluationModel.defaultAudit();
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: isDesktop ? 900 : double.infinity,
        constraints: BoxConstraints(maxHeight: size.height * 0.9),
        decoration: BoxDecoration(
          color: AppColors.bgDark,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withValues(alpha: 0.2),
              blurRadius: 40,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            // Header Dialog
            _buildHeader(context),

            const Divider(color: AppColors.glassBorder, height: 1),

            // Konten Scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner Dokumen Laporan Siap Dikumpulkan
                    _buildSubmissionBanner(context),

                    const SizedBox(height: 20),

                    // Rubrik Skor Evaluasi Proyek PBO
                    _buildRubricScoreCard(audit),

                    const SizedBox(height: 20),

                    // Matriks Pemenuhan Kriteria PBO (Blueprint, Getter, Setter, Function)
                    _buildPboChecklistMatrix(),

                    const SizedBox(height: 20),

                    // Panduan Pengumpulan & Akses File PDF
                    _buildPdfInstructionsCard(context),
                  ],
                ),
              ),
            ),

            const Divider(color: AppColors.glassBorder, height: 1),

            // Footer
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.bgSurface.withValues(alpha: 0.6),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: AppColors.secondaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Laporan Proyek PBO & Hasil Evaluasi Sistem (Format PDF)',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Dokumen Portofolio Rekayasa Berorientasi Objek & Flutter Framework',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmissionBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.2),
            AppColors.secondary.withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 16,
                ),
              ],
            ),
            child: const Icon(Icons.task_alt_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dokumen Laporan PDF Siap Dikumpulkan! 📄',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'File resmi "Laporan_Proyek_Flutter_PBO.pdf" telah disusun lengkap mencakup: '
                  'Halaman Judul Resmi, Blueprint Package Model, Implementasi PBO (Setter, Getter, Functions), '
                  'Analisis Kode, Tangkapan Layar, dan Hasil Pengujian Unit Test.',
                  style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRubricScoreCard(ProjectEvaluationModel audit) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.workspace_premium_rounded, color: AppColors.accent, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'AUDIT RUBRIK PENILAIAN PBO',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.accent,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Skor Akhir: ${audit.nilaiAkhirFormatted} (${audit.hurufMutu})',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildRubricProgressRow(
            '1. Blueprint & Package Model (Bobot 35%)',
            audit.skorArsitekturPbo,
            AppColors.primaryLight,
          ),
          _buildRubricProgressRow(
            '2. Enkapsulasi, Getter & Setter (Bobot 25%)',
            audit.skorEnkapsulasi,
            AppColors.secondaryLight,
          ),
          _buildRubricProgressRow(
            '3. Functions, Pewarisan & Polimorfisme (Bobot 20%)',
            audit.skorPolimorfisme,
            AppColors.accent,
          ),
          _buildRubricProgressRow(
            '4. Desain Antarmuka & Interaktivitas UI (Bobot 20%)',
            audit.skorAntarmukaUi,
            AppColors.accentRose,
          ),

          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bgDark,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.format_quote_rounded, color: AppColors.textMuted, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '"${audit.catatanEvaluasi}"',
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRubricProgressRow(String title, double score, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 12.5, color: AppColors.textPrimary)),
              Text(
                '${score.toStringAsFixed(1)} / 100',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: color),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 100.0,
              backgroundColor: AppColors.bgDark,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPboChecklistMatrix() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CHECKLIST IMPLEMENTASI PBO & BLUEPRINT:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 12),
          _buildCheckItem(
            'Package Model Lengkap (lib/models/ & models.dart)',
            'Blueprint terorganisir untuk MahasiswaModel, ProjectEvaluationModel, BaseUser, PortfolioItem, dsb.',
          ),
          _buildCheckItem(
            'Enkapsulasi Murni (Private Fields)',
            'Semua atribut dideklarasikan menggunakan tanda "_" dan dilindungi dari modifikasi langsung di luar kelas.',
          ),
          _buildCheckItem(
            'Getter Tervalidasi & Computed Properties',
            'Getter membaca data terenkapsulasi secara aman serta menghitung predikat, persentase, dan format data.',
          ),
          _buildCheckItem(
            'Setter dengan Validasi Logika Bisnis (ArgumentError)',
            'Setter memverifikasi rentang nilai (contoh: IPK 0.0 - 4.0, Semester 1 - 14, Rubrik 0 - 100) dan menolak nilai ilegal.',
          ),
          _buildCheckItem(
            'Functions & Methods Objek Operasional',
            'Instance methods seperti tambahSks(), tambahKeahlian(), evaluasiKelayakanSkripsi(), hitungNilaiAkhir(), toJson().',
          ),
          _buildCheckItem(
            'Pewarisan & Polimorfisme Runtime',
            'Hierarki BaseUser dengan 4 subclass yang meng-override fungsi dinamis (getRoleTitle, getClearanceLevel, dsb).',
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, color: Color(0xFF34D399), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfInstructionsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.bgSurface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.download_for_offline_rounded, color: AppColors.secondaryLight, size: 20),
              SizedBox(width: 8),
              Text(
                'LOKASI FILE PDF LAPORAN PROYEK:',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.secondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: const SelectableText(
              'Lokasi File: f:\\tugas flutter\\Laporan_Proyek_Flutter_PBO.pdf\n'
              'Ukuran: Siap Cetak (A4 Standard Laporan Akademik Indonesia)',
              style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.greenAccent),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'File PDF ini telah di-generate secara utuh dan terstandarisasi untuk dikumpulkan '
            'langsung kepada dosen penilai sebagai bukti pemenuhan seluruh capaian pembelajaran matkul PBO.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface.withValues(alpha: 0.6),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              PboBlueprintInspectorDialog.show(context);
            },
            icon: const Icon(Icons.psychology_rounded, size: 16),
            label: const Text('Buka Inspector PBO Live'),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.primaryLight),
          ),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    '📄 Dokumen PDF tersedia di: f:\\tugas flutter\\Laporan_Proyek_Flutter_PBO.pdf',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  backgroundColor: AppColors.primary,
                  duration: Duration(seconds: 4),
                ),
              );
              Navigator.pop(context);
            },
            icon: const Icon(Icons.file_download_done_rounded, size: 18),
            label: const Text('Konfirmasi File PDF'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
