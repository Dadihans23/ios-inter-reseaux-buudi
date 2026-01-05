// lib/view/screens/otp_or_ussd_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:six_cash/features/inter-reseaux/screens/moov_otp.dart';
import 'package:six_cash/features/inter-reseaux/screens/mtn_otp.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import '../../inter-reseaux/controller/inter_transfert_controller.dart';
import '../screens/moov_otp.dart'; // IMPORT IMPORTANT !
import '../services/constant.dart';


class OtpOrUssdScreen extends StatefulWidget {
  @override
  State<OtpOrUssdScreen> createState() => _OtpOrUssdScreenState();
}

class _OtpOrUssdScreenState extends State<OtpOrUssdScreen> {
  final controller = Get.find<InterTransferController>();
  final Map<String, dynamic> args = Get.arguments ?? {};
  final TextEditingController otpController = TextEditingController();

  late String transferId;
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    transferId = args['transfer_id'].toString();

    // MOOV → popup automatique + polling
    if (controller.senderOperator?.toLowerCase() == 'moov') {
      _confirmMoov();
    }
  }

  Future<void> _confirmMoov() async {
    setState(() => isLoading = true);
    try {
      final res = await http.post(
        Uri.parse("http://${AppConstants.baseUrl}/api/transfer/confirm/"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"transfer_id": int.parse(transferId)}),
      );

      if (res.statusCode == 200) {
        Get.snackbar(
          "Moov",
          "Valide le paiement dans le popup",
          backgroundColor: Color(0xFFF9A825),
          colorText: Colors.white,
          duration: Duration(seconds: 5),
        );
        // ON AFFICHE L'ÉCRAN AVEC POLLING
        Get.off(() => MoovWaitingScreen(transferId: transferId));
      } else {
        setState(() => errorMessage = "Impossible de lancer Moov");
      }
    } catch (e) {
      setState(() => errorMessage = "Pas de connexion");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _submitOtp() async {
    if (otpController.text.trim().length < 4) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final res = await http.post(
        Uri.parse("http://${AppConstants.baseUrl}/api/transfer/confirm/"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "transfer_id": int.parse(transferId),
          "otp": otpController.text.trim(),
        }),
      );

      final decodedBody = utf8.decode(res.bodyBytes);
      final body = json.decode(decodedBody);

      if (res.statusCode == 200) {
        Get.offNamed('/transfer_status');
      } else {
          Get.offNamed('/transfer_status');


        
      }
    } catch (e) {
      setState(() => errorMessage = "Échec : Pas de connexion");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  // SUPPRIME _buildMoovWaitingScreen() → INUTILE
  Widget build(BuildContext context) {
    final op = (controller.senderOperator ?? '').toLowerCase();

    if (op == 'orange') return _buildOrangeScreen();
    if (op == 'mtn') return MtnWaitingScreen(transferId: transferId);
;
    
    // MOOV → ON UTILISE L'ÉCRAN POLLING DÉDIÉ
    return MoovWaitingScreen(transferId: transferId);
  }

  // ORANGE — STYLE iOS PUR
  Widget _buildOrangeScreen() {
    final width = MediaQuery.of(context).size.width;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Orange Money", style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: CupertinoColors.systemBackground,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.phone_fill, size: width * 0.22, color: Color(0xFFFF6200)),
              SizedBox(height: width * 0.1),
              Text("Compose ce code sur ton téléphone", style: TextStyle(fontSize: 18, color: CupertinoColors.label, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
              SizedBox(height: width * 0.08),
              GestureDetector(
                onTap: () => launch("tel:#144*82#"),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: width * 0.04, horizontal: width * 0.08),
                  decoration: BoxDecoration(
                    color: Color(0xFFFF6200),
                    borderRadius: BorderRadius.circular(width * 0.04),
                  ),
                  child: Text("#144*82#", style: TextStyle(color: Colors.white, fontSize: width * 0.09, fontWeight: FontWeight.bold, letterSpacing: 3)),
                ),
              ),
              SizedBox(height: width * 0.1),
              Text("Tu recevras un code OTP par SMS", style: TextStyle(fontSize: 16, color: CupertinoColors.secondaryLabel)),
              SizedBox(height: width * 0.08),
              CupertinoTextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                placeholder: "••••",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: width * 0.08, letterSpacing: 8),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                decoration: BoxDecoration(color: CupertinoColors.secondarySystemBackground, borderRadius: BorderRadius.circular(16)),
                padding: EdgeInsets.symmetric(vertical: 18),
              ),
              if (errorMessage != null) ...[
                SizedBox(height: 16),
                Text(errorMessage!, style: TextStyle(color: CupertinoColors.systemRed, fontSize: 15)),
              ],
              SizedBox(height: width * 0.1),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  borderRadius: BorderRadius.circular(16),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: isLoading ? CupertinoActivityIndicator() : Text("Valider le paiement", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  onPressed: isLoading ? null : _submitOtp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // MTN — Style iOS propre
  Widget _buildMtnScreen() {
    final width = MediaQuery.of(context).size.width;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("MTN MoMo")),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.phone_fill, size: width * 0.22, color: Color(0xFFF9A825)),
              SizedBox(height: width * 0.1),
              Text("Entre le code OTP reçu par SMS", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              SizedBox(height: width * 0.1),
              CupertinoTextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                placeholder: "123456",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: width * 0.09, letterSpacing: 10),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                decoration: BoxDecoration(color: CupertinoColors.secondarySystemBackground, borderRadius: BorderRadius.circular(16)),
                padding: EdgeInsets.symmetric(vertical: 18),
              ),
              if (errorMessage != null) ...[
                SizedBox(height: 16),
                Text(errorMessage!, style: TextStyle(color: CupertinoColors.systemRed)),
              ],
              SizedBox(height: width * 0.1),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  child: isLoading ? CupertinoActivityIndicator() : Text("Confirmer"),
                  onPressed: isLoading ? null : _submitOtp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}