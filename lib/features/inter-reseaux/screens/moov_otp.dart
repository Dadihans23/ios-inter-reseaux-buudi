// lib/view/screens/moov_waiting_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../services/constant.dart';


class MoovWaitingScreen extends StatefulWidget {
  final String transferId;

  const MoovWaitingScreen({Key? key, required this.transferId}) : super(key: key);

  @override
  State<MoovWaitingScreen> createState() => _MoovWaitingScreenState();
}

class _MoovWaitingScreenState extends State<MoovWaitingScreen> {
  Timer? _timer;
  String status = "pending";
  bool isFinal = false;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  void _startPolling() {
    _fetchStatus(); // Vérif immédiate
    _timer = Timer.periodic(const Duration(seconds: 20), (_) {
      if (!mounted || isFinal) return;
      _fetchStatus();
    });
  }

  Future<void> _fetchStatus() async {
    if (!mounted || isFinal) return;

    try {
      final url = Uri.parse("http://${AppConstants.baseUrl}/api/transfer/${widget.transferId}/status/");
      final res = await http.get(url);

      if (!mounted) return;

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final newStatus = data["status"] ?? "pending";
        final isDone = data["final"] == true;

        if (isDone && (newStatus == "success" || newStatus == "failed")) {
          _timer?.cancel();
          if (mounted) {
            setState(() {
              status = newStatus;
              isFinal = true;
            });
          }
        }
      }
    } catch (e) {
      print("Polling Moov error: $e");
    }
  }

  void _goHome() => Get.offAllNamed('/home');

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Bloque le retour physique
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Statut du transfert"),
          border: null,
          automaticallyImplyLeading: false,  // 🔥 ENLÈVE LE BOUTON DE RETOUR

        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  child: _buildIcon(),
                  key: ValueKey(status),
                ),
                SizedBox(height: 50),
                Text(
                  _getMessage(),
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 20),

                if (!isFinal)
                  Text(
                    "Vérification en cours...",
                    style: TextStyle(color: CupertinoColors.secondaryLabel, fontSize: 16),
                  ),

                // BOUTON FULL MOOV EN BAS
                if (isFinal)
                  Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: SizedBox(
                      width: 280,
                      child: CupertinoButton(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        color: Color(0xFF00A3D9), // COULEUR MOOV OFFICIELLE
                        borderRadius: BorderRadius.circular(16),
                        onPressed: _goHome,
                        child: Text(
                          "Retour à l'accueil",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    switch (status) {
      case "success":
        return Icon(CupertinoIcons.checkmark_circle_fill, size: 140, color: Colors.green);
      case "failed":
        return Icon(CupertinoIcons.xmark_circle_fill, size: 140, color: Colors.red);
      default:
        return Column(
          key: ValueKey("loader"),
          children: [
            Icon(CupertinoIcons.checkmark_seal_fill, size: 120, color: Color(0xFF00A3D9)),
            SizedBox(height: 25),
            CupertinoActivityIndicator(radius: 40),
          ],
        );
    }
  }

  String _getMessage() {
    switch (status) {
      case "success":
        return "Paiement Moov confirmé !";
      case "failed":
        return "Paiement refusé par Moov";
      default:
        return "Validation en cours...\nConfirme dans le popup Moov";
    }
  }
}