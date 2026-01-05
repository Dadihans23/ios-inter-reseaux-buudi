// lib/view/screens/transfer_status_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../../inter-reseaux/controller/inter_transfert_controller.dart';
import '../services/constant.dart';


class TransferStatusScreen extends StatefulWidget {
  @override
  State<TransferStatusScreen> createState() => _TransferStatusScreenState();
}

class _TransferStatusScreenState extends State<TransferStatusScreen> {
  final controller = Get.find<InterTransferController>();
  Timer? _timer;
  String status = "pending";
  bool isFinal = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startPolling();
    });
  }

  void startPolling() {
    // On annule un ancien timer s'il existe
    _timer?.cancel();

    setState(() {
      status = "pending";
      isFinal = false;
    });

    _timer = Timer.periodic(Duration(seconds: 4), (timer) async {
      if (isFinal) {
        timer.cancel();
        return;
      }

      try {
        final res = await http.get(
          Uri.parse("http://${AppConstants.baseUrl}/api/transfer/${controller.currentTransferId}/status/"),
        );

        if (res.statusCode == 200) {
          final data = json.decode(res.body);

          setState(() {
            status = data['status'] ?? "pending";

            // Ultra robuste contre True/"True"/true
            final finalValue = data['final'];
            isFinal = finalValue == true ||
                      finalValue == "true" ||
                      finalValue == "True" ||
                      finalValue == 1;
          });

          if (isFinal) {
            timer.cancel();
          }
        }
      } catch (e) {
        print("Polling error: $e");
      }

      // Timeout après 20 secondes (5 × 4s)
      if (timer.tick >= 5) {
        timer.cancel();
        if (!isFinal) {
          setState(() {
            status = "timeout";
            isFinal = true;
          });
        }
      }
    });
  }

  void _retry() {
    startPolling(); // Relance tout proprement
  }

  void _goHome() {
    Get.offAllNamed('/home');
  }

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
        navigationBar: CupertinoNavigationBar(
          middle: Text("Statut du transfert"),
          border: null,
          automaticallyImplyLeading: false,  // 🔥 ENLÈVE LE BOUTON DE RETOUR

        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 600),
                    child: _buildStatusIcon(),
                    key: ValueKey(status),
                  ),

                  SizedBox(height: 40),

                  Text(
                    _getMessage(),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 20),

                  if (!isFinal && status != "timeout")
                    Text(
                      "Nous vérifions le paiement...",
                      style: TextStyle(color: CupertinoColors.secondaryLabel),
                    ),

                  SizedBox(height: 50),

                  // BOUTON PRINCIPAL SELON L'ÉTAT
                  if (isFinal) ...[
                    // Succès ou échec ou timeout → on propose Réessayer + Accueil
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      
                        SizedBox(width: 20),
                        SizedBox(
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
                      ],
                    ),
                  ] else ...[
                    // En cours → rien ou juste annuler
                    // CupertinoButton(
                    //   child: Text("Annuler"),
                    //   onPressed: _goHome,
                    // ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    if (status == "success") {
      return Icon(CupertinoIcons.checkmark_circle_fill, size: 120, color: Colors.green);
    } else if (status == "failed" || status == "timeout") {
      return Icon(CupertinoIcons.xmark_circle_fill, size: 120, color: Colors.red);
    } else {
      return CupertinoActivityIndicator(radius: 50);
    }
  }

  String _getMessage() {
    switch (status) {
      case "success":
        return "Transfert réussi !";
      case "failed":
        return "Échec de la transaction \nVérifie ton solde ou réessaie";
      case "timeout":
        return "Délai dépassé\nLe paiement n’a pas été effectué";
      default:
        return "Traitement en cours...";
    }
  }
}