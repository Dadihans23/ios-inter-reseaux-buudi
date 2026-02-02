// lib/view/screens/inter_transfer_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:six_cash/helper/route_helper.dart';
import 'package:six_cash/util/images.dart';
import '../../inter-reseaux/controller/inter_transfert_controller.dart';
import 'package:get/get.dart';
import 'package:six_cash/features/setting/controllers/profile_screen_controller.dart';

class InterTransferScreen extends StatefulWidget {
  const InterTransferScreen({Key? key}) : super(key: key);

  @override
  State<InterTransferScreen> createState() => _InterTransferScreenState();
}

class _InterTransferScreenState extends State<InterTransferScreen> {
  // Liste des opérateurs (inchangée)
  final List<Map<String, dynamic>> operators = [
    {'name': 'Wave', 'logo': Images.wavelogo, 'color': const Color(0xFF00A3D9)},
    {'name': 'Moov', 'logo': Images.moovlogo, 'color': const Color(0xFFF9A825)},
    {'name': 'Orange', 'logo': Images.orangelogo, 'color': const Color(0xFFFF6200)},
    {'name': 'MTN', 'logo': Images.mtnlogo, 'color': const Color(0xFFF9A825)},
  ];

  // Règles de préfixe (inchangée)
  Map<String, List<String>> prefixRules = {
    'Wave': [],
    'Moov': ['01', '02', '03'],
    'Orange': ['07', '08', '09'],
    'MTN': ['04', '05', '06'],
  };

  // États locaux
  String? selectedSender;
  String? selectedReceiver;
  final TextEditingController _senderCtrl = TextEditingController();
  final TextEditingController _receiverCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  // Controller GetX
  late final InterTransferController controller;

  // Récupération du numéro Buudi du user connecté
  final userProfile = Get.find<ProfileController>();

  // Numéro Buudi nettoyé (sans +225, seulement 10 chiffres)
  String get buudiPhoneClean {
    String raw = userProfile.userInfo?.phone ?? "";
    // On enlève +225 ou tout autre préfixe non numérique
    String cleaned = raw.replaceAll(RegExp(r'[^0-9]'), '');
    // On garde seulement les 10 derniers chiffres si plus long
    return cleaned.length >= 10 ? cleaned.substring(cleaned.length - 10) : cleaned;
  }

  // Validation du bouton Suivant
  bool get canProceed {
    final senderError = _validatePhone(_senderCtrl.text, selectedSender);
    final receiverError = _validatePhone(_receiverCtrl.text, selectedReceiver);

    return selectedSender != null &&
        selectedReceiver != null &&
        _senderCtrl.text.length == 10 &&
        _receiverCtrl.text.length == 10 &&
        senderError == null &&
        receiverError == null;
  }

  @override
  void initState() {
    super.initState();

    controller = Get.put(InterTransferController());

    _senderCtrl.addListener(_updateState);
    _receiverCtrl.addListener(_updateState);
  }

  void _updateState() => setState(() {});

  // Détection automatique de l’opérateur depuis le numéro (10 chiffres)
  String? _detectOperatorFromPhone(String phone) {
    if (phone.length != 10) return null;
    final prefix = phone.substring(0, 2);

    if (prefixRules['Moov']!.contains(prefix)) return 'Moov';
    if (prefixRules['Orange']!.contains(prefix)) return 'Orange';
    if (prefixRules['MTN']!.contains(prefix)) return 'MTN';
    return 'Wave'; // Par défaut
  }

  // Validation préfixe (inchangée)
  String? _validatePhone(String? phone, String? operator) {
    if (phone == null || phone.length != 10 || operator == null) return null;

    final prefix = phone.substring(0, 2);
    final allowedPrefixes = prefixRules[operator] ?? [];

    if (operator == 'Wave') return null;

    if (!allowedPrefixes.contains(prefix)) {
      return "Numéro invalide pour $operator\nDoit commencer par ${allowedPrefixes.join(', ')}";
    }
    return null;
  }

