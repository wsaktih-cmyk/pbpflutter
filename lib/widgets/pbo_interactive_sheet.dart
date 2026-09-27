import 'package:flutter/material.dart';
import '../models/pbo_concept_model.dart';
import '../models/portfolio_item.dart';
import '../theme/app_colors.dart';

/// Modal dialog interaktif untuk menguji dan mengeksekusi prinsip PBO secara live
class PboInteractiveSheet extends StatefulWidget {
  final PboCourseworkItem? pboItem;
  final PboConceptModel? pboConcept;

  const PboInteractiveSheet({
    super.key,
    this.pboItem,
    this.pboConcept,
  }) : assert(pboItem != null || pboConcept != null);

  static void show(
    BuildContext context, {
    PboCourseworkItem? pboItem,
    PboConceptModel? pboConcept,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PboInteractiveSheet(
        pboItem: pboItem,
        pboConcept: pboConcept,
      ),
    );
  }

  @override
  State<PboInteractiveSheet> createState() => _PboInteractiveSheetState();
}

class _PboInteractiveSheetState extends State<PboInteractiveSheet> {
  String _executionOutput = '';
  bool _isRunning = false;

  void _runSimulation() async {
    setState(() {
      _isRunning = true;
      _executionOutput = 'Mengompilasi dan mengalokasikan objek ke memori...';
    });

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() {
      if (widget.pboItem != null) {
        _executionOutput = widget.pboItem!.runInteractiveDemonstration();
      } else if (widget.pboConcept != null) {
        _executionOutput = widget.pboConcept!.simulationCallback();
      }
      _isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.pboItem?.title ?? widget.pboConcept?.title ?? '';
    final subtitle = widget.pboItem?.courseSemester ?? widget.pboConcept?.subtitle ?? '';
    final codeSnippet = widget.pboItem?.sourceCodeSample ?? widget.pboConcept?.dartCodeSnippet ?? '';
    final color = widget.pboItem?.getCategoryColor() ?? widget.pboConcept?.accentColor ?? AppColors.primary;

    return DraggableScrollableSheet(
      initialChildSize: 0.82,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: color.withOpacity(0.4), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Header Modal
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.code_rounded, color: color, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              const Divider(color: AppColors.glassBorder, height: 1),

              // Konten Modal Scrollable
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    // Pilar PBO yang diimplementasikan
                    if (widget.pboItem != null) ...[
                      const Text(
                        'PILAR PBO YANG DIIMPLEMENTASIKAN:',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMuted,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.pboItem!.pboPrinciplesUsed.map((p) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: color.withOpacity(0.35)),
                            ),
                            child: Text(
                              '✓ $p',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: color,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Hirarki Kelas: ${widget.pboItem!.classHierarchyDescription}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Kode Sumber PBO
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'KODE SUMBER PBO (DART / JAVA):',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textMuted,
                            letterSpacing: 0.8,
                          ),
                        ),
                        Text(
                          'Strict OOP Standard',
                          style: TextStyle(fontSize: 11, color: AppColors.accent),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.bgDark,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: SelectableText(
                        codeSnippet,
                        style: const TextStyle(
                          fontFamily: 'Courier',
                          fontSize: 13,
                          color: AppColors.secondaryLight,
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Tombol Eksekusi Live Simulasi PBO
                    ElevatedButton.icon(
                      onPressed: _isRunning ? null : _runSimulation,
                      icon: _isRunning
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.play_arrow_rounded, size: 22),
                      label: Text(
                        _isRunning ? 'Mengeksekusi Kode PBO...' : 'Jalankan Simulasi PBO di Runtime',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Log Hasil Eksekusi Simulasi
                    if (_executionOutput.isNotEmpty) ...[
                      const Text(
                        'OUTPUT TERMINAL PBO (RUNTIME DISPATCH):',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMuted,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.accent.withOpacity(0.4)),
                        ),
                        child: Text(
                          _executionOutput,
                          style: const TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 12.5,
                            color: AppColors.accent,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
