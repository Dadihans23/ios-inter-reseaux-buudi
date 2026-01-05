// lib/services/fees_service.dart → VERSION INFAILLIBLE
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/constant.dart';

class FeesService {
  static Map<String, dynamic>? _cache;
  static DateTime? _lastFetched;
  final url = "${AppConstants.baseUrl}";


  static Future<Map<String, dynamic>> getFees() async {
    // Cache 24h
    if (_cache != null && _lastFetched != null && DateTime.now().difference(_lastFetched!).inHours < 24) {
      return _cache!;
    }

    try {
      print("Tentative de chargement des frais depuis le serveur...");
      final response = await http.get(
        Uri.parse("http://${AppConstants.baseUrl}/api/transfer/fees-config/"),
        headers: {"Content-Type": "application/json"},
      ).timeout(const Duration(seconds: 20));

      print("Status code: ${response.statusCode}");
      print("Réponse brute: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.body) as Map<String, dynamic>;
        
        // On s'assure que tout est bien là
        if (decoded.containsKey('buudi_commission_percent') && decoded.containsKey('operators')) {
          _cache = decoded;
          _lastFetched = DateTime.now();
          print("Frais chargés avec succès depuis le serveur !");
          return _cache!;
        } else {
          print("Structure JSON invalide reçue");
        }
      } else {
        print("Erreur HTTP: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Exception lors du chargement des frais: $e");
    }

    // Fallback SECOURU (même si erreur)
    print("Utilisation du fallback (frais par défaut)");
    final fallback = {
      "buudi_commission_percent": 1.5,
      "operators": {
        "wave": {"payin_percent": 2.0, "payout_percent": 2.0},
        "moov": {"payin_percent": 2.0, "payout_percent": 2.0},
        "orange": {"payin_percent": 2.0, "payout_percent": 2.0},
        "mtn": {"payin_percent": 2.5, "payout_percent": 2.5},
      }
    };
    _cache = fallback;
    _lastFetched = DateTime.now();
    return _cache!;
  }
}