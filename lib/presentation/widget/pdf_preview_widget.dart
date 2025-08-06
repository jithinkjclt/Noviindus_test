import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<Uint8List> generatePdf({
  required String name,
  required String whatsappNumber,
  required String address,
  required String bookedDate,
  required String treatmentDate,
  required String treatmentTime,
  required List<Map<String, dynamic>> treatments,
  required String totalAmount,
  required String discount,
  required String advance,
  required String balance,
}) async {
  final pdf = pw.Document();

  final logoImage = await rootBundle.load('assets/logo.png');
  final logoBytes = logoImage.buffer.asUint8List();
  final signeImage = await rootBundle.load('assets/signe.png');
  final signeBytes = signeImage.buffer.asUint8List();

  final greenColor = PdfColor.fromHex('#0CAC63');
  final lightGreyColor = PdfColor.fromHex('#737373');
  final blackColor = PdfColors.black;

  final boldBlack = pw.TextStyle(
    fontWeight: pw.FontWeight.bold,
    color: blackColor,
    font: await PdfGoogleFonts.notoSansSemiBold(),
    fontSize: 10,
  );

  final boldGreen = pw.TextStyle(
    fontWeight: pw.FontWeight.bold,
    color: greenColor,
    font: await PdfGoogleFonts.notoSansBold(),
  );

  final regularText = pw.TextStyle(
    font: await PdfGoogleFonts.notoSansRegular(),
    color: blackColor,
    fontSize: 10,
  );

  final lightGreyText = pw.TextStyle(
    color: lightGreyColor,
    fontSize: 9,
    font: await PdfGoogleFonts.notoSansRegular(),
  );

  final semiboldText10 = pw.TextStyle(
    font: await PdfGoogleFonts.notoSansSemiBold(),
    fontSize: 10,
    color: PdfColors.black,
  );

  pw.Widget buildDashedDivider({
    PdfColor color = PdfColors.grey300,
    double width = 1,
  }) {
    return pw.Container(
      height: width,
      child: pw.LayoutBuilder(
        builder: (context, constraints) {
          final dashWidth = 5.0;
          final dashSpace = 3.0;
          final dashCount = (constraints!.maxWidth / (dashWidth + dashSpace)).floor();
          return pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount, (_) {
              return pw.Container(
                width: dashWidth,
                height: width,
                color: color,
              );
            }),
          );
        },
      ),
    );
  }

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (context) {
        return pw.Stack(
          children: [
            pw.Positioned.fill(
              child: pw.Center(
                child: pw.Opacity(
                  opacity: 0.06,
                  child: pw.Image(
                    pw.MemoryImage(logoBytes),
                    width: 300,
                  ),
                ),
              ),
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Image(pw.MemoryImage(logoBytes), height: 60),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('KUMARAKOM', style: boldBlack),
                        pw.SizedBox(height: 4),
                        pw.Text('Cheepunkal P.O. Kumarakom, kottayam, Kerala - 686563', style: lightGreyText),
                        pw.Text('e-mail: unknown@gmail.com', style: lightGreyText),
                        pw.Text('Mob: +91 9876543210 | +91 9786543210', style: lightGreyText),
                        pw.Text('GST No: 32AABCU9603R1ZW', style: regularText),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                buildDashedDivider(),
                pw.SizedBox(height: 20),
                pw.Text('Patient Details', style: boldGreen.copyWith(fontSize: 13)),
                pw.SizedBox(height: 20),
                pw.Column(
                  children: [
                    _detailRow('Name:', name, 'Booked On:', bookedDate, semiboldText10, lightGreyText),
                    _detailRow('Address:', address, 'Treatment Date:', treatmentDate, semiboldText10, lightGreyText),
                    _detailRow('WhatsApp Number:', whatsappNumber, 'Treatment Time:', treatmentTime, semiboldText10, lightGreyText),
                  ],
                ),
                pw.SizedBox(height: 15),
                buildDashedDivider(),
                pw.SizedBox(height: 10),
                _treatmentHeaderRow(boldGreen),
                pw.SizedBox(height: 5),
                ...treatments.map((t) => _treatmentRow(t, lightGreyText)),
                pw.SizedBox(height: 15),
                buildDashedDivider(),
                pw.SizedBox(height: 10),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Container(
                    width: 200,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                      children: [
                        _buildSummaryRow('Total Amount', totalAmount, boldBlack, regularText),
                        pw.SizedBox(height: 5),
                        _buildSummaryRow('Discount', discount, regularText, regularText),
                        pw.SizedBox(height: 5),
                        _buildSummaryRow('Advance', advance, regularText, regularText),
                        pw.SizedBox(height: 10),
                        buildDashedDivider(),
                        pw.SizedBox(height: 10),
                        _buildSummaryRow('Balance', balance, boldBlack, boldBlack.copyWith(fontSize: 11)),
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(height: 40),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Thank you for choosing us', style: boldGreen.copyWith(fontSize: 12)),
                      pw.SizedBox(height: 4),
                      pw.Text('Your well-being is our commitment, and we\'re honored\nyou\'ve entrusted us with your health journey', style: lightGreyText, textAlign: pw.TextAlign.right),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [pw.Image(pw.MemoryImage(signeBytes), height: 40)],
                ),
                pw.Spacer(),
                buildDashedDivider(),
                pw.SizedBox(height: 10),
                pw.Center(
                  child: pw.Text('“Booking amount is non-refundable, and it\'s important to arrive on the allotted time for your treatment”', style: lightGreyText.copyWith(fontSize: 8), textAlign: pw.TextAlign.center),
                ),
              ],
            )
          ],
        );
      },
    ),
  );

  return pdf.save();
}

