import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

/// Model Data Sertifikat Prestasi & Kompetensi
class CertificateItem {
  final String id;
  final String title;
  final String issuer;
  final String credentialId;
  final String issueDate;
  final String imageAsset;
  final String category;
  final Color accentColor;
  final List<String> skills;
  final String description;

  const CertificateItem({
    required this.id,
    required this.title,
    required this.issuer,
    required this.credentialId,
    required this.issueDate,
    required this.imageAsset,
    required this.category,
    required this.accentColor,
    required this.skills,
    required this.description,
  });
}

/// Widget Showcase Galeri Sertifikat Menggunakan ListView.builder dengan Animasi 3D Tilt
class CertificateShowcaseSection extends StatefulWidget {
  const CertificateShowcaseSection({super.key});

  @override
  State<CertificateShowcaseSection> createState() => _CertificateShowcaseSectionState();
}

class _CertificateShowcaseSectionState extends State<CertificateShowcaseSection> {
  final ScrollController _horizontalScrollController = ScrollController();
  String _selectedFilter = 'Semua';

  static const List<CertificateItem> _certificates = [
    CertificateItem(
      id: 'cert-flutter',
      title: 'Flutter & Dart Mobile App Development',
      issuer: 'Google & Accredited Tech Academy',
      credentialId: 'FD-AF-2024-9371',
      issueDate: '15 Februari 2024',
      imageAsset: 'assets/images/certificate_flutter.jpg',
      category: 'Mobile Dev',
      accentColor: AppColors.secondary,
      skills: ['Flutter SDK', 'Dart OOP', 'State Management', 'Firebase Integration'],
      description:
          'Sertifikasi kelulusan terakreditasi dalam pengembangan aplikasi mobile profesional lintas platform '
          'menggunakan Flutter & Dart dengan spesialisasi arsitektur bersih dan UI modern.',
    ),
    CertificateItem(
      id: 'cert-pbo',
      title: 'Certificate of Excellence: OOP & Software Architecture',
      issuer: 'Universitas Global Teknologi - Faculty of Computer Science',
      credentialId: 'UGT-PBO-EXC-2023-AF',
      issueDate: '12 Oktober 2023',
      imageAsset: 'assets/images/certificate_pbo.jpg',
      category: 'PBO & Arsitektur',
      accentColor: AppColors.primaryLight,
      skills: ['Enkapsulasi', 'Inheritance', 'Polimorfisme Dinamis', 'SOLID Principles'],
      description:
          'Penghargaan akademik tertinggi atas penguasaan mendalam prinsip Pemrograman Berorientasi Objek (PBO), '
          'implementasi enkapsulasi mutasi tervalidasi, serta desain perangkat lunak skalabel.',
    ),
    CertificateItem(
      id: 'cert-mobile',
      title: 'Advanced Mobile UI/UX & Cloud Engineering',
      issuer: 'Global Tech Institute',
      credentialId: 'AFU20230001AMUCE',
      issueDate: '24 Oktober 2023',
      imageAsset: 'assets/images/certificate_mobile.jpg',
      category: 'UI/UX & Cloud',
      accentColor: AppColors.accent,
      skills: ['Responsive UI', 'Modern UX', 'Cloud Deployment', 'Optimization'],
      description:
          'Sertifikasi kompetensi rekayasa antarmuka pengguna interaktif (UI/UX) digital tingkat lanjut '
          'dan integrasi infrastruktur komputasi awan (Cloud Native) untuk aplikasi mobile.',
    ),
  ];