  void _showInvalidNumberAlert(String message) {
    Get.dialog(
      CupertinoAlertDialog(
        title: Text("Numéro invalide"),
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

  // Nettoyage du numéro de téléphone (retirer espaces, tirets, préfixe +225)
  String _cleanPhone(String raw) {
    String digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.startsWith('225') && digits.length > 10) {
      digits = digits.substring(3);
    }
    if (digits.length > 10) {
      digits = digits.substring(digits.length - 10);
    }
    return digits;
  }

  // Ouvrir le sélecteur de contacts
  Future<void> _pickContact() async {
    final status = await Permission.contacts.request();
    if (status != PermissionStatus.granted) {
      Get.dialog(
        CupertinoAlertDialog(
          title: const Text("Permission requise"),
          content: const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "L'accès aux contacts est nécessaire pour sélectionner un destinataire.",
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text("Annuler"),
              onPressed: () => Get.back(),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text("Ouvrir les réglages"),
              onPressed: () {
                Get.back();
                openAppSettings();
              },
            ),
          ],
        ),
      );
      return;
    }

    final contacts = await FlutterContacts.getContacts(withProperties: true, withPhoto: false);
    if (contacts.isEmpty) return;

    // Filtrer les contacts qui ont au moins un numéro
    final contactsWithPhone = contacts.where((c) => c.phones.isNotEmpty).toList();

    if (!mounted) return;

    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => _ContactPickerSheet(
        contacts: contactsWithPhone,
        onSelected: (phone) {
          final cleaned = _cleanPhone(phone);
          setState(() {
            _receiverCtrl.text = cleaned;
            final detected = _detectOperatorFromPhone(cleaned);
            if (detected != null) {
              selectedReceiver = detected;
            }
          });
        },
      ),
    );
  }

  // Suggestion "Utiliser mon numéro Buudi" — avec numéro nettoyé
  Widget _buildBuudiPhoneSuggestion() {
    final cleanPhone = buudiPhoneClean;
    if (cleanPhone.isEmpty || cleanPhone == _senderCtrl.text) return const SizedBox.shrink();

    final detectedOp = _detectOperatorFromPhone(cleanPhone);

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _senderCtrl.text = cleanPhone; // On met les 10 chiffres sans +225
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
              SizedBox(width: 04),
              Text(
                "Utiliser ce numéro : $cleanPhone",
                style: TextStyle(
                  color: CupertinoColors.activeBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1
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

                        // Suggestion numéro Buudi (avec numéro nettoyé)
                        _buildBuudiPhoneSuggestion(),

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
                          showContactPicker: true,
                        ),

                        const SizedBox(height: 32),

                        // BOUTON SUIVANT
                        SizedBox(
                          width: double.infinity,
                          child: CupertinoButton(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            color: canProceed ? CupertinoColors.activeBlue : CupertinoColors.inactiveGray,
                            borderRadius: BorderRadius.circular(12),
                            onPressed: canProceed
                                ? () {
                                    HapticFeedback.mediumImpact();

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

                                    controller.setTransferDetails(
                                      senderOp: selectedSender!,
                                      senderNum: _senderCtrl.text,
                                      receiverOp: selectedReceiver!,
                                      receiverNum: _receiverCtrl.text,
                                    );
                                    controller.update();
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
    bool showContactPicker = false,
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
          suffix: showContactPicker
              ? GestureDetector(
                  onTap: enabled ? _pickContact : null,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      CupertinoIcons.person_crop_circle,
                      size: 28,
                      color: enabled ? CupertinoColors.activeBlue : CupertinoColors.inactiveGray,
                    ),
                  ),
                )
              : null,
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
    super.dispose();
  }
}

/// Bottom sheet pour sélectionner un contact du téléphone
class _ContactPickerSheet extends StatefulWidget {
  final List<Contact> contacts;
  final ValueChanged<String> onSelected;

  const _ContactPickerSheet({
    required this.contacts,
    required this.onSelected,
  });

  @override
  State<_ContactPickerSheet> createState() => _ContactPickerSheetState();
}

class _ContactPickerSheetState extends State<_ContactPickerSheet> {
  String _search = '';

  List<Contact> get _filtered {
    if (_search.isEmpty) return widget.contacts;
    final query = _search.toLowerCase();
    return widget.contacts.where((c) {
      final name = c.displayName.toLowerCase();
      final phones = c.phones.map((p) => p.number).join(' ');
      return name.contains(query) || phones.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.7;
    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Barre de drag
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey3,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Titre
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              "Sélectionner un contact",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ),
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CupertinoSearchTextField(
              placeholder: "Rechercher un contact",
              onChanged: (val) => setState(() => _search = val),
            ),
          ),
          const SizedBox(height: 8),
          // Liste de contacts
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Text(
                      "Aucun contact trouvé",
                      style: TextStyle(color: CupertinoColors.systemGrey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final contact = _filtered[index];
                      final phone = contact.phones.first.number;
                      return CupertinoListTile(
                        leading: const Icon(CupertinoIcons.person_circle, size: 36),
                        title: Text(
                          contact.displayName,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(phone),
                        onTap: () {
                          Navigator.of(context).pop();
                          widget.onSelected(phone);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}