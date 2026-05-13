// lib/features/reports/services/export_service.dart
// ─────────────────────────────────────────────────────────────────────────────
// Handles all file-export logic: PDF and CSV.
//
// Architecture:
//   • Pure service class — no GetX, no UI dependencies
//   • Returns ExportResult so the controller can decide how to show feedback
//   • File naming uses ISO timestamp for uniqueness
//   • Stores files in app documents directory (no write-permission needed on
//     modern iOS/Android; we request MANAGE_EXTERNAL_STORAGE only on Android <13
//     if the user chooses to save to Downloads)
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:io';
import 'package:intl/intl.dart' show DateFormat;
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// export_service uses internal stubs — see below

// ── Result wrapper ────────────────────────────────────────────────────────────
class ExportResult {
  final bool success;
  final String? filePath;
  final String message;

  const ExportResult({
    required this.success,
    this.filePath,
    required this.message,
  });
}

// ── Export types ──────────────────────────────────────────────────────────────
enum ExportType { pdf, csv }

// ─────────────────────────────────────────────────────────────────────────────
class ExportService {
  ExportService._(); // non-instantiable

  // ── Shared file-name builder ────────────────────────────────────────────────
  static String _buildFileName(ExportType type) {
    final now = DateTime.now();
    final stamp = DateFormat('yyyy-MM-dd_HH-mm').format(now);
    final ext = type == ExportType.pdf ? 'pdf' : 'csv';
    return 'SpendSmart_Report_$stamp.$ext';
  }

