// lib/controller/inter_transfer_controller.dart → VERSION PRO 2025
import 'package:get/get.dart';
import '../services/fees_config.dart';

// lib/view/screens/confirm_transfer_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:six_cash/features/setting/controllers/profile_screen_controller.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import '../../inter-reseaux/controller/inter_transfert_controller.dart';

class InterTransferController extends GetxController {
  String? senderOperator;
  String? senderNumber;
  String? receiverOperator;
  String? receiverNumber;

  // Montants réactifs
  final RxDouble amountToReceive = 0.0.obs;
  final RxDouble totalToPay = 0.0.obs;
  final RxDouble networkFees = 0.0.obs;
  final RxDouble buudiCommission = 0.0.obs;

  Map<String, dynamic> feesConfig = {};

  // ID du transfert en cours (important pour le polling/status)
  String? currentTransferId;


  final userinfo = Get.find<ProfileController>();

  @override
  void onInit() async {
    super.onInit();
    feesConfig = await FeesService.getFees();
    
    // Si jamais c'est vide (impossible normalement), on force le fallback
    if (!feesConfig.containsKey('operators') || !feesConfig.containsKey('buudi_commission_percent')) {
      feesConfig = await FeesService.getFees(); // on réessaie
    }
    
    update();
  }

  void setTransferDetails({
    required String senderOp,
    required String senderNum,
    required String receiverOp,
    required String receiverNum,
  }) {
    senderOperator = senderOp.toLowerCase();
    senderNumber = senderNum;
    receiverOperator = receiverOp.toLowerCase();
    receiverNumber = receiverNum;
    update();
  }

  // CORRIGÉ : on accepte String (ce que donne le TextField)
  void updateFromReceived(String rawValue) {
    final clean = rawValue.replaceAll(RegExp(r'[^0-9]'), '');
    final value = clean.isEmpty ? 0.0 : double.tryParse(clean) ?? 0.0;

    if (senderOperator == null || receiverOperator == null || value < 100) {
      amountToReceive.value = value;
      totalToPay.value = 0.0;
      networkFees.value = 0.0;
      buudiCommission.value = 0.0;
      return;
    }

    amountToReceive.value = value;

    final opFrom = feesConfig['operators'][senderOperator] ?? {"payin_percent": 2.0};
    final opTo = feesConfig['operators'][receiverOperator] ?? {"payout_percent": 2.0};
    final buudiRate = (feesConfig['buudi_commission_percent'] ?? 1.5) / 100;

    final payin = value * (opFrom['payin_percent'] / 100);
    final payout = value * (opTo['payout_percent'] / 100);
    final commission = value * buudiRate;

    networkFees.value = payin + payout;
    buudiCommission.value = commission;
    totalToPay.value = (value + networkFees.value + buudiCommission.value).roundToDouble();
  }

  bool get canProceed =>
      amountToReceive.value >= 100 &&
      senderOperator != null &&
      receiverOperator != null &&
      senderNumber != null &&
      receiverNumber != null;
}



// lib/controller/inter_transfert_controller.dart → VERSION CORRIGÉE

