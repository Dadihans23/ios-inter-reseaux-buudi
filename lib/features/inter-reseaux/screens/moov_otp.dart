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
    _confirmAndStart();
  }

  Future<void> _confirmAndStart() async {
    try {
      final confirmRes = await http.post(
        Uri.parse("http://${AppConstants.baseUrl}/api/transfer/confirm/"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"transfer_id": int.parse(widget.transferId)}),
      );

      if (confirmRes.statusCode != 200) {
        setState(() {
          status = "failed";
          isFinal = true;
        });
        return;
      }

      // Confirmation OK → polling
      _startPolling();

    } catch (e) {
      setState(() {
        status = "failed";
        isFinal = true;
      });
    }
  }

  void _startPolling() {
    _fetchStatus(); // Première vérif immédiate
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
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

        if (isDone) {
          _timer?.cancel();
          setState(() {
            status = newStatus;
            isFinal = true;
          });
        }
      }
    } catch (e) {
      print("Polling error: $e");
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
      onWillPop: () async => false,
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text("Paiement Moov"),
          border: null,
          automaticallyImplyLeading: false,
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icône + loader
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _buildMainContent(),
                  key: ValueKey(status),
                ),

                const SizedBox(height: 40),

                // Message principal
                Text(
                  _getMessage(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: status == "failed" ? CupertinoColors.systemRed : null,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Bouton retour seulement quand terminé
                if (isFinal)
  SizedBox(
    width: 240,
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFF00A3D9), // Bleu Moov officiel
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00A3D9).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(vertical: 16),
        borderRadius: BorderRadius.circular(12),
        child: const Text(
          "Retour à l'accueil",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        onPressed: _goHome,
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

  Widget _buildMainContent() {
    if (status == "pending") {
      return Column(
        children: [
          const Icon(CupertinoIcons.checkmark_seal_fill, size: 100, color: Color(0xFF00A3D9)),
          const SizedBox(height: 20),
          const CupertinoActivityIndicator(radius: 30),
        ],
      );
    } else if (status == "success") {
      return const Icon(CupertinoIcons.checkmark_circle_fill, size: 140, color: Colors.green);
    } else {
      return const Icon(CupertinoIcons.xmark_circle_fill, size: 140, color: Colors.red);
    }
  }

  String _getMessage() {
    if (status == "pending") return "En attente de confirmation Moov...";
    if (status == "success") return "Paiement confirmé !";
    return "Échec du paiement";
  }
}