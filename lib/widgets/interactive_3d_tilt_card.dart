import 'package:flutter/material.dart';

/// Widget Pembungkus Efek 3D Tilt Interaktif
/// Memberikan efek kemiringan perspektif spasial 3D saat cursor mouse bergerak di atas kartu,
/// lengkap dengan pantulan cahaya neon (specular glare).
class Interactive3DTiltCard extends StatefulWidget {
  final Widget child;
  final double maxTiltAngle;
  final double perspective;
  final double scaleOnHover;
  final BorderRadius? borderRadius;
  final Color glareColor;
  final bool enableGlare;

  const Interactive3DTiltCard({
    super.key,
    required this.child,
    this.maxTiltAngle = 0.12, // sekitar 7 derajat
    this.perspective = 0.0018,
    this.scaleOnHover = 1.02,
    this.borderRadius,
    this.glareColor = Colors.white,
    this.enableGlare = true,
  });

  @override
  State<Interactive3DTiltCard> createState() => _Interactive3DTiltCardState();
}

class _Interactive3DTiltCardState extends State<Interactive3DTiltCard>
    with SingleTickerProviderStateMixin {
  double _tiltX = 0.0;
  double _tiltY = 0.0;
  bool _isHovered = false;
  Offset _pointerPosition = Offset.zero;

  late AnimationController _resetController;
  late Animation<double> _tiltXAnimation;
  late Animation<double> _tiltYAnimation;

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  void dispose() {
    _resetController.dispose();
    super.dispose();
  }

  void _onHover(PointerEvent event, BoxConstraints constraints) {
    final width = constraints.maxWidth;
    final height = constraints.maxHeight;

    if (width <= 0 || height <= 0) return;

    final localPosition = event.localPosition;
    _pointerPosition = localPosition;

    // Normalisasi posisi dari -1.0 hingga 1.0
    final normalX = (localPosition.dx / width) * 2.0 - 1.0;
    final normalY = (localPosition.dy / height) * 2.0 - 1.0;

    setState(() {
      _isHovered = true;
      // Rotasi X dipengaruhi oleh posisi Y, rotasi Y dipengaruhi oleh posisi X
      _tiltX = -normalY.clamp(-1.0, 1.0) * widget.maxTiltAngle;
      _tiltY = normalX.clamp(-1.0, 1.0) * widget.maxTiltAngle;
    });
  }

  void _onExit(PointerEvent event) {
    _tiltXAnimation = Tween<double>(begin: _tiltX, end: 0.0).animate(
      CurvedAnimation(parent: _resetController, curve: Curves.easeOutBack),
    );
    _tiltYAnimation = Tween<double>(begin: _tiltY, end: 0.0).animate(
      CurvedAnimation(parent: _resetController, curve: Curves.easeOutBack),
    );

    _resetController.reset();
    _resetController.forward().then((_) {
      if (mounted) {
        setState(() {
          _isHovered = false;
          _tiltX = 0.0;
          _tiltY = 0.0;
        });
      }
    });

    _resetController.addListener(() {
      if (mounted) {
        setState(() {
          _tiltX = _tiltXAnimation.value;
          _tiltY = _tiltYAnimation.value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(20);

    return LayoutBuilder(
      builder: (context, constraints) {
        final transform = Matrix4.identity()
          ..setEntry(3, 2, widget.perspective)
          ..rotateX(_tiltX)
          ..rotateY(_tiltY);

        if (_isHovered) {
          transform.scale(widget.scaleOnHover);
        }

        return MouseRegion(
          onHover: (e) => _onHover(e, constraints),
          onExit: _onExit,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutQuad,
            transformAlignment: Alignment.center,
            transform: transform,
            child: ClipRRect(
              borderRadius: radius,
              child: Stack(
                children: [
                  widget.child,

                  // Efek pantulan cahaya dinamis (Specular Glare)
                  if (widget.enableGlare && _isHovered)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: _GlarePainter(
                            pointer: _pointerPosition,
                            color: widget.glareColor,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GlarePainter extends CustomPainter {
  final Offset pointer;
  final Color color;

  _GlarePainter({required this.pointer, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = RadialGradient(
      center: Alignment(
        (pointer.dx / size.width) * 2.0 - 1.0,
        (pointer.dy / size.height) * 2.0 - 1.0,
      ),
      radius: 0.9,
      colors: [
        color.withOpacity(0.12),
        color.withOpacity(0.04),
        Colors.transparent,
      ],
      stops: const [0.0, 0.45, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..blendMode = BlendMode.screen;

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _GlarePainter oldDelegate) {
    return oldDelegate.pointer != pointer || oldDelegate.color != color;
  }
}
