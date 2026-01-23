// lib/view/screens/international_transfer_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:six_cash/helper/route_helper.dart';
import 'package:six_cash/util/images.dart';
import '../../inter-reseaux/controller/inter_transfert_controller.dart';
import 'package:six_cash/features/setting/controllers/profile_screen_controller.dart';

class InternationalTransferScreen extends StatefulWidget {
  const InternationalTransferScreen({Key? key}) : super(key: key);

  @override
  State<InternationalTransferScreen> createState() => _InternationalTransferScreenState();
}

class _InternationalTransferScreenState extends State<InternationalTransferScreen> {
  // ── OPÉRATEURS EXPÉDITEUR (CÔTE D'IVOIRE FIXE) ──
  final List<Map<String, dynamic>> ciOperators = [
    {'name': 'Wave', 'logo': Images.wavelogo, 'color': const Color(0xFF00A3D9)},
    {'name': 'Moov', 'logo': Images.moovlogo, 'color': const Color(0xFFF9A825)},
    {'name': 'Orange', 'logo': Images.orangelogo, 'color': const Color(0xFFFF6200)},
    {'name': 'MTN', 'logo': Images.mtnlogo, 'color': const Color(0xFFF9A825)},
  ];

  // Règles de préfixe (identique à l'écran local)
  Map<String, List<String>> prefixRules = {
    'Wave': [],
    'Moov': ['01', '02', '03'],
    'Orange': ['07', '08', '09'],
    'MTN': ['04', '05', '06'],
  };

  // ── PAYS DESTINATAIRES ──
  final List<Map<String, dynamic>> countries = [
    {'code': 'SN', 'name': 'Sénégal', 'flag': Images.senegal},
    {'code': 'BJ', 'name': 'Bénin', 'flag': Images.benin},
    {'code': 'TG', 'name': 'Togo', 'flag': Images.togo},
    {'code': 'BF', 'name': 'Burkina Faso', 'flag': Images.bf},
    {'code': 'ML', 'name': 'Mali', 'flag': Images.mali},
  ];

  // ── OPÉRATEURS PAR PAYS (DESTINATAIRE) ──
  final Map<String, List<Map<String, dynamic>>> operatorsByCountry = {
    'SN': [
      {'name': 'orange-sénégal', 'logo': Images.orangelogo, 'color': const Color(0xFFFF6200), 'mode': 'orange-money-sn'},
      {'name': 'wave-sénégal', 'logo': Images.wavelogo, 'color': const Color(0xFF00A3D9), 'mode': 'wave-sn'},
      {'name': 'free-money-sénégal', 'logo': Images.freemoney, 'color': Colors.blue, 'mode': 'free-money-sn'},
      {'name': 'emoney-sénégal', 'logo': Images.emoney, 'color': Colors.purple, 'mode': 'e-money-sn'},
    ],
    'BJ': [
      {'name': 'mtn-bénin', 'logo': Images.mtnlogo, 'color': const Color(0xFFF9A825), 'mode': 'mtn-momo-bj'},
      {'name': 'moov-bénin', 'logo': Images.moovlogo, 'color': const Color(0xFFF9A825), 'mode': 'moov-bj'},
    ],
    'TG': [
      {'name': 'tmoney-togo', 'logo': Images.tmoney, 'color': Colors.orange, 'mode': 't-money-tg'},
      {'name': 'moov-togo', 'logo': Images.moovlogo, 'color': const Color(0xFFF9A825), 'mode': 'moov-tg'},
    ],
    'BF': [
      {'name': 'orange-faso', 'logo': Images.orangelogo, 'color': const Color(0xFFFF6200), 'mode': 'orange-money-bf'},
      {'name': 'moov-faso', 'logo': Images.moovlogo, 'color': const Color(0xFFF9A825), 'mode': 'moov-bf'},
    ],
    'ML': [
      {'name': 'orange-mali', 'logo': Images.orangelogo, 'color': const Color(0xFFFF6200), 'mode': 'orange-money-ml'},
    ],
  };

  // ── ÉTATS ──
  String? selectedSender;
  String? selectedCountry;
  String? selectedReceiver;
  final TextEditingController _senderCtrl = TextEditingController();
  final TextEditingController _receiverCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  late final InterTransferController controller;
  final userProfile = Get.find<ProfileController>();

  // ── NUMÉRO BUUDI NETTOYÉ (comme dans l'écran local) ──
  String get buudiPhoneClean {
    String raw = userProfile.userInfo?.phone ?? "";
    String cleaned = raw.replaceAll(RegExp(r'[^0-9]'), '');
    return cleaned.length >= 10 ? cleaned.substring(cleaned.length - 10) : cleaned;
  }

