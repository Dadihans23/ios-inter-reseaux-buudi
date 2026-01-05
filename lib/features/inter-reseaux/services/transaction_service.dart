// lib/services/transaction_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction_model.dart';
import '../services/constant.dart';


class TransactionService {
  static const String baseUrl = "http://${AppConstants.baseUrl}/api/transfer";

  static Future<List<TransactionModel>> getRecentTransactions(String userPhone) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/my-transactions/"),
        headers: {
          "Content-Type": "application/json",
          "X-User-Phone": userPhone,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> rawData = json.decode(response.body);
        return rawData.map((json) => TransactionModel.fromJson(json)).toList();
      } else {
        print("Erreur API: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Erreur TransactionService: $e");
    }
    return []; // Retourne liste vide en cas d'erreur
  }
}