pw.Widget _detailRow(String l1, String v1, String l2, String v2, pw.TextStyle labelStyle, pw.TextStyle valueStyle) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 5),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _buildPatientDetailRow(l1, v1, labelStyle, valueStyle),
        _buildPatientDetailRow(l2, v2, labelStyle, valueStyle),
      ],
    ),
  );
}

pw.Widget _buildPatientDetailRow(String label, String value, pw.TextStyle labelStyle, pw.TextStyle valueStyle) {
  return pw.Row(
    children: [
      pw.Text(label, style: labelStyle),
      pw.SizedBox(width: 5),
      pw.Text(value, style: valueStyle),
    ],
  );
}

pw.Widget _treatmentHeaderRow(pw.TextStyle style) {
  return pw.Row(
    children: [
      pw.Expanded(flex: 4, child: pw.Text('Treatment', style: style)),
      pw.Expanded(flex: 2, child: pw.Text('Price', style: style, textAlign: pw.TextAlign.center)),
      pw.Expanded(flex: 2, child: pw.Text('Male', style: style, textAlign: pw.TextAlign.center)),
      pw.Expanded(flex: 2, child: pw.Text('Female', style: style, textAlign: pw.TextAlign.center)),
      pw.Expanded(flex: 3, child: pw.Text('Total', style: style, textAlign: pw.TextAlign.right)),
    ],
  );
}

pw.Widget _treatmentRow(Map<String, dynamic> t, pw.TextStyle baseStyle) {
  final treatmentTextStyle = baseStyle.copyWith(fontSize: 13);
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 3),
    child: pw.Row(
      children: [
        pw.Expanded(flex: 4, child: pw.Text(t['name'], style: treatmentTextStyle)),
        pw.Expanded(flex: 2, child: pw.Text(t['price'], style: treatmentTextStyle, textAlign: pw.TextAlign.center)),
        pw.Expanded(flex: 2, child: pw.Text(t['male'], style: treatmentTextStyle, textAlign: pw.TextAlign.center)),
        pw.Expanded(flex: 2, child: pw.Text(t['female'], style: treatmentTextStyle, textAlign: pw.TextAlign.center)),
        pw.Expanded(flex: 3, child: pw.Text(t['total'], style: treatmentTextStyle, textAlign: pw.TextAlign.right)),
      ],
    ),
  );
}

pw.Widget _buildSummaryRow(String label, String value, pw.TextStyle labelStyle, pw.TextStyle valueStyle) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text(label, style: labelStyle),
      pw.Text(value, style: valueStyle, textAlign: pw.TextAlign.right),
    ],
  );
}