  // Détection opérateur depuis numéro (10 chiffres) — identique à l'écran local
  String? _detectOperatorFromPhone(String phone) {
    if (phone.length != 10) return null;
    final prefix = phone.substring(0, 2);

    if (prefixRules['Moov']!.contains(prefix)) return 'Moov';
    if (prefixRules['Orange']!.contains(prefix)) return 'Orange';
    if (prefixRules['MTN']!.contains(prefix)) return 'MTN';
    return 'Wave'; // Par défaut
  }

  // ── VALIDATION ──
  bool get canProceed =>
      selectedSender != null &&
      selectedCountry != null &&
      selectedReceiver != null &&
      _senderCtrl.text.length >= 8 &&
      _receiverCtrl.text.length >= 8;

  @override
  void initState() {
    super.initState();
    controller = Get.put(InterTransferController());
    _senderCtrl.addListener(_updateState);
    _receiverCtrl.addListener(_updateState);
  }

  void _updateState() => setState(() {});

  String? _validatePhone(String? phone, String? operator, String? country) {
    if (phone == null || phone.isEmpty) return null;
    if (country == null) return "Veuillez d'abord choisir un pays destinataire";
    if (phone.length < 8) return "Numéro trop court (minimum 8 chiffres)";
    return null;
  }

  void _showInvalidNumberAlert(String message) {
    Get.dialog(
      CupertinoAlertDialog(
        title: Text("Attention"),
        content: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(message, style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
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

  // ── SUGGESTION "UTILISER MON NUMÉRO BUUDI" (exactement comme dans l'écran local) ──
  Widget _buildBuudiPhoneSuggestion() {
    final cleanPhone = buudiPhoneClean;
    if (cleanPhone.isEmpty || cleanPhone == _senderCtrl.text) return const SizedBox.shrink();

    final detectedOp = _detectOperatorFromPhone(cleanPhone);

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _senderCtrl.text = cleanPhone; // 10 chiffres sans +225
            selectedSender = detectedOp ?? 'Wave';
          });
          controller.update();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: CupertinoColors.activeBlue.withOpacity(0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(CupertinoIcons.person_crop_circle, size: 20, color: CupertinoColors.activeBlue),
              SizedBox(width: 4),
              Text(
                "Utiliser ce numéro : $cleanPhone",
                style: TextStyle(
                  color: CupertinoColors.activeBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.05;
    final double logoSize = MediaQuery.of(context).size.width * 0.13;

    final List<Map<String, dynamic>> currentOperators = 
        operatorsByCountry[selectedCountry ?? '']?.cast<Map<String, dynamic>>() ?? [];

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: true,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Transfert International'),
      ),
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                controller: _scrollCtrl,
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        // 1. OPÉRATEUR EXPÉDITEUR
                        _buildSectionTitle("De quel opérateur en Côte d’Ivoire ?"),
                        const SizedBox(height: 12),
                        _buildOperatorRow(
                          selected: selectedSender,
                          onTap: (op) => setState(() => selectedSender = op),
                          logoSize: logoSize,
                          operators: ciOperators,
                        ),
                        const SizedBox(height: 24),

                        // 2. NUMÉRO EXPÉDITEUR + SUGGESTION BUUDI
                        _buildPhoneField(
                          label: "Numéro expéditeur (CIV)",
                          controller: _senderCtrl,
                          enabled: selectedSender != null,
                          onTap: () => _scrollToField(100),
                          prefix: "+225",
                        ),

                        // Suggestion Buudi (placée juste après le champ expéditeur)
                        _buildBuudiPhoneSuggestion(),

                        const SizedBox(height: 32),

                        // 3. PAYS DESTINATAIRE
                        _buildSectionTitle("Pays destinataire"),
                        const SizedBox(height: 12),
                        _buildCountryRow(),
                        const SizedBox(height: 32),

                        // 4. OPÉRATEUR DESTINATAIRE
                        if (selectedCountry != null) ...[
                          _buildSectionTitle("Vers quel opérateur ?"),
                          const SizedBox(height: 12),
                          _buildOperatorRow(
                            selected: selectedReceiver,
                            onTap: (op) => setState(() => selectedReceiver = op),
                            logoSize: logoSize,
                            operators: currentOperators,
                          ),
                          const SizedBox(height: 24),
                        ] else ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "Choisissez d’abord un pays pour voir les opérateurs disponibles",
                              style: TextStyle(fontSize: 14, color: CupertinoColors.systemRed, fontStyle: FontStyle.italic),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // 5. NUMÉRO DESTINATAIRE
                        _buildPhoneField(
                          label: "Numéro destinataire (international)",
                          controller: _receiverCtrl,
                          enabled: selectedReceiver != null,
                          onTap: () => _scrollToField(200),
                          prefix: _getCountryPrefix(selectedCountry),
                        ),

                        const SizedBox(height: 40),

                        // BOUTON SUIVANT
                        SizedBox(
                          width: double.infinity,
                          child: CupertinoButton(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            color: canProceed ? CupertinoColors.activeBlue : CupertinoColors.inactiveGray,
                            borderRadius: BorderRadius.circular(12),
                            onPressed: canProceed
                                ? () {
                                    print("=== DEBUG SUIVANT PRESSED ===");
                                    print("selectedSender: $selectedSender");
                                    print("senderNum: ${_senderCtrl.text}");
                                    print("selectedCountry: $selectedCountry");
                                    print("selectedReceiver: $selectedReceiver");
                                    print("receiverNum: ${_receiverCtrl.text}");

                                    HapticFeedback.mediumImpact();

                                    if (selectedCountry == null) {
                                      print("Erreur : Aucun pays sélectionné");
                                      _showInvalidNumberAlert("Veuillez sélectionner un pays destinataire");
                                      return;
                                    }
                                    if (selectedReceiver == null) {
                                      print("Erreur : Aucun opérateur destinataire sélectionné");
                                      _showInvalidNumberAlert("Veuillez sélectionner un opérateur destinataire");
                                      return;
                                    }
                                    if (_senderCtrl.text.length < 8 || _receiverCtrl.text.length < 8) {
                                      print("Erreur : Numéro(s) trop court(s)");
                                      _showInvalidNumberAlert("Les numéros doivent faire au moins 8 chiffres");
                                      return;
                                    }

                                    final senderError = _validatePhone(_senderCtrl.text, selectedSender, 'CI');
                                    final receiverError = _validatePhone(_receiverCtrl.text, selectedReceiver, selectedCountry);

                                    if (senderError != null) {
                                      print("Erreur expéditeur : $senderError");
                                      _showInvalidNumberAlert(senderError);
                                      return;
                                    }
                                    if (receiverError != null) {
                                      print("Erreur destinataire : $receiverError");
                                      _showInvalidNumberAlert(receiverError);
                                      return;
                                    }

                                    print("Tout OK → Enregistrement dans controller");
                                    controller.setTransferDetails(
                                      senderOp: selectedSender!,
                                      senderNum: _senderCtrl.text,
                                      receiverOp: selectedReceiver!,
                                      receiverNum: _receiverCtrl.text,
                                      country: selectedCountry,
                                    );
                                    controller.update();

                                    print("Navigation vers montant");
                                    Get.toNamed(RouteHelper.interTransferAmount);
                                  }
                                : null,
                            child: const Text(
                              "Suivant",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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

  // ── CHOIX DU PAYS ──
  Widget _buildCountryRow() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: countries.map((country) {
          final isSelected = selectedCountry == country['code'];
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCountry = country['code'];
                selectedReceiver = null; // Reset
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? CupertinoColors.activeBlue.withOpacity(0.15) : CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isSelected ? CupertinoColors.activeBlue : Colors.transparent, width: 2),
              ),
              child: Row(
                children: [
                  Image.asset(country['flag'], width: 26, height: 26),
                  SizedBox(width: 5),
                  Text(
                    country['name'],
                    style: TextStyle(fontSize: 16, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── PRÉFIXE PAR PAYS ──
  String _getCountryPrefix(String? country) {
    final prefixes = {
      'CI': '+225',
      'SN': '+221',
      'BJ': '+229',
      'TG': '+228',
      'BF': '+226',
      'ML': '+223',
    };
    return prefixes[country ?? 'CI'] ?? '+225';
  }

  // ── MÉTHODES COMMUNES (inchangées) ──
  Widget _buildSectionTitle(String text) {
    return Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600));
  }

  Widget _buildOperatorRow({
    required String? selected,
    required Function(String) onTap,
    required double logoSize,
    required List<Map<String, dynamic>> operators,
  }) {
    if (operators.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          "Sélectionnez d’abord un pays destinataire",
          style: TextStyle(fontSize: 14, color: CupertinoColors.systemRed, fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
      );
    }

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
              color: isSelected ? op['color'].withOpacity(0.15) : CupertinoColors.systemGrey6,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isSelected ? op['color'] : Colors.transparent, width: 2),
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
    required String prefix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        CupertinoTextField(
          controller: controller,
          enabled: enabled,
          onTap: onTap,
          prefix: Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text(prefix, style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          placeholder: "Ex: 771234567",
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(15),
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
      _scrollCtrl.animateTo(offset, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _senderCtrl.dispose();
    _receiverCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }
}