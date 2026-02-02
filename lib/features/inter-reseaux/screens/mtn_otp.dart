// lib/view/screens/mtn_waiting_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart'; // ← IMPORT OBLIGATOIRE POUR launch()
import '../services/constant.dart';

class MtnWaitingScreen extends StatefulWidget {
  final String transferId;

  const MtnWaitingScreen({Key? key, required this.transferId}) : super(key: key);

  @override
  State<MtnWaitingScreen> createState() => _MtnWaitingScreenState();
}

class _MtnWaitingScreenState extends State<MtnWaitingScreen> {
  Timer? _timer;
  String status = "pending";
  bool isFinal = false;
  bool isConfirming = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _confirmAndStart();
  }

  Future<void> _confirmAndStart() async {
    setState(() {
      isConfirming = true;
      errorMessage = null;
    });

    try {
      final confirmRes = await http.post(
        Uri.parse("http://${AppConstants.baseUrl}/api/transfer/confirm/"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"transfer_id": int.parse(widget.transferId)}),
      );

      if (confirmRes.statusCode != 200) {
        final err = json.decode(confirmRes.body)['error'] ?? "Erreur confirmation";
        setState(() {
          errorMessage = err.contains("délai") ? "Délai dépassé – paiement non confirmé" : err;
          status = "failed";
          isFinal = true;
        });
        return;
      }

      setState(() {
        isConfirming = false;
        status = "pending";
      });

      _startPolling();

    } catch (e) {
      setState(() {
        errorMessage = "Erreur réseau";
        status = "failed";
        isFinal = true;
      });
    }
  }

  void _startPolling() {
    _fetchStatus();
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

        if (isDone) {
          _timer?.cancel();
          setState(() {
            status = newStatus;
            isFinal = true;
          });
        }
      }
    } catch (e) {
      print("Polling MTN error: $e");
    }
  }

  Future<void> _launchUSSD() async {
    final Uri ussdUri = Uri(scheme: 'tel', path: '*133*1#');
    if (await canLaunchUrl(ussdUri)) {
      await launchUrl(ussdUri);
    } else {
      Get.snackbar("Erreur", "Impossible d'ouvrir le composeur USSD", backgroundColor: Colors.red, colorText: Colors.white);
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
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text("Paiement MTN MoMo"),
          border: null,
          automaticallyImplyLeading: false,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.08),
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

                    // Message USSD + bouton cliquable (seulement en attente)
                    if (!isFinal && !isConfirming) ...[
                      const SizedBox(height: 20),
                      const Text(
                        "Compose ce code sur ton téléphone",
                        style: TextStyle(fontSize: 18, color: CupertinoColors.label, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _launchUSSD,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: width * 0.04, horizontal: width * 0.08),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9A825),
                            borderRadius: BorderRadius.circular(width * 0.04),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFF9A825).withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            "*133*1#",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.09,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                            ),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 40),

                    // Bouton retour quand terminé
                    if (isFinal)
                      SizedBox(
                        width: 240,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9A825), // Jaune MTN officiel
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFF9A825).withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
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

                    // Message d’erreur si confirm échoue
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(fontSize: 16, color: CupertinoColors.systemRed),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
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
          const Icon(CupertinoIcons.checkmark_seal_fill, size: 100, color: Color(0xFFF9A825)),
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
    if (status == "pending") return "En attente MTN...";
    if (status == "success") return "Confirmé !";
    return "Échec";
  }
}