  // ── Directory to write into ────────────────────────────────────────────────
  static Future<Directory> _outputDir() async {
    // getApplicationDocumentsDirectory works on both iOS & Android with no
    // runtime permissions required; the file can then be shared/opened.
    return getApplicationDocumentsDirectory();
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  PDF EXPORT
  // ══════════════════════════════════════════════════════════════════════════
  static Future<ExportResult> exportPdf({
    required List metrics,
    required List categories,
    required List merchants,
    required String period,
  }) async {
    try {
      final doc = pw.Document();
      final now = DateFormat('MMMM yyyy').format(DateTime.now());

      // ── Colour helpers ──────────────────────────────────────────────────
      const brandOrange = PdfColor.fromInt(0xFFFF6B35);
      const textDark    = PdfColor.fromInt(0xFF1A1D2E);
      const textGrey    = PdfColor.fromInt(0xFF6B7280);
      const bgLight     = PdfColor.fromInt(0xFFF8F9FC);
      const white       = PdfColors.white;

      // ── Page ────────────────────────────────────────────────────────────
      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          header: (_) => pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 16),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: brandOrange, width: 2),
              ),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'SpendSmart',
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        color: brandOrange,
                      ),
                    ),
                    pw.Text(
                      'Financial Report · $period',
                      style: pw.TextStyle(fontSize: 12, color: textGrey),
                    ),
                  ],
                ),
                pw.Text(
                  now,
                  style: pw.TextStyle(fontSize: 11, color: textGrey),
                ),
              ],
            ),
          ),
          build: (_) => [
            pw.SizedBox(height: 20),

            // ── Summary cards ───────────────────────────────────────────
            pw.Text(
              'Summary',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: textDark,
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Row(
              children: metrics.map((m) {
                final sign = m.isPositiveChange ? '+' : '';
                return pw.Expanded(
                  child: pw.Container(
                    margin: const pw.EdgeInsets.only(right: 8),
                    padding: const pw.EdgeInsets.all(14),
                    decoration: pw.BoxDecoration(
                      color: bgLight,
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(m.title,
                            style: pw.TextStyle(fontSize: 10, color: textGrey)),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'SAR ${_fmt(m.amount)}',
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          '$sign${m.changePercent.toStringAsFixed(0)}% ${m.changeLabel}',
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: const PdfColor.fromInt(0xFF34C759),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            pw.SizedBox(height: 24),

            // ── Category breakdown ──────────────────────────────────────
            pw.Text(
              'Spending by Category',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: textDark,
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(
                color: const PdfColor.fromInt(0xFFF0F0F5),
                width: 1,
              ),
              children: [
                // Header
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: brandOrange),
                  children: ['Category', 'Amount (SAR)', 'Percentage'].map(
                    (h) => pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(h,
                          style: pw.TextStyle(
                            color: white,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 11,
                          )),
                    ),
                  ).toList(),
                ),
                // Rows
                ...categories.asMap().entries.map(
                  (e) => pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: e.key.isEven ? white : bgLight,
                    ),
                    children: [
                      e.value.nameKey ?? '',
                      _fmt(e.value.amount),
                      '${e.value.percentage.toStringAsFixed(0)}%',
                    ].map(
                      (cell) => pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(cell,
                            style: const pw.TextStyle(fontSize: 11)),
                      ),
                    ).toList(),
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 24),

            // ── Top merchants ───────────────────────────────────────────
            pw.Text(
              'Top Merchants',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: textDark,
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(
                color: const PdfColor.fromInt(0xFFF0F0F5),
                width: 1,
              ),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: brandOrange),
                  children: ['Merchant', 'Total Spent (SAR)'].map(
                    (h) => pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(h,
                          style: pw.TextStyle(
                            color: white,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 11,
                          )),
                    ),
                  ).toList(),
                ),
                ...merchants.asMap().entries.map(
                  (e) => pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: e.key.isEven ? white : bgLight,
                    ),
                    children: [e.value.name, _fmt(e.value.amount)].map(
                      (cell) => pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(cell,
                            style: const pw.TextStyle(fontSize: 11)),
                      ),
                    ).toList(),
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 32),
            pw.Text(
              'Generated by SpendSmart · ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now())}',
              style: pw.TextStyle(fontSize: 9, color: textGrey),
            ),
          ],
        ),
      );

      // ── Save file ────────────────────────────────────────────────────────
      final dir  = await _outputDir();
      final file = File('${dir.path}/${_buildFileName(ExportType.pdf)}');
      await file.writeAsBytes(await doc.save());

      return ExportResult(
        success: true,
        filePath: file.path,
        message: 'PDF saved to ${file.path}',
      );
    } catch (e) {
      return ExportResult(success: false, message: 'PDF export failed: $e');
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  CSV EXPORT
  // ══════════════════════════════════════════════════════════════════════════
  static Future<ExportResult> exportCsv({
    required List metrics,
    required List categories,
    required List merchants,
    required String period,
  }) async {
    try {
      final rows = <List<dynamic>>[];

      // Report header
      rows.add(['SpendSmart Financial Report']);
      rows.add(['Period', period]);
      rows.add(['Generated', DateFormat('dd MMM yyyy HH:mm').format(DateTime.now())]);
      rows.add([]); // blank separator

      // ── Summary ────────────────────────────────────────────────────────
      rows.add(['SUMMARY']);
      rows.add(['Metric', 'Amount (SAR)', 'Change %', 'vs']);
      for (final m in metrics) {
        rows.add([
          m.title,
          m.amount.toStringAsFixed(2),
          '${m.isPositiveChange ? '+' : ''}${m.changePercent.toStringAsFixed(0)}%',
          m.changeLabel,
        ]);
      }
      rows.add([]);

      // ── Categories ─────────────────────────────────────────────────────
      rows.add(['SPENDING BY CATEGORY']);
      rows.add(['Category', 'Amount (SAR)', 'Percentage']);
      for (final c in (categories as List<dynamic>)) {
        rows.add([
          c.nameKey ?? '',
          c.amount.toStringAsFixed(2),
          '${c.percentage.toStringAsFixed(0)}%',
        ]);
      }
      rows.add([]);

      // ── Merchants ──────────────────────────────────────────────────────
      rows.add(['TOP MERCHANTS']);
      rows.add(['Merchant', 'Total Spent (SAR)']);
      for (final m in (merchants as List<dynamic>)) {
        rows.add([m.name, m.amount.toStringAsFixed(2)]);
      }

      final csvString = const ListToCsvConverter().convert(rows);
      final dir  = await _outputDir();
      final file = File('${dir.path}/${_buildFileName(ExportType.csv)}');
      await file.writeAsString(csvString);

      return ExportResult(
        success: true,
        filePath: file.path,
        message: 'CSV saved to ${file.path}',
      );
    } catch (e) {
      return ExportResult(success: false, message: 'CSV export failed: $e');
    }
  }

  // ── Utility ───────────────────────────────────────────────────────────────
  static String _fmt(double v) {
    final n = v.toStringAsFixed(0);
    // Insert thousands separator
    final buf = StringBuffer();
    for (var i = 0; i < n.length; i++) {
      if (i > 0 && (n.length - i) % 3 == 0) buf.write(',');
      buf.write(n[i]);
    }
    return buf.toString();
  }
}
