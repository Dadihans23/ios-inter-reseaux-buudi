import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:six_cash/helper/route_helper.dart';
import 'package:six_cash/util/images.dart';
import '../../inter-reseaux/controller/inter_transfert_controller.dart';
import 'package:get/get.dart';

class InterTransferScreen extends StatefulWidget {
  const InterTransferScreen({Key? key}) : super(key: key);

  @override
  State<InterTransferScreen> createState() => _InterTransferScreenState();
}

class _InterTransferScreenState extends State<InterTransferScreen> {
  // Liste des opérateurs
  final List<Map<String, dynamic>> operators = [
    {'name': 'Wave', 'logo': Images.wavelogo, 'color': const Color(0xFF00A3D9)},
    {'name': 'Moov', 'logo': Images.moovlogo, 'color': const Color(0xFFF9A825)},
    {'name': 'Orange', 'logo': Images.orangelogo, 'color': const Color(0xFFFF6200)},
    {'name': 'MTN', 'logo': Images.mtnlogo, 'color': const Color(0xFFF9A825)},
  ];






  // Ajoute ces constantes en haut du fichier
 Map<String, List<String>> prefixRules = {
  'Wave': [], // aucun préfixe requis
  'Moov': ['01', '02', '03'],
  'Orange': ['07', '08', '09'],
  'MTN': ['04', '05', '06'],
};

// Dans ta classe _InterTransferScreenState
String? _validatePhone(String? phone, String? operator) {
  if (phone == null || phone.length != 10 || operator == null) return null;

  final prefix = phone.substring(0, 2);

  final allowedPrefixes = prefixRules[operator] ?? [];

  // Wave accepte tout
  if (operator == 'Wave') return null;

  if (!allowedPrefixes.contains(prefix)) {
    return "Numéro invalide pour $operator\n . Doit commencer par ${allowedPrefixes.join(', ')}";
  }

  return null;
}








// Affiche l'alerte iOS si mauvais numéro
void _showInvalidNumberAlert(String message) {
  Get.dialog(
    CupertinoAlertDialog(
      title: Text("Numéro invalide"),
      content: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Text(
          message,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
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
}

  // États locaux
  String? selectedSender;
  String? selectedReceiver;
  final TextEditingController _senderCtrl = TextEditingController();
  final TextEditingController _receiverCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  // Référence au controller GetX
  late final InterTransferController controller;

  // Validation du bouton Suivant
 bool get canProceed {
  // final senderError = _validatePhone(_senderCtrl.text, selectedSender);
  // final receiverError = _validatePhone(_receiverCtrl.text, selectedReceiver);

  return selectedSender != null &&
      selectedReceiver != null &&
      _senderCtrl.text.length == 10 &&
      _receiverCtrl.text.length == 10 ;
      // senderError == null &&
      // receiverError == null;
}


  @override
  void initState() {
    super.initState();

    // CRUCIAL : On injecte le controller UNE SEULE FOIS ici
    controller = Get.put(InterTransferController());

    // Écoute des changements de texte
    _senderCtrl.addListener(_updateState);
    _receiverCtrl.addListener(_updateState);
  }

  void _updateState() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.05;
    final double logoSize = MediaQuery.of(context).size.width * 0.13;

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: true,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Transfert Inter-Réseaux'),
      ),
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                controller: _scrollCtrl,
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 20,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        // EXPÉDITEUR
                        _buildSectionTitle("De quel opérateur ?"),
                        const SizedBox(height: 12),
                        _buildOperatorRow(
                          selected: selectedSender,
                          onTap: (op) => setState(() => selectedSender = op),
                          logoSize: logoSize,
                        ),
                        const SizedBox(height: 24),

                        _buildPhoneField(
                          label: "Numéro expéditeur",
                          controller: _senderCtrl,
                          enabled: selectedSender != null,
                          onTap: () => _scrollToField(100),
                        ),
                        const SizedBox(height: 32),

                        // RÉCEPTEUR
                        _buildSectionTitle("Vers quel opérateur ?"),
                        const SizedBox(height: 12),
                        _buildOperatorRow(
                          selected: selectedReceiver,
                          onTap: (op) => setState(() => selectedReceiver = op),
                          logoSize: logoSize,
                        ),
                        const SizedBox(height: 24),

                        _buildPhoneField(
                          label: "Numéro destinataire",
                          controller: _receiverCtrl,
                          enabled: selectedReceiver != null,
                          onTap: () => _scrollToField(200),
                        ),

                        const SizedBox(height: 32),

                        // BOUTON SUIVANT
                        SizedBox(
                          width: double.infinity,
                          child: CupertinoButton(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            color: canProceed
                                ? CupertinoColors.activeBlue
                                : CupertinoColors.inactiveGray,
                            borderRadius: BorderRadius.circular(12),
                            onPressed: canProceed
                                ? () {
                                    HapticFeedback.mediumImpact();

                                    // Double sécurité : on revérifie avant d’aller plus loin
                                    final senderError = _validatePhone(_senderCtrl.text, selectedSender);
                                    final receiverError = _validatePhone(_receiverCtrl.text, selectedReceiver);

                                    if (senderError != null) {
                                      _showInvalidNumberAlert(senderError);
                                      return;
                                    }
                                    if (receiverError != null) {
                                      _showInvalidNumberAlert(receiverError);
                                      return;
                                    }

                                    // On sauvegarde les données dans le controller
                                    controller.setTransferDetails(
                                      senderOp: selectedSender!,
                                      senderNum: _senderCtrl.text,
                                      receiverOp: selectedReceiver!,
                                      receiverNum: _receiverCtrl.text,
                                    );
                                    controller.update();
                                    // Navigation propre
                                    Get.toNamed(RouteHelper.interTransferAmount);
                                  }
                                  
                                : null,
                            child: const Text(
                              "Suivant",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildOperatorRow({
    required String? selected,
    required Function(String) onTap,
    required double logoSize,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: operators.map((op) {
        final bool isSelected = selected == op['name'];
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            onTap(op['name']);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected
                  ? op['color'].withOpacity(0.15)
                  : CupertinoColors.systemGrey6,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? op['color'] : Colors.transparent,
                width: 2,
              ),
            ),
            child: Image.asset(
              op['logo'],
              width: logoSize,
              height: logoSize,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                CupertinoIcons.person_crop_circle,
                size: logoSize,
                color: op['color'],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPhoneField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        CupertinoTextField(
          controller: controller,
          enabled: enabled,
          onTap: onTap,
          prefix: const Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text("+225", style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          placeholder: "0123456789",
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          decoration: BoxDecoration(
            color: enabled ? CupertinoColors.white : CupertinoColors.systemGrey5,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: enabled ? CupertinoColors.systemGrey4 : CupertinoColors.systemGrey,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          style: const TextStyle(fontSize: 18, letterSpacing: 1.2),
        ),
      ],
    );
  }

  void _scrollToField(double offset) {
    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollCtrl.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _senderCtrl.dispose();
    _receiverCtrl.dispose();
    _scrollCtrl.dispose();
    // Optionnel : détruire le controller quand on quitte complètement le flow
    // Get.delete<InterTransferController>();
    super.dispose();
  }
}