  List<CertificateItem> get _filteredCertificates {
    if (_selectedFilter == 'Semua') return _certificates;
    return _certificates.where((c) => c.category == _selectedFilter).toList();
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _scroll(double offsetDelta) {
    if (!_horizontalScrollController.hasClients) return;
    final target = (_horizontalScrollController.offset + offsetDelta)
        .clamp(0.0, _horizontalScrollController.position.maxScrollExtent);
    _horizontalScrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  void _showCertificateLightbox(BuildContext context, CertificateItem cert) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (ctx) => _CertificateLightboxDialog(certificate: cert),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['Semua', 'Mobile Dev', 'PBO & Arsitektur', 'UI/UX & Cloud'];
    final list = _filteredCertificates;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface.withOpacity(0.85),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.primary.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.12),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section dengan Kontrol Scroll Panah
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SERTIFIKASI & PENGHARGAAN KOMPETENSI',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.secondary,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Kredensial Profesional & Prestasi Terverifikasi',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                    ),
                  ],
                ),
              ),

              // Kontrol Tombol Scroll Kiri & Kanan untuk ListView
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _scroll(-380),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                    tooltip: 'Geser ke Kiri',
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.bgDark,
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.glassBorder),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _scroll(380),
                    icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    tooltip: 'Geser ke Kanan',
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.bgDark,
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.glassBorder),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Text(
            'Dokumen sertifikasi resmi dalam format ListView.builder interaktif. '
            'Gerakkan pointer di atas sertifikat untuk melihat efek perspektif 3D Tilt dan klik untuk memperbesar HD.',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.6),
          ),

          const SizedBox(height: 20),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((cat) {
                final isSelected = _selectedFilter == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() => _selectedFilter = cat);
                    },
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.bgDark,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 12.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AppColors.primaryLight : AppColors.glassBorder,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // IMPLEMENTASI LISTVIEW.BUILDER UNTUK SERTIFIKAT
          SizedBox(
            height: 480,
            child: list.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada sertifikat dalam kategori ini.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : ListView.builder(
                    controller: _horizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final cert = list[index];
                      return Container(
                        width: 360,
                        margin: EdgeInsets.only(
                          right: index == list.length - 1 ? 0 : 20,
                          top: 8,
                          bottom: 8,
                        ),
                        child: _buildCertificateCard(context, cert),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateCard(BuildContext context, CertificateItem cert) {
    return _CertificateHoverCard(
      accentColor: cert.accentColor,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgDark.withOpacity(0.85),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: cert.accentColor.withOpacity(0.4), width: 1.3),
          boxShadow: [
            BoxShadow(
              color: cert.accentColor.withOpacity(0.12),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview Gambar Sertifikat
            InkWell(
              onTap: () => _showCertificateLightbox(context, cert),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 10,
                    child: Image.asset(
                      cert.imageAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        color: AppColors.bgSurface,
                        child: Center(
                          child: Icon(Icons.broken_image_rounded, color: cert.accentColor, size: 40),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black.withOpacity(0.75),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: cert.accentColor.withOpacity(0.6)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified_rounded, color: cert.accentColor, size: 13),
                          const SizedBox(width: 5),
                          Text(
                            cert.category,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: cert.accentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: cert.accentColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.zoom_in_rounded, color: Colors.black, size: 15),
                          SizedBox(width: 4),
                          Text(
                            'Zoom HD',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Konten Detail Sertifikat
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cert.title,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cert.issuer,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: cert.accentColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        cert.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.45,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(color: AppColors.glassBorder, height: 1),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'NO. KREDENSIAL',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textMuted,
                                  letterSpacing: 0.6,
                                ),
                              ),
                              Text(
                                cert.credentialId,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontFamily: 'monospace',
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () => _showCertificateLightbox(context, cert),
                          icon: const Icon(Icons.fullscreen_rounded, size: 15),
                          label: const Text('Dokumen'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cert.accentColor,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: const Size(0, 34),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu Sertifikat Elegan dengan Transisi Hover Halus (Non-3D Tilt)
class _CertificateHoverCard extends StatefulWidget {
  final Color accentColor;
  final Widget child;

  const _CertificateHoverCard({
    required this.accentColor,
    required this.child,
  });

  @override
  State<_CertificateHoverCard> createState() => _CertificateHoverCardState();
}

class _CertificateHoverCardState extends State<_CertificateHoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -5.0 : 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: widget.accentColor.withOpacity(_isHovered ? 0.28 : 0.0),
              blurRadius: _isHovered ? 26 : 0,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}

/// Dialog Lightbox Fullscreen untuk Inspeksi Sertifikat Resolusi Tinggi
class _CertificateLightboxDialog extends StatelessWidget {
  final CertificateItem certificate;

  const _CertificateLightboxDialog({required this.certificate});

  void _copyCredentialId(BuildContext context) {
    Clipboard.setData(ClipboardData(text: certificate.credentialId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ID Kredensial (${certificate.credentialId}) berhasil disalin!'),
        backgroundColor: certificate.accentColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960, maxHeight: 780),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: certificate.accentColor.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: certificate.accentColor.withOpacity(0.2),
                  blurRadius: 40,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Dialog
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    border: Border(bottom: BorderSide(color: AppColors.glassBorder.withOpacity(0.5))),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.workspace_premium_rounded, color: certificate.accentColor, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          certificate.title,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded, color: Colors.white70),
                        tooltip: 'Tutup',
                      ),
                    ],
                  ),
                ),

                // Tampilan Gambar Sertifikat
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            certificate.imageAsset,
                            fit: BoxFit.contain,
                            errorBuilder: (ctx, err, stack) => Container(
                              height: 300,
                              color: AppColors.bgSurface,
                              child: const Center(
                                child: Text('Gambar sertifikat gagal dimuat',
                                    style: TextStyle(color: Colors.white70)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Informasi Kredensial & Verifikasi
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.bgSurface.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: certificate.accentColor.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: certificate.accentColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: certificate.accentColor),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.verified_rounded, size: 14, color: certificate.accentColor),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Kredensial Terverifikasi Asli',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w700,
                                            color: certificate.accentColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Diterbitkan: ${certificate.issueDate}',
                                    style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                certificate.description,
                                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'ID Kredensial: ${certificate.credentialId}',
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () => _copyCredentialId(context),
                                    icon: const Icon(Icons.copy_rounded, size: 15),
                                    label: const Text('Salin ID'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: certificate.accentColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
