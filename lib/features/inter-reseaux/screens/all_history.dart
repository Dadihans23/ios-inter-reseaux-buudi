// lib/view/screens/transfer_all_history_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/features/setting/controllers/profile_screen_controller.dart';
import 'package:six_cash/util/images.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';
import 'package:six_cash/features/inter-reseaux/screens/detail_transaction.dart';

class TransferAllHistoryScreen extends StatefulWidget {
  @override
  State<TransferAllHistoryScreen> createState() => _TransferAllHistoryScreenState();
}

class _TransferAllHistoryScreenState extends State<TransferAllHistoryScreen> {
  final userinfo = Get.find<ProfileController>();
  final TextEditingController _searchController = TextEditingController();

  List<TransactionModel> allTransactions = [];
  List<TransactionModel> filteredTransactions = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchAllTransactions();
    _searchController.addListener(_filterTransactions);
  }

  Future<void> fetchAllTransactions() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    final phone = userinfo.userInfo?.phone ?? "0000000000";
    final transactions = await TransactionService.getRecentTransactions(phone);

    setState(() {
      allTransactions = transactions;
      filteredTransactions = allTransactions;
      isLoading = false;
    });
  }

  void _filterTransactions() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredTransactions = allTransactions;
      } else {
        filteredTransactions = allTransactions.where((tx) {
          return tx.toPhone.toLowerCase().contains(query) ||
                 tx.fromPhone.toLowerCase().contains(query) ||
                 tx.paydunyaInvoiceToken.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  String _getLogo(String wallet) {
    final op = wallet.replaceAll('-ci', '').toLowerCase();
    switch (op) {
      case 'wave': return Images.wavelogo;
      case 'moov': return Images.moovlogo;
      case 'orange-money': return Images.orangelogo;
      case 'mtn': return Images.mtnlogo;
      default: return Images.wavelogo;
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

  // STATUT SIMPLIFIÉ POUR L'UTILISATEUR
  String getSimpleStatusLabel(String status) {
    if (status == 'success') return 'Réussi';
    if (status == 'failed') return 'Échoué';
    return 'En cours'; // Tous les autres (created, invoice_sent, debited, disbursing)
  }

  Color getSimpleStatusColor(String status) {
    if (status == 'success') return CupertinoColors.systemGreen;
    if (status == 'failed') return CupertinoColors.systemRed;
    return CupertinoColors.activeOrange; // En cours
  }

  IconData getSimpleStatusIcon(String status) {
    if (status == 'success') return CupertinoIcons.checkmark_circle_fill;
    if (status == 'failed') return CupertinoIcons.xmark_circle_fill;
    return CupertinoIcons.arrow_2_circlepath; // En cours
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double horizontalPadding = width * 0.05; // 5% des côtés

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Historique complet", style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: CupertinoColors.systemBackground,
      ),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: width * 0.05),

            // CHAMP DE RECHERCHE
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: "Rechercher par numéro ou référence",
                borderRadius: BorderRadius.circular(14),
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),

            SizedBox(height: width * 0.05),

            // LISTE COMPLÈTE
            Expanded(
              child: isLoading
                  ? Center(child: CupertinoActivityIndicator(radius: 25))
                  : filteredTransactions.isEmpty
                      ? Center(
                          child: Text(
                            _searchController.text.isEmpty ? "Aucun transfert" : "Aucun résultat",
                            style: TextStyle(fontSize: 18, color: CupertinoColors.secondaryLabel),
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(), // ← CETTE LIGNE AJOUTÉE
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          itemCount: filteredTransactions.length,
                          itemBuilder: (context, index) {
                            final tx = filteredTransactions[index];

                            return GestureDetector(
                              onTap: () {
                              Get.toNamed('/transaction_detail', arguments: tx);
                              },      
                              child: Container(
                                margin: EdgeInsets.only(bottom: width * 0.04),
                                padding: EdgeInsets.all(width * 0.02),
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey6,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // LOGOS DYNAMIQUES
                                    Column(
                                      children: [
                                        Image.asset(_getLogo(tx.fromWallet), width: width * 0.1, height: width * 0.1),
                                        Icon(CupertinoIcons.arrow_down, size: 14, color: CupertinoColors.systemGrey),
                                        Image.asset(_getLogo(tx.toWallet), width: width * 0.1, height: width * 0.1),
                                      ],
                                    ),
                              
                                    SizedBox(width: width * 0.04),
                              
                                    // RÉFÉRENCE + DATE — PREND SA TAILLE NATURELLE
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Réf : ${tx.paydunyaInvoiceToken}",
                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 6),
                                          Text(
                                            formatDate(tx.createdAt),
                                            style: TextStyle(fontSize: 13, color: CupertinoColors.secondaryLabel),
                                          ),
                                        ],
                                      ),
                                    ),
                              
                                    // MONTANT + STATUT — STATUT PEUT REVENIR À LA LIGNE
                                    Flexible(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "${tx.amountRequested}",
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                getSimpleStatusIcon(tx.status),
                                                size: 16,
                                                color: getSimpleStatusColor(tx.status),
                                              ),
                                              SizedBox(width: 8),
                                              Flexible(
                                                child: Text(
                                                  getSimpleStatusLabel(tx.status),
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: getSimpleStatusColor(tx.status),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
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