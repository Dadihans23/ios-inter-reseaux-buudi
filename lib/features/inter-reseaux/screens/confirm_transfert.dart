// lib/view/screens/confirm_transfer_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:six_cash/features/setting/controllers/profile_screen_controller.dart';
import 'package:six_cash/helper/route_helper.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import '../../inter-reseaux/controller/inter_transfert_controller.dart';
import '../services/constant.dart';


class ConfirmTransferScreen extends StatefulWidget {
  @override
  State<ConfirmTransferScreen> createState() => _ConfirmTransferScreenState();
}

class _ConfirmTransferScreenState extends State<ConfirmTransferScreen> {
  final controller = Get.find<InterTransferController>();
  final userinfo = Get.find<ProfileController>();

  bool isLoading = false;
  String? errorMessage;

  Future<void> initiateTransfer() async {
    print(controller.receiverOperator);

    if (isLoading) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
     ;

      // 1. Créer le transfert
      final initRes = await http.post(
        Uri.parse("http://${AppConstants.baseUrl}/api/transfer/initiate/"),
        headers: {
          "Content-Type": "application/json",
          "X-User-Phone": "${userinfo.userInfo!.phone}",
          "X-User-Name": "${userinfo.userInfo!.lName} ${userinfo.userInfo!.fName}",

        },
        
        
        body: json.encode({
          "amount": controller.amountToReceive.value,
          "from_wallet": controller.senderOperator,
          "to_wallet": controller.receiverOperator,
          "from_phone": controller.senderNumber,
          "to_phone": controller.receiverNumber,
        }),

      );

      if (initRes.statusCode != 200) {
        setState(() => errorMessage = json.decode(initRes.body)['error'] ?? "Erreur");
        return;
      }

      final initData = json.decode(initRes.body);
      final transferId = initData['transfer_id'].toString();
      controller.currentTransferId = transferId;

      final operator = controller.senderOperator?.toLowerCase();

      // CAS 1 : WAVE → redirection directe
      if (operator == 'wave') {
        final confirmRes = await http.post(
          Uri.parse("http://${AppConstants.baseUrl}/api/transfer/confirm/"),
          headers: {"Content-Type": "application/json"},
          body: json.encode({"transfer_id": int.parse(transferId)}),
        );

        if (confirmRes.statusCode == 200) {
          final data = json.decode(confirmRes.body);
          if (data['redirect_url'] != null) {
            await launch(data['redirect_url']);
            Get.snackbar("Wave", "Valide dans l’app Wave et reviens", backgroundColor: Color(0xFF00A3D9), colorText: Colors.white);
            Future.delayed(Duration(seconds: 4), () {
              if (mounted) Get.offAllNamed('/transfer_status');
            });
            return;
          }
        }
      }
      
      else if ( operator == 'moov'){
        Get.toNamed(
        RouteHelper.moovScreen,
        arguments: {
          "transfer_id": transferId,
        },
        );
      }

      // CAS 2 : ORANGE / MTN / MOOV → on va sur l'écran OTP/USSD
      Get.toNamed(
        RouteHelper.otpScreen,
        arguments: {
          "transfer_id": transferId,
        },
      );


    } catch (e) {
      setState(() => errorMessage = "Pas de connexion");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Confirmer le transfert")),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 20),
              _buildRecap(),
              SizedBox(height: 40),
              _buildAmountRow("Reçu par le destinataire", "${controller.amountToReceive.value.round()} XOF"),
              _buildAmountRow("Total à payer", "${controller.totalToPay.value.round()} XOF", bold: true, large: true),
              Spacer(),

              if (errorMessage != null)
                Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(color: CupertinoColors.systemRed.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Text(errorMessage!, style: TextStyle(color: CupertinoColors.systemRed, fontWeight: FontWeight.w600)),
                ),

              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  color: CupertinoColors.activeBlue,
                  padding: EdgeInsets.symmetric(vertical: 18),
                  borderRadius: BorderRadius.circular(16),
                  onPressed: isLoading ? null : initiateTransfer,
                  child: isLoading
                      ? CupertinoActivityIndicator()
                      : Text("Payer ${controller.totalToPay.value.round()} FCFA", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecap() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(color: CupertinoColors.secondarySystemBackground, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Text(" ${controller.senderNumber} →  ${controller.receiverNumber}", style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          Text(
            "${controller.senderOperator?.toUpperCase()} → ${controller.receiverOperator?.toUpperCase()}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(String label, String value, {bool bold = false, bool large = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: large ? 18 : 16, color: CupertinoColors.secondaryLabel)),
          Text(value, style: TextStyle(fontSize: large ? 24 : 18, fontWeight: bold ? FontWeight.bold : FontWeight.w600)),
        ],
      ),
    );
  }
}