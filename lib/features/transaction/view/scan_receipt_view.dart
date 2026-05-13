// lib/features/transaction/view/scan_receipt_view.dart
// ─────────────────────────────────────────────────────────────────────────────
// Receipt Scan AI screen — matches the dark camera design:
//   • Dark full-screen "camera" view
//   • Corner bracket viewfinder overlay
//   • Animated red scanning line
//   • Receipt "photo" preview (white card)
//   • AI EXTRACTED result panel at bottom
//   • Edit + Save buttons
// Shows premium gate for non-premium users.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/transaction_controller.dart';
import '../model/transaction_models.dart';
import '../widgets/premium_gate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class ScanReceiptView extends StatefulWidget {
  const ScanReceiptView({super.key});
  @override
  State<ScanReceiptView> createState() => _ScanReceiptViewState();
}

class _ScanReceiptViewState extends State<ScanReceiptView>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanLineCtrl;
  late Animation<double> _scanLineAnim;
  TransactionController get ctrl => Get.find<TransactionController>();

  @override
  void initState() {
    super.initState();
    _scanLineCtrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 2000))
      ..repeat(reverse: true);
    _scanLineAnim = CurvedAnimation(
        parent: _scanLineCtrl, curve: Curves.easeInOut);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!ctrl.isPremium.value) {
        PremiumGate.show(
          context: context,
          titleKey: 'premium_receipt_title',
          descKey: 'premium_receipt_desc',
          icon: Icons.receipt_long_rounded,
        );
      } else {
        ctrl.startReceiptScan();
      }
    });
  }

  @override
  void dispose() {
    _scanLineCtrl.dispose();
    ctrl.resetScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),
      body: SafeArea(
        child: Obx(() {
          final state = ctrl.scanState.value;
          return Stack(
            children: [
              // ── Full-screen dark "camera" ──────────────────────────────
              Positioned.fill(child: _CameraBackground()),

              // ── Top bar ──────────────────────────────────────────────
              Positioned(
                top: 0, left: 0, right: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close_rounded,
                          color: Colors.white70, size: 24),
                        onPressed: Get.back,
                      ),
                      const Expanded(child: Center(
                        child: Text('Point at your receipt',
                          style: TextStyle(fontFamily: 'Poppins',
                            fontSize: 14, fontWeight: FontWeight.w600,
                            color: Colors.white)),
                      )),
                      // Flash toggle
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(Icons.flash_on_rounded,
                          color: Colors.white70, size: 18),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Viewfinder with receipt + scanning line ───────────────
              Positioned(
                top: 100, left: 30, right: 30,
                child: _ViewfinderArea(
                  scanLineAnim: _scanLineAnim,
                  state: state,
                  extraction: ctrl.scanExtraction.value,
                ),
              ),

              // ── Bottom panel ──────────────────────────────────────────
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: _BottomPanel(state: state, ctrl: ctrl),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ── Dark camera-style background ──────────────────────────────────────────────
class _CameraBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0A0B0E),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6),
        itemCount: 120,
        itemBuilder: (_, __) => Container(
          margin: const EdgeInsets.all(1),
          color: Colors.white.withOpacity(0.015),
        ),
      ),
    );
  }
}

// ── Viewfinder with corners + receipt mockup + scan line ──────────────────────
class _ViewfinderArea extends StatelessWidget {
  final Animation<double> scanLineAnim;
  final ScanState state;
  final AiExtractionResult? extraction;

  const _ViewfinderArea({
    required this.scanLineAnim,
    required this.state,
    this.extraction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Corner brackets
        Stack(
          children: [
            // Receipt mockup (white card)
            Container(
              width: double.infinity,
              height: 320,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.4),
                    blurRadius: 20),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Receipt header
                    Center(child: Column(children: [
                      const Text('McDONALD\'S',
                        style: TextStyle(fontFamily: 'Courier',
                          fontSize: 14, fontWeight: FontWeight.w900,
                          color: Colors.black87)),
                      const Text('OLAYA STREET · RIYADH',
                        style: TextStyle(fontFamily: 'Courier',
                          fontSize: 9, color: Colors.black54)),
                    ])),
                    const Divider(color: Colors.black26, height: 20),
                    _ReceiptLine('Big Mac Meal', '45.00'),
                    _ReceiptLine('McChicken', '22.00'),
                    _ReceiptLine('Cola Lg', '12.00'),
                    _ReceiptLine('Fries Lg', '14.00'),
                    const Divider(color: Colors.black26, height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('TOTAL  SAR',
                          style: TextStyle(fontFamily: 'Courier',
                            fontSize: 11, fontWeight: FontWeight.w700,
                            color: Colors.black87)),
                        const Text('245.00',
                          style: TextStyle(fontFamily: 'Courier',
                            fontSize: 11, fontWeight: FontWeight.w700,
                            color: Colors.black87)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Center(child: const Text('10 MAY 2026  ·  13:42',
                      style: TextStyle(fontFamily: 'Courier',
                        fontSize: 8, color: Colors.black38))),
                  ],
                ),
              ),
            ),

            // Scanning line (only during scanning)
            if (state == ScanState.scanning)
              Positioned(
                left: 0, right: 0,
                child: AnimatedBuilder(
                  animation: scanLineAnim,
                  builder: (_, __) => Transform.translate(
                    offset: Offset(0, 280 * scanLineAnim.value + 20),
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            AppColors.categoryFood,
                            AppColors.categoryFood,
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.2, 0.8, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.categoryFood.withOpacity(0.8),
                            blurRadius: 8, spreadRadius: 2),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // Corner brackets overlay
            Positioned.fill(child: CustomPaint(painter: _CornerPainter())),
          ],
        ),
      ],
    );
  }
}

