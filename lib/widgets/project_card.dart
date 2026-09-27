import 'package:flutter/material.dart';
import '../models/portfolio_item.dart';
import '../theme/app_colors.dart';

/// Kartu Proyek Minimalis Elegan dengan Transisi Hover Halus (Non-3D Tilt)
/// Menampilkan: Nama Project, Deskripsi Project, Output Project, dan Bahasa Pemrograman yang dipakai.
class ProjectCard extends StatefulWidget {
  final PortfolioItem item;
  final int index;

  const ProjectCard({
    super.key,
    required this.item,
    required this.index,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

  String _getProjectOutput(PortfolioItem item) {
    if (item.id == 'pbo-01') {
      return 'Aplikasi Simulasi Akun Game Multi-Genre & Hirarki Polimorfisme';
    } else if (item.id == 'pbo-02') {
      return 'Engine Transaksi Perbankan OOP Terenkapsulasi & Proteksi Mutasi Saldo';
    } else if (item.id == 'app-01') {
      return 'Aplikasi Mobile Android/iOS & Web Dashboard Task Manager Terintegrasi Cloud';
    } else if (item.id == 'app-02') {
      return 'Web Service API & Portal Evaluasi Kinerja Akademik Mahasiswa';
    }
    return 'Aplikasi Sistem Perangkat Lunak Terintegrasi';
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.item.getCategoryColor();
    final outputText = _getProjectOutput(widget.item);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -5.0 : 0.0),
        decoration: BoxDecoration(
          color: AppColors.bgSurface.withOpacity(0.85),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered ? color : color.withOpacity(0.35),
            width: _isHovered ? 1.6 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(_isHovered ? 0.25 : 0.08),
              blurRadius: _isHovered ? 26 : 16,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris Atas: Indeks Proyek & Badge Kategori
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withOpacity(0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(widget.item.getItemIcon(), size: 14, color: color),
                      const SizedBox(width: 6),
                      Text(
                        'Proyek #${widget.index + 1}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: color,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  widget.item.dateCreated,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 1. NAMA PROJECT
            Text(
              widget.item.title,
              style: const TextStyle(
                fontSize: 18.5,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 10),

            // 2. DESKRIPSI PROJECT
            Text(
              widget.item.shortDescription,
              style: const TextStyle(
                fontSize: 13.5,
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),

            const SizedBox(height: 16),

            // 3. OUTPUT PROJECT
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgDark.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(Icons.check_circle_rounded, color: AppColors.secondary, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'OUTPUT PROYEK:',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.secondary,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          outputText,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 4. BAHASA PEMROGRAMAN & TECH STACK
            const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.code_rounded, size: 14, color: AppColors.textMuted),
                SizedBox(width: 6),
                Text(
                  'Bahasa & Teknologi:',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.item.techStack.map((tech) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Text(
                    tech,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
