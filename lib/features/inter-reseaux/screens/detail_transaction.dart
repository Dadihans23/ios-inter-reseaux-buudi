// lib/view/screens/transaction_detail_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:six_cash/util/images.dart';
import '../models/transaction_model.dart';
import 'package:avatar_glow/avatar_glow.dart';
import '../services/constant.dart';


class TransactionDetailScreen extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailScreen({Key? key, required this.transaction}) : super(key: key);

  String _getLogo(String wallet) {
    final op = wallet.replaceAll('-ci', '').toLowerCase();
    switch (op) {
      case 'wave': return Images.wavelogo;
      case 'moov': return Images.moovlogo;
      case 'orange-money': return Images.orangelogo;
      case 'mtn': return Images.mtnlogo;
      default: return Images.wavelogo;
    }
  }

  String _formatOperator(String wallet) {
    return wallet
        .replaceAll('-ci', '')
        .replaceAll('-', ' ')
        .split(' ')
        .map((e) => e[0].toUpperCase() + e.substring(1))
        .join(' ');
  }

  String getSimpleStatusLabel(String status) {
    if (status == 'success') return 'Réussi';
    if (status == 'failed') return 'Échoué';
    return 'En cours';
  }

  Color getSimpleStatusColor(String status) {
    if (status == 'success') return CupertinoColors.systemGreen;
    if (status == 'failed') return CupertinoColors.systemRed;
    return CupertinoColors.activeOrange;
  }

  IconData getSimpleStatusIcon(String status) {
    if (status == 'success') return CupertinoIcons.checkmark_circle_fill;
    if (status == 'failed') return CupertinoIcons.xmark_circle_fill;
    return CupertinoIcons.arrow_2_circlepath;
  }

  String formatDate(DateTime date) {
    const months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jui', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return "$day $month $year à $hour:$minute";
  }

  bool get hasGlow => transaction.status == 'success';

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double horizontalPadding = width * 0.02; // 6% des côtés

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Détail du transfert"),
        backgroundColor: CupertinoColors.systemBackground,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: width * 0.05),

              // STATUT + MONTANT PRINCIPAL AVEC GLOW
              Center(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(width * 0.03),
                  decoration: BoxDecoration(
                    color: CupertinoColors.black.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(width * 0.04),
                  ),
                  child: Column(
                    children: [
                      AvatarGlow(
                        animate: hasGlow,
                        glowColor: getSimpleStatusColor(transaction.status).withOpacity(0.7),
                        duration: Duration(milliseconds: 2000),
                        repeat: true,
                        child: Icon(
                          getSimpleStatusIcon(transaction.status),
                          size: width * 0.18,
                          color: getSimpleStatusColor(transaction.status),
                        ),
                      ),

                      SizedBox(height: width * 0.04),

                      Text(
                        getSimpleStatusLabel(transaction.status),
                        style: TextStyle(
                          fontSize: width * 0.07,
                          fontWeight: FontWeight.bold,
                          color: getSimpleStatusColor(transaction.status),
                        ),
                      ),

                      SizedBox(height: width * 0.03),

                      Text(
                        "${transaction.amountRequested} FCFA",
                        style: TextStyle(
                          fontSize: width * 0.045,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: width * 0.08),

              // DÉTAILS DANS CONTENEUR NOIR
              Center(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(width * 0.03),
                  decoration: BoxDecoration(
                    color: CupertinoColors.black.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(width * 0.04),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow("Transaction ID", transaction.paydunyaInvoiceToken, width),
                      _buildDetailRow("Statut", getSimpleStatusLabel(transaction.status), width),
                      _buildDetailRow("Émetteur", transaction.fromPhone, width),
                      _buildDetailRow("Destinataire", transaction.toPhone, width),
                      _buildDetailRow("Date", formatDate(transaction.createdAt), width),

                      SizedBox(height: width * 0.05),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(width * 0.03),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              _getLogo(transaction.fromWallet),
                              width: width * 0.12,
                              height: width * 0.12,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                            child: Icon(
                              CupertinoIcons.arrow_right,
                              size: width * 0.06,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(width * 0.03),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              _getLogo(transaction.toWallet),
                              width: width * 0.12,
                              height: width * 0.12,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: width * 0.05),

                      DottedLine(height: 2, color: Colors.grey.withOpacity(0.5)),

                      SizedBox(height: width * 0.05),

                      _buildDetailRow("Total débité", "${transaction.totalDebited} FCFA", width),
                    ],
                  ),
                ),
              ),

              SizedBox(height: width * 0.06),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, double width) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: width * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: width * 0.04,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: CupertinoColors.systemGrey5,
            ),
          ),
          SizedBox(width: width * 0.03),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: width * 0.045,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// DOTTED LINE — RESPONSIVE
class DottedLine extends StatelessWidget {
  final double height;
  final Color color;

  const DottedLine({this.height = 1, this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return CustomPaint(
      size: Size(double.infinity, height),
      painter: _DottedLinePainter(color),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  final Color color;
  _DottedLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 8;
    double dashSpace = 5;
    double startX = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.height;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}