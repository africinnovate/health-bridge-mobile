import 'dart:io';
import 'dart:convert';

import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/data/models/donor/donation_history_model.dart';
import 'package:HealthBridge/presentation/widgets/cancel_button.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class DonationReceiptScreen extends StatelessWidget {
  final DonationHistoryModel? donation;

  const DonationReceiptScreen({super.key, this.donation});

  /// Build QR code data as a JSON string from donation info
  String get _qrData {
    if (donation == null) return 'N/A';
    return jsonEncode({
      'ref_id': donation!.refId,
      'status': donation!.requestStatus,
      'units': donation!.units,
      'date': donation!.donatedAt ?? donation!.cancelledAt,
    });
  }

  String get _statusLabel {
    if (donation == null) return 'N/A';
    final s = donation!.requestStatus;
    if (s.isEmpty) return 'N/A';
    return s[0].toUpperCase() + s.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(
        title: 'Donation Receipt',
        showArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Subtitle
            const Text(
              'Here are the official details of your completed donation.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),

            /// Receipt Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  /// HealthBridge Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.receipt,
                      color: AppColors.green,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// App Name
                  const Text(
                    'HealthBridge',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// Details
                  _detailRow('Donation Type:', 'Whole Blood'),
                  const SizedBox(height: 16),
                  _detailRow('Date:', donation?.formattedDate ?? 'N/A'),
                  const SizedBox(height: 16),
                  _detailRow('Status:', _statusLabel),
                  const SizedBox(height: 16),
                  _detailRow('Reference ID:', donation?.refId ?? 'N/A'),
                  const SizedBox(height: 16),
                  _detailRow(
                      'Units Donated:', donation?.formattedUnits ?? 'N/A'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// Verify Donation Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  const Text(
                    'Verify Donation',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Scan this code to confirm donation details at any\npartnered center.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// QR Code
                  QrImageView(
                    data: _qrData,
                    version: QrVersions.auto,
                    size: 180,
                    backgroundColor: Colors.white,
                    errorCorrectionLevel: QrErrorCorrectLevel.M,
                  ),
                  const SizedBox(height: 20),

                  /// Receipt Info
                  const Text(
                    'This receipt serves as an official record of your\nvoluntary blood donation.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Receipt generated on ${donation?.formattedDate ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Receipt No: ${donation?.refId ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            /// Download Button
            CustomButton(
              onPressed: () => _downloadPdf(context),
              text: 'Download PDF Receipt',
            ),
            const SizedBox(height: 12),

            /// Share Button
            CancelButton(
              text: 'Share Receipt',
              onPressed: () => _shareReceipt(context),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// Generate PDF receipt and save to Downloads / app documents
  Future<void> _downloadPdf(BuildContext context) async {
    try {
      final pdfFile = await _generatePdf();

      if (!context.mounted) return;
      SnackBarUtils.showSuccess(context, 'Receipt saved to ${pdfFile.path}');
    } catch (e) {
      if (!context.mounted) return;
      SnackBarUtils.showError(context, 'Failed to download receipt');
    }
  }

  /// Share receipt as PDF file
  Future<void> _shareReceipt(BuildContext context) async {
    try {
      final pdfFile = await _generatePdf();

      await Share.shareXFiles(
        [XFile(pdfFile.path)],
        subject: 'HealthBridge Donation Receipt - ${donation?.refId ?? ''}',
        text:
            'Here is my blood donation receipt from HealthBridge.\n\nReference: ${donation?.refId ?? 'N/A'}\nDate: ${donation?.formattedDate ?? 'N/A'}\nStatus: $_statusLabel\nUnits: ${donation?.formattedUnits ?? 'N/A'}',
      );
    } catch (e) {
      if (!context.mounted) return;
      SnackBarUtils.showError(context, 'Failed to share receipt');
    }
  }

  /// Generate the PDF document and return the saved file
  Future<File> _generatePdf() async {
    final pdf = pw.Document();

    final refId = donation?.refId ?? 'N/A';
    final date = donation?.formattedDate ?? 'N/A';
    final status = _statusLabel;
    final units = donation?.formattedUnits ?? 'N/A';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context pdfContext) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              /// Header
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      'HealthBridge',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Blood Donation Receipt',
                      style: pw.TextStyle(
                        fontSize: 16,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 30),
              pw.Divider(),
              pw.SizedBox(height: 20),

              /// Details
              _pdfDetailRow('Donation Type', 'Whole Blood'),
              _pdfDetailRow('Date', date),
              _pdfDetailRow('Status', status),
              _pdfDetailRow('Reference ID', refId),
              _pdfDetailRow('Units Donated', units),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 20),

              /// QR Code
              pw.Center(
                child: pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: _qrData,
                  width: 150,
                  height: 150,
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Center(
                child: pw.Text(
                  'Scan to verify donation details',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey600,
                  ),
                ),
              ),
              pw.SizedBox(height: 30),
              pw.Divider(),
              pw.SizedBox(height: 12),

              /// Footer
              pw.Center(
                child: pw.Text(
                  'This receipt serves as an official record of your voluntary blood donation.',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey500,
                  ),
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Center(
                child: pw.Text(
                  'Receipt No: $refId',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey600,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'donation_receipt_${refId.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Helper for PDF detail rows
  pw.Widget _pdfDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColors.grey700,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF6B7280),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
