// lib/view/screens/home_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/features/setting/controllers/profile_screen_controller.dart';
import 'package:six_cash/util/images.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';
import 'package:six_cash/features/inter-reseaux/screens/all_history.dart';
import '../services/constant.dart';



class HomeInterScreen extends StatefulWidget {
  @override
  State<HomeInterScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeInterScreen> {
  final userinfo = Get.find<ProfileController>();
  final TextEditingController _searchController = TextEditingController();

  List<TransactionModel> recentTransactions = [];
  List<TransactionModel> filteredTransactions = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchRecentTransactions();
    _searchController.addListener(_filterTransactions);
  }

  Future<void> fetchRecentTransactions() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    final phone = userinfo.userInfo?.phone ?? "0000000000";
    final transactions = await TransactionService.getRecentTransactions(phone);

    setState(() {
      recentTransactions = transactions.take(5).toList();
      filteredTransactions = recentTransactions;
      isLoading = false;
    });
  }

  void _filterTransactions() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredTransactions = recentTransactions;
      } else {
        filteredTransactions = recentTransactions.where((tx) {
          return tx.toPhone.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  String _getLogo(String wallet) {
    final op = wallet.replaceAll('-ci', '').toLowerCase();
    switch (op) {
      case 'wave':
        return Images.wavelogo;
      case 'moov':
        return Images.moovlogo;
      case 'orange-money':
        return Images.orangelogo;
      case 'mtn':
        return Images.mtnlogo;
      default:
        return Images.wavelogo;
    }
  }

  String formatDate(DateTime date) {
    const months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jui', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return "$day $month $year • $hour:$minute";
  }

  String getStatusLabel(String status) {
    switch (status) {
      case 'created': return 'Création…';
      case 'invoice_sent': return 'Facture envoyée';
      case 'debited': return 'Montant débité';
      case 'disbursing': return 'Crédit en cours';
      case 'success': return 'Réussi';
      case 'failed': return 'Échoué';
      default: return 'échec';
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'success': return CupertinoColors.systemGreen;
      case 'failed': return CupertinoColors.systemRed;
      case 'invoice_sent': return CupertinoColors.systemOrange;
      case 'debited': return CupertinoColors.activeBlue;
      case 'disbursing': return CupertinoColors.systemPurple;
      default: return CupertinoColors.systemGrey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case 'success': return CupertinoIcons.checkmark_circle_fill;
      case 'failed': return CupertinoIcons.xmark_circle_fill;
      case 'invoice_sent': return CupertinoIcons.doc_text;
      case 'debited': return CupertinoIcons.creditcard;
      case 'disbursing': return CupertinoIcons.arrow_2_circlepath;
      default: return CupertinoIcons.clock;
    }
  }

  void _goHome() => Get.offAllNamed('/home');

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(backgroundColor: CupertinoColors.systemBackground),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30),

            // BOUTON NOUVEAU TRANSFERT
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () => Get.toNamed('/inter_transfer'),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: CupertinoColors.activeBlue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      "Nouveau transfert",
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 40),

            // TITRE + RECHERCHE
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Derniers transferts", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      if (recentTransactions.isNotEmpty)
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Text("Voir tout", style: TextStyle(color: CupertinoColors.activeBlue)),
                          onPressed: () => Get.toNamed('/transfer_all_history'),
                        ),
                    ],
                  ),
                  SizedBox(height: 12),
                  CupertinoSearchTextField(
                    controller: _searchController,
                    placeholder: "Rechercher par numéro destinataire",
                    borderRadius: BorderRadius.circular(12),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),

            // LISTE
            Expanded(
              child: isLoading
                  ? Center(child: CupertinoActivityIndicator(radius: 20))
                  : filteredTransactions.isEmpty
                      ? Center(
                          child: Text(
                            _searchController.text.isEmpty ? "Aucun transfert" : "Aucun résultat",
                            style: TextStyle(fontSize: 18, color: CupertinoColors.secondaryLabel),
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(), // ← CETTE LIGNE AJOUTÉE
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          itemCount: filteredTransactions.length,
                          itemBuilder: (context, index) {
                            final tx = filteredTransactions[index];

                            return GestureDetector(
                              onTap: () {
                              Get.toNamed('/transaction_detail', arguments: tx);
                              }, 
                              child: Container(
                                margin: EdgeInsets.only(bottom: 16),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey6,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    // LOGOS DYNAMIQUES
                                    Column(
                                      children: [
                                        Image.asset(_getLogo(tx.fromWallet), width: 36, height: 36),
                                        Icon(CupertinoIcons.arrow_down, size: 12, color: CupertinoColors.systemGrey),
                                        Image.asset(_getLogo(tx.toWallet), width: 36, height: 36),
                                      ],
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Réf : ${tx.paydunyaInvoiceToken}",
                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            formatDate(tx.createdAt),
                                            style: TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${tx.amountRequested}",
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(getStatusIcon(tx.status), size: 16, color: getStatusColor(tx.status)),
                                            SizedBox(width: 6),
                                            Text(
                                              getStatusLabel(tx.status),
                                              style: TextStyle(fontSize: 13, color: getStatusColor(tx.status)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}