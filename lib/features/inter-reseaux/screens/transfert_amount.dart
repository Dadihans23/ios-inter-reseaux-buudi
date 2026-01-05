// lib/view/screens/inter_transfer_amount_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:six_cash/helper/route_helper.dart';
import 'package:six_cash/util/images.dart';
import '../../inter-reseaux/controller/inter_transfert_controller.dart';

// lib/view/screens/confirm_transfer_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../inter-reseaux/controller/inter_transfert_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/constant.dart';


class InterTransferAmountScreen extends StatelessWidget {
  const InterTransferAmountScreen({Key? key}) : super(key: key);

  static final Map<String, OperatorInfo> operatorMap = {
    'Wave': OperatorInfo(logo: Images.wavelogo, color: const Color(0xFF00A3D9)),
    'Moov': OperatorInfo(logo: Images.moovlogo, color: const Color(0xFFF9A825)),
    'Orange': OperatorInfo(logo: Images.orangelogo, color: const Color(0xFFFF6200)),
    'MTN': OperatorInfo(logo: Images.mtnlogo, color: const Color(0xFFF9A825)),
  };

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InterTransferController>();

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Montant à transférer'),
        border: null,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.06,
            vertical: Get.height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: Get.height * 0.02),

              // RÉCAP EXPÉDITEUR / DESTINATAIRE
              _buildRecapCard(controller),

              SizedBox(height: Get.height * 0.04),

              // VOUS PAYEZ (ce que l'utilisateur débite)
              _buildCompactAmountField(
                label: "Vous payez",
                valueObs: controller.totalToPay,
                onChanged: (_) {}, // désactivé : calculé automatiquement
                suffixColor: CupertinoColors.systemGrey,
                enabled: false,
              ),

              SizedBox(height: Get.height * 0.025),

              // LE DESTINATAIRE REÇOIT (champ éditable)
              _buildCompactAmountField(
                label: "Le destinataire reçoit",
                valueObs: controller.amountToReceive,
                onChanged: controller.updateFromReceived,
                suffixColor: CupertinoColors.activeBlue,
                isReceived: true,
              ),

              SizedBox(height: Get.height * 0.04),

              // RÉSUMÉ DES FRAIS (réactivé et propre)
              Obx(() => _buildFeesSummary(controller)),

              SizedBox(height: Get.height * 0.06),

              // BOUTON CONTINUER
              Obx(() => CupertinoButton(
                    padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
                    color: controller.canProceed
                        ? CupertinoColors.activeBlue
                        : CupertinoColors.inactiveGray,
                    borderRadius: BorderRadius.circular(14),
                    onPressed: controller.canProceed
                        ? () async {
            // VÉRIFICATION MONTANT MINIMUM 200 FCFA
                          if (controller.amountToReceive.value < 200) {
                            Get.dialog(
                              CupertinoAlertDialog(
                                title: Text("Montant minimum requis"),
                                content: Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    "Le montant minimum pour un transfert est de 200 FCFA.",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                actions: [
                                  CupertinoDialogAction(
                                    child: Text("OK", style: TextStyle(color: CupertinoColors.activeBlue, fontWeight: FontWeight.w600)),
                                    onPressed: () => Get.back(),
                                  ),
                                ],
                              ),
                              barrierDismissible: false,
                            );
                            return;
                          }

                          // Si tout est bon → on continue
                            HapticFeedback.mediumImpact();
                            Get.toNamed(RouteHelper.initiateInterTransfert);
                         
                        }
                        
                        
                        
                        : null,
                    child: Text(
                      "Continuer",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: controller.canProceed
                            ? CupertinoColors.white
                            : CupertinoColors.white.withOpacity(0.6),
                      ),
                    ),
                  )),

              SizedBox(height: Get.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  // Champ montant (avec option désactivé)
  Widget _buildCompactAmountField({
    required String label,
    required RxDouble valueObs,
    required void Function(String) onChanged,
    required Color suffixColor,
    bool isReceived = false,
    bool enabled = true,
  }) {
    final TextEditingController textCtrl = TextEditingController();

    ever(valueObs, (_) {
      final formatted = NumberFormat('#,###', 'fr_FR')
          .format(valueObs.value.round())
          .replaceAll(',', ' ');
      if (textCtrl.text != formatted) {
        textCtrl.text = formatted;
        textCtrl.selection = TextSelection.fromPosition(
          TextPosition(offset: textCtrl.text.length),
        );
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: CupertinoColors.secondaryLabel,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        CupertinoTextField(
          controller: textCtrl,
          keyboardType: enabled ? TextInputType.number : null,
          placeholder: "0",
          textAlign: TextAlign.center,
          enabled: enabled,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
            color: enabled ? null : CupertinoColors.secondaryLabel,
          ),
          inputFormatters: enabled
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                  _AmountInputFormatter(),
                ]
              : [],
          onChanged: enabled ? onChanged : null,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: enabled
                ? CupertinoColors.secondarySystemBackground
                : CupertinoColors.quaternarySystemFill,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: CupertinoColors.separator.withOpacity(enabled ? 0.3 : 0.1),
              width: 0.8,
            ),
          ),
          suffix: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              "XOF",
              style: TextStyle(
                fontSize: 18,
                fontWeight: isReceived ? FontWeight.w600 : FontWeight.w500,
                color: suffixColor,
              ),
            ),
          ),
          suffixMode: OverlayVisibilityMode.always,
        ),
      ],
    );
  }

  // RÉSUMÉ DES FRAIS (réactivé et magnifique)
  Widget _buildFeesSummary(InterTransferController c) {
    if (c.amountToReceive.value < 100) {
      return const SizedBox();
    }

    return Container(
      padding: EdgeInsets.all(Get.width * 0.05),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: CupertinoColors.separator.withOpacity(0.3), width: 0.8),
      ),
      child: Column(
        children: [
          _feeRow("ton ami recevra", "${c.amountToReceive.value.round()} XOF",
              valueStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: CupertinoColors.activeBlue)),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: CupertinoColors.separator),
          ),
          _feeRow(
            "Total à payer",
            "${c.totalToPay.value.round()} XOF",
            valueStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _feeRow(String label, String value, {Color? color, TextStyle? valueStyle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 15, color: CupertinoColors.secondaryLabel)),
        Text(value,
            style: valueStyle ??
                TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: color,
                )),
      ],
    );
  }

  Widget _buildRecapCard(InterTransferController c) {

    if (c.senderOperator == null || c.receiverOperator == null) {
    return const SizedBox(); // ou un loader, ou un placeholder
  }

 final senderInfo = operatorMap.entries
    .firstWhere((e) => e.key.toLowerCase() == (c.senderOperator ?? '').toLowerCase())
    .value;

final receiverInfo = operatorMap.entries
    .firstWhere((e) => e.key.toLowerCase() == (c.receiverOperator ?? '').toLowerCase())
    .value;
   

   

    return Container(
      padding: EdgeInsets.all(Get.width * 0.05),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CupertinoColors.separator.withOpacity(0.3), width: 0.8),
      ),
      child: Column(
        children: [
          _recapRow("Expéditeur", senderInfo, c.senderNumber!, c.senderOperator!),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Icon(CupertinoIcons.arrow_down, size: 28, color: CupertinoColors.systemGrey3),
          ),
          _recapRow("Destinataire", receiverInfo, c.receiverNumber!, c.receiverOperator!),
        ],
      ),
    );
  }

  Widget _recapRow(String label, OperatorInfo info, String number, String operatorName) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(info.logo, width: 40, height: 40),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 13, color: CupertinoColors.secondaryLabel)),
              const SizedBox(height: 2),
              Text("+225 $number",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Text(operatorName,
                  style: TextStyle(fontSize: 13, color: info.color, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}

class OperatorInfo {
  final String logo;
  final Color color;
  const OperatorInfo({required this.logo, required this.color});
}

class _AmountInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(' ', '');
    if (text.isEmpty) return newValue.copyWith(text: '');
    final number = int.tryParse(text) ?? 0;
    final formatted = NumberFormat('#,###', 'fr_FR').format(number).replaceAll(',', ' ');
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}