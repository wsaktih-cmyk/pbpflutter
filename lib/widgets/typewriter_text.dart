import 'dart:async';
import 'package:flutter/material.dart';

/// Widget Animasi Teks Mengetik (Typewriter Effect)
/// Mengetik teks huruf demi huruf secara halus dengan kursor berkedip interaktif.
class TypewriterText extends StatefulWidget {
  final List<String> texts;
  final TextStyle? style;
  final TextStyle? cursorStyle;
  final Duration typingSpeed;
  final Duration pauseDuration;
  final Duration deletingSpeed;
  final TextAlign textAlign;
  final String cursor;

  const TypewriterText({
    super.key,
    required this.texts,
    this.style,
    this.cursorStyle,
    this.typingSpeed = const Duration(milliseconds: 90),
    this.pauseDuration = const Duration(milliseconds: 1800),
    this.deletingSpeed = const Duration(milliseconds: 45),
    this.textAlign = TextAlign.start,
    this.cursor = '|',
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  int _textIndex = 0;
  int _charIndex = 0;
  bool _isDeleting = false;
  Timer? _timer;

  late AnimationController _cursorController;
  late Animation<double> _cursorOpacity;

  @override
  void initState() {
    super.initState();
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _cursorOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cursorController, curve: Curves.easeInOut),
    );

    _startTypingLoop();
  }

  void _startTypingLoop() {
    _timer?.cancel();
    if (widget.texts.isEmpty) return;

    final currentFullText = widget.texts[_textIndex % widget.texts.length];

    if (!_isDeleting) {
      if (_charIndex < currentFullText.length) {
        _charIndex++;
        _timer = Timer(widget.typingSpeed, () {
          if (mounted) setState(() {});
          _startTypingLoop();
        });
      } else {
        // Selesai mengetik, jeda sebelum menghapus jika ada lebih dari 1 teks
        if (widget.texts.length > 1) {
          _timer = Timer(widget.pauseDuration, () {
            if (mounted) {
              setState(() => _isDeleting = true);
              _startTypingLoop();
            }
          });
        }
      }
    } else {
      if (_charIndex > 0) {
        _charIndex--;
        _timer = Timer(widget.deletingSpeed, () {
          if (mounted) setState(() {});
          _startTypingLoop();
        });
      } else {
        _isDeleting = false;
        _textIndex = (_textIndex + 1) % widget.texts.length;
        _timer = Timer(const Duration(milliseconds: 300), () {
          if (mounted) setState(() {});
          _startTypingLoop();
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.texts.isEmpty) return const SizedBox.shrink();

    final currentFullText = widget.texts[_textIndex % widget.texts.length];
    final displayedText = currentFullText.substring(0, _charIndex.clamp(0, currentFullText.length));

    return RichText(
      textAlign: widget.textAlign,
      text: TextSpan(
        text: displayedText,
        style: widget.style ?? DefaultTextStyle.of(context).style,
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: FadeTransition(
              opacity: _cursorOpacity,
              child: Text(
                widget.cursor,
                style: widget.cursorStyle ??
                    (widget.style ?? DefaultTextStyle.of(context).style).copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w300,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