class _ReceiptLine extends StatelessWidget {
  final String name;
  final String price;
  const _ReceiptLine(this.name, this.price);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(
            fontFamily: 'Courier', fontSize: 10, color: Colors.black54)),
          Text(price, style: const TextStyle(
            fontFamily: 'Courier', fontSize: 10, color: Colors.black54)),
        ],
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.categoryFood
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    const len = 20.0;
    const r   = 4.0;
    // Top-left
    canvas.drawLine(Offset(0, len), const Offset(0, r), paint);
    canvas.drawLine(const Offset(r, 0), Offset(len, 0), paint);
    // Top-right
    canvas.drawLine(Offset(size.width - len, 0), Offset(size.width - r, 0), paint);
    canvas.drawLine(Offset(size.width, r), Offset(size.width, len), paint);
    // Bottom-left
    canvas.drawLine(Offset(0, size.height - len), Offset(0, size.height - r), paint);
    canvas.drawLine(Offset(r, size.height), Offset(len, size.height), paint);
    // Bottom-right
    canvas.drawLine(Offset(size.width - len, size.height), Offset(size.width - r, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height - r), Offset(size.width, size.height - len), paint);
  }
  @override
  bool shouldRepaint(_) => false;
}

// ── Bottom panel ──────────────────────────────────────────────────────────────
class _BottomPanel extends StatelessWidget {
  final ScanState state;
  final TransactionController ctrl;
  const _BottomPanel({required this.state, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20,
          MediaQuery.of(context).padding.bottom + 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1117).withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state == ScanState.scanning || state == ScanState.idle)
            _CameraControls(onCapture: ctrl.startReceiptScan),

          if (state == ScanState.processing)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
                  SizedBox(width: 14),
                  Text('ai_badge',
                    style: TextStyle(fontFamily: 'Poppins',
                      color: Colors.white60, fontSize: 14)),
                ],
              ),
            ),

          if (state == ScanState.extracted && ctrl.scanExtraction.value != null)
            _ExtractionPanel(result: ctrl.scanExtraction.value!, ctrl: ctrl),
        ],
      ),
    );
  }
}

class _CameraControls extends StatelessWidget {
  final VoidCallback onCapture;
  const _CameraControls({required this.onCapture});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Gallery button
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.photo_library_rounded,
            color: Colors.white70, size: 24),
        ),
        // Shutter
        GestureDetector(
          onTap: onCapture,
          child: Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 3),
            ),
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        // Flash
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.flash_auto_rounded,
            color: Colors.white70, size: 24),
        ),
      ],
    );
  }
}

class _ExtractionPanel extends StatelessWidget {
  final AiExtractionResult result;
  final TransactionController ctrl;
  const _ExtractionPanel({required this.result, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('AI EXTRACTED',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 10,
            fontWeight: FontWeight.w700, color: Colors.white38,
            letterSpacing: 1)),
        const SizedBox(height: 12),
        _ERow('amount'.tr, result.amount != null ? 'SAR  ${result.amount!.toStringAsFixed(0)}' : '—'),
        _ERow('merchant'.tr, result.merchant ?? '—', badge: true),
        _ERow('category'.tr,
          result.category?.labelKey.tr ?? '—',
          icon: result.category?.icon,
          iconColor: result.category?.color,
          badge: true),
        _ERow('date'.tr, 'Today · 10 May'),
        if (result.lineItemCount != null)
          _ERow('items'.tr, '${result.lineItemCount} ${'line_items_detected'.tr}'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: ctrl.applyScanExtraction,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: Text('edit'.tr,
                  style: const TextStyle(fontFamily: 'Poppins',
                    fontSize: 13, color: Colors.white70)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(flex: 2,
              child: ElevatedButton(
                onPressed: ctrl.applyScanExtraction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: Text('save_expense'.tr,
                  style: const TextStyle(fontFamily: 'Poppins',
                    fontSize: 13, fontWeight: FontWeight.w600,
                    color: Colors.white)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ERow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final bool badge;
  const _ERow(this.label, this.value, {this.icon, this.iconColor, this.badge = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(width: 80,
            child: Text(label, style: const TextStyle(
              fontFamily: 'Poppins', fontSize: 12, color: Colors.white38))),
          if (icon != null) ...[
            Icon(icon, color: iconColor ?? Colors.white, size: 14),
            const SizedBox(width: 5),
          ],
          Text(value, style: const TextStyle(
            fontFamily: 'Poppins', fontSize: 13,
            fontWeight: FontWeight.w600, color: Colors.white)),
          if (badge) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('+ AI', style: TextStyle(fontFamily: 'Poppins',
                fontSize: 9, fontWeight: FontWeight.w700,
                color: AppColors.primary)),
            ),
          ],
        ],
      ),
    );
  }
}
