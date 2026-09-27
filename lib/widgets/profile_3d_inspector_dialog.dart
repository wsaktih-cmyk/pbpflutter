import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';

/// Dialog Inspeksi Profil 3D Interaktif & Laboratorium Hologram PBO
class Profile3DInspectorDialog extends StatefulWidget {
  final String? initialSkin;

  const Profile3DInspectorDialog({
    super.key,
    this.initialSkin,
  });

  static Future<void> show(BuildContext context, {String? initialSkin}) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Tutup Inspeksi 3D',
      barrierColor: Colors.black.withOpacity(0.85),
      transitionDuration: const Duration(milliseconds: 350),
      transitionBuilder: (context, anim1, anim2, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12 * anim1.value, sigmaY: 12 * anim1.value),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(
              CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
            ),
            child: FadeTransition(opacity: anim1, child: child),
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) =>
          Profile3DInspectorDialog(initialSkin: initialSkin),
    );
  }

  @override
  State<Profile3DInspectorDialog> createState() => _Profile3DInspectorDialogState();
}

class _Profile3DInspectorDialogState extends State<Profile3DInspectorDialog>
    with TickerProviderStateMixin {
  // Animasi Auto-Spin & Hologram Idle
  late AnimationController _idleController;
  late AnimationController _scanlineController;

  // Nilai rotasi 3D interaktif
  double _rotX = 0.0;
  double _rotY = 0.0;
  double _rotZ = 0.0;
  final double _perspectiveDepth = 0.0018;
  double _zoomScale = 1.0;

  bool _isAutoSpin = true;
  bool _showScanlines = true;
  bool _showGyroscope = true;
  bool _showOrbitParticles = true;

  // Skin: '3d_dev', 'hologram', 'classic'
  late String _currentSkin;

  // Mock student data untuk telemetry
  late MahasiswaModel _studentData;

  @override
  void initState() {
    super.initState();
    _currentSkin = widget.initialSkin ?? '3d_dev';
    _studentData = MahasiswaModel.defaultStudent();

    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        if (_isAutoSpin) {
          setState(() {
            _rotY = _idleController.value * 2 * pi;
            _rotX = sin(_idleController.value * 2 * pi) * 0.22;
          });
        }
      });
    _idleController.repeat();

    _scanlineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _idleController.dispose();
    _scanlineController.dispose();
    super.dispose();
  }

  void _resetOrientation() {
    setState(() {
      _rotX = 0.0;
      _rotY = 0.0;
      _rotZ = 0.0;
      _zoomScale = 1.0;
      _isAutoSpin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 960;
    final currentUser = AuthService().currentUser;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: isDesktop ? 1040 : size.width * 0.94,
          height: isDesktop ? 680 : size.height * 0.90,
          decoration: BoxDecoration(
            color: AppColors.bgSurface.withOpacity(0.95),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.secondary.withOpacity(0.4), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withOpacity(0.2),
                blurRadius: 40,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.7),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Top Bar Sci-Fi Header
              _buildHeader(context),

              // Main Content (Split view on Desktop, Tab/Scroll on Mobile)
              Expanded(
                child: isDesktop
                    ? Row(
                        children: [
                          // Kiri: 3D Viewport & Interactive Orbit Canvas
                          Expanded(flex: 6, child: _build3DViewport()),

                          // Garis Pemisah Vertikal Neon
                          Container(
                            width: 1,
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  AppColors.secondary.withOpacity(0.5),
                                  AppColors.primary.withOpacity(0.5),
                                  Colors.transparent,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),

                          // Kanan: Telemetri PBO, Pengaturan 3D & Skin
                          Expanded(
                            flex: 5,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(24),
                              child: _buildTelemetryAndControls(currentUser),
                            ),
                          ),
                        ],
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 380, child: _build3DViewport()),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: _buildTelemetryAndControls(currentUser),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Top Bar Header Hologram
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.bgDark.withOpacity(0.7),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(bottom: BorderSide(color: AppColors.glassBorder.withOpacity(0.6))),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.view_in_ar_rounded, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '3D HOLOGRAPHIC PROFILE ARCHITECT',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.secondary,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(width: 8),
                    _LivePillBadge(),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  'Visualisasi Spasial Objek Mahasiswa & Matriks PBO 3D Realtime',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
            tooltip: 'Tutup Inspeksi 3D',
          ),
        ],
      ),
    );
  }

  /// Viewport 3D Interaktif dengan Trackball Drag & Multi-plane Parallax
  Widget _build3DViewport() {
    return GestureDetector(
      onPanStart: (_) {
        if (_isAutoSpin) {
          setState(() => _isAutoSpin = false);
        }
      },
      onPanUpdate: (details) {
        setState(() {
          _rotY += details.delta.dx * 0.012;
          _rotX -= details.delta.dy * 0.012;
          // Batasi rotasi pitch agar tidak terbalik ekstrim
          _rotX = _rotX.clamp(-pi * 0.45, pi * 0.45);
        });
      },
      child: Container(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. Grid Background Matrix Sci-Fi
            Positioned.fill(
              child: CustomPaint(
                painter: _SciFiGridPainter(
                  rotX: _rotX,
                  rotY: _rotY,
                  color: AppColors.secondary.withOpacity(0.08),
                ),
              ),
            ),

            // 2. Petunjuk Interaksi di Bawah
            Positioned(
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.bgDark.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.glassBorder.withOpacity(0.5)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.touch_app_rounded, size: 14, color: AppColors.secondary),
                    SizedBox(width: 6),
                    Text(
                      'Tahan & Geser Kursor/Layar untuk Memutar Profil 360°',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),

            // 4. Objek 3D Inti dengan Transformasi Matrix4
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, _perspectiveDepth)
                ..scale(_zoomScale)
                ..rotateX(_rotX)
                ..rotateY(_rotY)
                ..rotateZ(_rotZ),
              child: _buildCore3DAvatarObject(),
            ),
          ],
        ),
      ),
    );
  }

  /// Objek Inti Profil 3D (Lapisan Parallax, Glow, Cincin Giroskop & Refleksi Kaca)
  Widget _buildCore3DAvatarObject() {
    const avatarSize = 220.0;
    final lightOffsetX = -sin(_rotY) * 35;
    final lightOffsetY = sin(_rotX) * 35;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Lapisan 1: 3D Outer Halo Shadow (bergeser berlawanan dengan arah cahaya)
        Container(
          width: avatarSize + 40,
          height: avatarSize + 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (_currentSkin == 'hologram' ? AppColors.secondary : AppColors.primary)
                    .withOpacity(0.4),
                blurRadius: 50,
                spreadRadius: 8,
                offset: Offset(lightOffsetX * 0.8, lightOffsetY * 0.8),
              ),
            ],
          ),
        ),

        // Lapisan 2: Giroskop Wireframe Rings di sekeliling profil
        if (_showGyroscope)
          CustomPaint(
            size: const Size(avatarSize + 70, avatarSize + 70),
            painter: _Gyroscope3DPainter(
              rotX: _rotX,
              rotY: _rotY,
              color: AppColors.secondary,
            ),
          ),

        // Lapisan 3: Beveled Metallic Base Ring
        Container(
          width: avatarSize + 16,
          height: avatarSize + 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              colors: [
                AppColors.primary,
                AppColors.secondary,
                AppColors.accent,
                AppColors.accentRose,
                AppColors.primary,
              ],
              transform: GradientRotation(_rotY * 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.7),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
        ),

        // Lapisan 4: Inner Core Bezel
        Container(
          width: avatarSize + 6,
          height: avatarSize + 6,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.bgDark,
          ),
        ),

        // Lapisan 5: Avatar Image Display (Sesuai Skin yang dipilih)
        ClipOval(
          child: SizedBox(
            width: avatarSize,
            height: avatarSize,
            child: _buildAvatarImageWidget(),
          ),
        ),

        // Lapisan 6: Efek Hologram Scanlines Animated
        if (_showScanlines)
          ClipOval(
            child: SizedBox(
              width: avatarSize,
              height: avatarSize,
              child: AnimatedBuilder(
                animation: _scanlineController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _ScanlineEffectPainter(
                      progress: _scanlineController.value,
                      color: _currentSkin == 'hologram'
                          ? AppColors.secondary.withOpacity(0.35)
                          : AppColors.primaryLight.withOpacity(0.2),
                    ),
                  );
                },
              ),
            ),
          ),

        // Lapisan 7: Specular Glass Lens Reflection (Glint highlight yang bergerak dinamis)
        ClipOval(
          child: Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-sin(_rotY) * 0.9 - 0.2, -sin(_rotX) * 0.9 - 0.2),
                radius: 0.8,
                colors: [
                  Colors.white.withOpacity(0.40),
                  Colors.white.withOpacity(0.08),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.35, 0.75],
              ),
            ),
          ),
        ),

        // Lapisan 8: Floating 3D Micro-Chips mengorbit avatar (Flutter, PBO A+, Dart, Architect)
        if (_showOrbitParticles) ..._buildFloatingSatellites(avatarSize / 2),
      ],
    );
  }

  /// Satelit Floating 3D yang mengorbit dengan kedalaman Z
  List<Widget> _buildFloatingSatellites(double radius) {
    final satellites = [
      {'label': 'Flutter 3D', 'icon': Icons.flutter_dash, 'color': AppColors.secondary},
      {'label': 'PBO A+ (4.00)', 'icon': Icons.verified_rounded, 'color': AppColors.accent},
      {'label': 'Dart OOP', 'icon': Icons.code_rounded, 'color': AppColors.primaryLight},
      {'label': 'Software Architect', 'icon': Icons.architecture_rounded, 'color': AppColors.accentRose},
    ];

    final widgets = <Widget>[];

    for (int i = 0; i < satellites.length; i++) {
      final baseAngle = (_rotY * 0.8) + (i * (pi / 2));
      final x = cos(baseAngle) * (radius + 48);
      final y = sin(baseAngle) * (radius * 0.45) + (sin(_rotX) * 20);
      final z = sin(baseAngle); // -1.0 (belakang) s/d +1.0 (depan)

      // Skala dan opacity berubah berdasarkan kedalaman 3D
      final scale = 0.85 + (z * 0.2);
      final opacity = (0.5 + (z * 0.5)).clamp(0.25, 1.0);

      widgets.add(
        Transform.translate(
          offset: Offset(x, y),
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.bgDark.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: (satellites[i]['color'] as Color).withOpacity(0.7),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (satellites[i]['color'] as Color).withOpacity(0.35),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      satellites[i]['icon'] as IconData,
                      size: 13,
                      color: satellites[i]['color'] as Color,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      satellites[i]['label'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: satellites[i]['color'] as Color,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  /// Tampilan Gambar Avatar sesuai Skin Aktif
  Widget _buildAvatarImageWidget() {
    switch (_currentSkin) {
      case '3d_dev':
        return Image.asset(
          'assets/images/WhatsApp Image 2026-09-28 at 05.43.25.jpeg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/images/avatar_3d.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildFallbackImage(),
          ),
        );

      case 'hologram':
        return ColorFiltered(
          colorFilter: const ColorFilter.matrix(<double>[
            0.0, 0.0, 0.0, 0.0, 0.0,
            0.5, 1.0, 0.5, 0.0, 50.0,
            1.0, 1.0, 1.5, 0.0, 100.0,
            0.0, 0.0, 0.0, 1.0, 0.0,
          ]),
          child: Image.asset(
            'assets/images/WhatsApp Image 2026-09-28 at 05.43.25.jpeg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              'assets/images/avatar_3d.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildFallbackImage(),
            ),
          ),
        );

      case 'classic':
      default:
        return Image.asset(
          'assets/images/WhatsApp Image 2026-09-28 at 05.43.25.jpeg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildFallbackImage(),
        );
    }
  }

  Widget _buildFallbackImage() {
    return Container(
      color: AppColors.bgCard,
      child: const Center(
        child: Icon(Icons.person_rounded, size: 80, color: AppColors.primaryLight),
      ),
    );
  }

  /// Panel Kanan: Kontrol & Telemetri PBO Mahasiswa
  Widget _buildTelemetryAndControls(dynamic currentUser) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Selector Skin Profil 3D
        const Text(
          'PILIH SKIN AVATAR 3D',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.secondary,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildSkinChip('3d_dev', '🤖 3D Cyber Dev', Icons.smart_toy_rounded),
            const SizedBox(width: 8),
            _buildSkinChip('hologram', '🌐 Holo Matrix', Icons.blur_on_rounded),
            const SizedBox(width: 8),
            _buildSkinChip('classic', '📷 Realistis', Icons.portrait_rounded),
          ],
        ),

        const SizedBox(height: 24),

        // 2. Kontrol Interaktif Slider & Toggle
        const Text(
          'KONTROL DINAMIKA 3D',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.secondary,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 12),

        // Tombol Auto-Spin & Reset
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _isAutoSpin = !_isAutoSpin),
                icon: Icon(_isAutoSpin ? Icons.pause_circle_rounded : Icons.play_circle_rounded),
                label: Text(_isAutoSpin ? 'Jeda Orbit' : 'Auto Orbit 360°'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _isAutoSpin ? AppColors.accent : Colors.white,
                  side: BorderSide(
                    color: _isAutoSpin ? AppColors.accent : AppColors.glassBorder,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton.filledTonal(
              onPressed: _resetOrientation,
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Reset Orientasi 3D',
              style: IconButton.styleFrom(
                backgroundColor: AppColors.bgDark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Slider Horizontal Yaw
        _buildSliderRow(
          label: 'Rotasi Sumbu Y (Yaw)',
          value: (_rotY % (2 * pi)),
          min: 0,
          max: 2 * pi,
          onChanged: (val) {
            setState(() {
              _isAutoSpin = false;
              _rotY = val;
            });
          },
        ),

        // Slider Vertikal Pitch
        _buildSliderRow(
          label: 'Kemiringan Sumbu X (Pitch)',
          value: _rotX,
          min: -pi * 0.45,
          max: pi * 0.45,
          onChanged: (val) {
            setState(() {
              _isAutoSpin = false;
              _rotX = val;
            });
          },
        ),

        // Toggle Efek Visual
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilterChip(
              selected: _showScanlines,
              label: const Text('Scanlines CRT', style: TextStyle(fontSize: 11)),
              onSelected: (val) => setState(() => _showScanlines = val),
              backgroundColor: AppColors.bgDark,
              selectedColor: AppColors.primary.withOpacity(0.3),
              checkmarkColor: AppColors.primaryLight,
            ),
            FilterChip(
              selected: _showGyroscope,
              label: const Text('Cincin Giroskop', style: TextStyle(fontSize: 11)),
              onSelected: (val) => setState(() => _showGyroscope = val),
              backgroundColor: AppColors.bgDark,
              selectedColor: AppColors.secondary.withOpacity(0.3),
              checkmarkColor: AppColors.secondaryLight,
            ),
            FilterChip(
              selected: _showOrbitParticles,
              label: const Text('Satelit Orbit', style: TextStyle(fontSize: 11)),
              onSelected: (val) => setState(() => _showOrbitParticles = val),
              backgroundColor: AppColors.bgDark,
              selectedColor: AppColors.accent.withOpacity(0.3),
              checkmarkColor: AppColors.accent,
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 3. Telemetri Identitas Mahasiswa & Blueprint PBO
        const Text(
          'DATA CETAK BIRU OBJEK MAHASISWA (PBO BLUEPRINT)',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.secondary,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.bgDark.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Column(
            children: [
              _buildDataRow('Nama Lengkap', _studentData.nama, Icons.person_rounded),
              const Divider(color: AppColors.glassBorder, height: 16),
              _buildDataRow('NIM Mahasiswa', _studentData.nim, Icons.badge_rounded),
              const Divider(color: AppColors.glassBorder, height: 16),
              _buildDataRow('Jurusan / Prodi', _studentData.jurusan, Icons.school_rounded),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkinChip(String id, String label, IconData icon) {
    final isSelected = _currentSkin == id;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentSkin = id),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.2) : AppColors.bgDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.glassBorder,
              width: isSelected ? 1.8 : 1.0,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? AppColors.secondaryLight : AppColors.textMuted,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliderRow({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            Text(
              '${(value * 180 / pi).toStringAsFixed(1)}°',
              style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: AppColors.secondary),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.bgDark,
            thumbColor: AppColors.secondary,
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildDataRow(String label, String value, IconData icon, {Color? valueColor}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Badge Live Status Pulsing
class _LivePillBadge extends StatelessWidget {
  const _LivePillBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.accent.withOpacity(0.5)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 3, backgroundColor: AppColors.accent),
          SizedBox(width: 4),
          Text(
            'LIVE 3D',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: AppColors.accent,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom Painter untuk Grid Sci-Fi di latar belakang
class _SciFiGridPainter extends CustomPainter {
  final double rotX;
  final double rotY;
  final Color color;

  _SciFiGridPainter({
    required this.rotX,
    required this.rotY,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    const step = 40.0;
    final shiftX = (rotY * 20) % step;
    final shiftY = (rotX * 20) % step;

    for (double x = shiftX; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = shiftY; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SciFiGridPainter oldDelegate) {
    return oldDelegate.rotX != rotX || oldDelegate.rotY != rotY;
  }
}

/// Custom Painter untuk Giroskop 3D Wireframe Rings
class _Gyroscope3DPainter extends CustomPainter {
  final double rotX;
  final double rotY;
  final Color color;

  _Gyroscope3DPainter({
    required this.rotX,
    required this.rotY,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint1 = Paint()
      ..color = color.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final paint2 = Paint()
      ..color = AppColors.primaryLight.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Cincin Luar (Tilted Ellipse)
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotY * 0.4);
    canvas.scale(1.0, cos(rotX * 0.8).abs().clamp(0.25, 1.0));
    canvas.drawCircle(Offset.zero, radius - 4, paint1);

    // Titik-titik node pada cincin
    final dotPaint = Paint()..color = color;
    for (int i = 0; i < 8; i++) {
      final angle = i * (pi / 4);
      canvas.drawCircle(
        Offset(cos(angle) * (radius - 4), sin(angle) * (radius - 4)),
        2.5,
        dotPaint,
      );
    }
    canvas.restore();

    // Cincin Dalam Berlawanan Arah
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-rotY * 0.6);
    canvas.scale(cos(rotY * 0.5).abs().clamp(0.25, 1.0), 1.0);
    canvas.drawCircle(Offset.zero, radius - 16, paint2);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _Gyroscope3DPainter oldDelegate) {
    return oldDelegate.rotX != rotX || oldDelegate.rotY != rotY;
  }
}

/// Custom Painter untuk Scanlines CRT
class _ScanlineEffectPainter extends CustomPainter {
  final double progress;
  final Color color;

  _ScanlineEffectPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5;

    for (double y = 0; y < size.height; y += 6) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Moving scan beam
    final beamY = progress * size.height;
    final beamPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          color.withOpacity(0.6),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, beamY - 20, size.width, 40));

    canvas.drawRect(Rect.fromLTWH(0, beamY - 20, size.width, 40), beamPaint);
  }

  @override
  bool shouldRepaint(covariant _ScanlineEffectPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
