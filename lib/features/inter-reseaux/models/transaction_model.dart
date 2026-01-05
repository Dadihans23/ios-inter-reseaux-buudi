// lib/models/transaction_model.dart
class TransactionModel {
  final int id;
  final String fromWallet;
  final String toWallet;
  final String fromPhone;
  final String toPhone;
  final String amountRequested;
  final String amountSent;
  final String paydunyaInvoiceToken;
  final String totalDebited;
  final String status;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.fromWallet,
    required this.toWallet,
    required this.fromPhone,
    required this.toPhone,
    required this.amountRequested,
    required this.amountSent,
    required this.paydunyaInvoiceToken,
    required this.totalDebited,
    required this.status,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as int,
      fromWallet: json['from_wallet'] as String,
      toWallet: json['to_wallet'] as String,
      fromPhone: json['from_phone'] as String,
      toPhone: json['to_phone'] as String,
      amountRequested: json['amount_requested'] as String,
      amountSent: json['amount_sent'] as String,
      paydunyaInvoiceToken: (json['paydunya_invoice_token'] ?? '') as String,
      totalDebited: json['total_debited'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}