import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/custom_fab.dart';
import '../widgets/search_filter_bar.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'new_currency_purchase_screen.dart';
import '../core/models/wallet.dart';
import '../core/models/currency_transaction.dart';
import '../core/dao/wallet_dao.dart';
import '../core/dao/currency_transaction_dao.dart';
import '../core/dao/userDAO.dart';
import '../core/models/user.dart';

class BalancesScreen extends StatefulWidget {
  const BalancesScreen({super.key});

  @override
  State<BalancesScreen> createState() => _BalancesScreenState();
}

class _BalancesScreenState extends State<BalancesScreen> {
  User? _currentUser;
  List<Wallet>? _wallets;
  List<CurrencyTransaction>? _transactions;
  double _totalBrl = 0.0;
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await UserDAO().getUser('nicole@exemplo.com', '123');
    if (user != null) {
      final wallets = await WalletDAO().getWalletsByUser(user.id!);
      final transactions = await CurrencyTransactionDAO().getTransactionsByUser(user.id!);
      
      double total = 0.0;
      for (var w in wallets) {
        total += (w.balance * w.averageVet);
      }
      
      if (mounted) {
        setState(() {
          _currentUser = user;
          _wallets = wallets;
          _transactions = transactions;
          _totalBrl = total;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollCarousel(bool forward) {
    final double target = forward 
        ? _scrollController.offset + (MediaQuery.of(context).size.width * 0.45 + 16)
        : _scrollController.offset - (MediaQuery.of(context).size.width * 0.45 + 16);
    
    _scrollController.animateTo(
      target.clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Color _getCurrencyColor(String currency) {
    if (currency == 'Euro') return AppColors.euroColor;
    if (currency == 'Dólar') return AppColors.dollarColor;
    
    // Gera uma cor consistente baseada no nome da moeda
    int hash = 0;
    for (int i = 0; i < currency.length; i++) {
      hash = currency.codeUnitAt(i) + ((hash << 5) - hash);
    }
    final double hue = (hash % 360).abs().toDouble();
    return HSVColor.fromAHSV(1.0, hue, 0.6, 0.9).toColor();
  }

  String _getCurrencyCode(String currency) {
    if (currency == 'Euro') return 'EUR';
    if (currency == 'Dólar') return 'USD';
    if (currency == 'Libra') return 'GBP';
    return currency.toUpperCase().substring(0, currency.length >= 3 ? 3 : currency.length);
  }

  String _getCurrencySymbol(String currency) {
    if (currency == 'Euro') return '€';
    if (currency == 'Dólar') return 'US\$';
    if (currency == 'Libra') return '£';
    return _getCurrencyCode(currency);
  }

  Widget _buildCurrencyCard(String code, String balance, String convertedValue, String vet, Color cardColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardColor.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(color: cardColor.withOpacity(0.15), blurRadius: 8, spreadRadius: -2, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(code, style: const TextStyle(color: AppColors.offWhite, fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(balance, style: const TextStyle(color: AppColors.offWhite, fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(convertedValue, style: const TextStyle(color: AppColors.offWhite, fontSize: 18)),
          Text("VET: $vet", style: const TextStyle(color: AppColors.offWhite, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildPurchaseItem(CurrencyTransaction transaction, Color color) {
    return Dismissible(
      key: ValueKey(transaction.id ?? transaction.date),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppColors.cardBackground,
            title: const Text("Excluir Compra", style: TextStyle(color: Colors.white)),
            content: const Text("Tem certeza que deseja excluir esta compra de moeda?", style: TextStyle(color: Colors.white70)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancelar", style: TextStyle(color: Colors.white))),
              TextButton(
                onPressed: () async {
                  // TODO: Lógica de excluir a transaction e re-calcular o Wallet
                  await CurrencyTransactionDAO().deleteTransaction(transaction.id!);
                  
                  // Atualizar o wallet (recalcular saldo)
                  final walletDao = WalletDAO();
                  final wallet = await walletDao.getWallet(transaction.userId, transaction.currency);
                  if (wallet != null) {
                    final newBalance = wallet.balance - transaction.amount;
                    if (newBalance <= 0) {
                      await walletDao.deleteWallet(transaction.userId, transaction.currency);
                    } else {
                      // Recalcula o VET real
                      double totalBrlAntigo = wallet.balance * wallet.averageVet;
                      double novoTotalBrl = totalBrlAntigo - transaction.amountBrl;
                      double newVet = novoTotalBrl / newBalance;

                      await walletDao.updateWallet(Wallet(
                        userId: transaction.userId,
                        currency: transaction.currency,
                        balance: newBalance,
                        averageVet: newVet,
                      ));
                    }
                  }

                  if (mounted) {
                    Navigator.pop(ctx, true);
                    _loadData();
                  }
                }, 
                child: const Text("Excluir", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
              ),
            ],
          ),
        );
      },
      child: InkWell(
        onTap: () async {
          if (_currentUser == null) return;
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewCurrencyPurchaseScreen(
                  userId: _currentUser!.id!,
                  transaction: transaction,
                ),
              ),
            );
            _loadData();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.silverBorder, width: 1),
                  ),
                  child: Icon(Icons.currency_exchange, color: color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(transaction.currency, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text(transaction.source, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("${_getCurrencySymbol(transaction.currency)} ${transaction.amount.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text("R\$ ${transaction.amountBrl.toStringAsFixed(2)}", style: const TextStyle(color: AppColors.offWhite, fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Saldos",
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              "R\$ ${_totalBrl.toStringAsFixed(2)}", // Soma de todas as moedas convertidas pelo VET
              style: const TextStyle(
                color: AppColors.moneyGreen,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            // Carrossel de Moedas Infinito
            if (_wallets == null || _wallets!.isEmpty)
              const SizedBox(
                height: 160,
                child: Center(
                  child: Text(
                    "Nenhum saldo registrado.\nCompre moedas clicando no +",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                ),
              )
            else if (_wallets!.length == 1)
              SizedBox(
                height: 160,
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8, // Largura mais centralizada para 1 item
                    child: _buildCurrencyCard(
                      _getCurrencyCode(_wallets![0].currency), 
                      _wallets![0].balance.toStringAsFixed(2), 
                      "R\$ ${(_wallets![0].balance * _wallets![0].averageVet).toStringAsFixed(2)}", 
                      "R\$ ${_wallets![0].averageVet.toStringAsFixed(2)}", 
                      _getCurrencyColor(_wallets![0].currency),
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                height: 160,
                child: Stack(
                  children: [
                    ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: _wallets!.length,
                      itemBuilder: (context, index) {
                        final wallet = _wallets![index];
                        final color = _getCurrencyColor(wallet.currency);
                        final converted = wallet.balance * wallet.averageVet;
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.45, // Ocupa metade da tela para ter 2 cards
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: _buildCurrencyCard(
                            _getCurrencyCode(wallet.currency), 
                            wallet.balance.toStringAsFixed(2), 
                            "R\$ ${converted.toStringAsFixed(2)}", 
                            "R\$ ${wallet.averageVet.toStringAsFixed(2)}", 
                            color,
                          ),
                        );
                      },
                    ),
                    if (_wallets!.length > 2) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(left: 4),
                          decoration: BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                            onPressed: () => _scrollCarousel(false),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                            onPressed: () => _scrollCarousel(true),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            
            const SizedBox(height: 32),
            
            // Barra de Busca e Filtros
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SearchFilterBar(
                onFilterTap: () {},
                onSortTap: () {},
                onSearchChanged: (value) {},
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Lista de Compras de Moeda
            Expanded(
              child: _transactions == null || _transactions!.isEmpty
                ? const Center(child: Text("Nenhuma compra recente.", style: TextStyle(color: Colors.white54)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    itemCount: _transactions!.length,
                    itemBuilder: (context, index) {
                      final transaction = _transactions![index];
                      final color = _getCurrencyColor(transaction.currency);
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0 || _transactions![index].date != _transactions![index-1].date)
                            Padding(
                              padding: const EdgeInsets.only(top: 24, bottom: 8),
                              child: Text(
                                transaction.date,
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          _buildPurchaseItem(transaction, color),
                          const Divider(color: AppColors.silverBorder, height: 1),
                          if (index == _transactions!.length - 1)
                            const SizedBox(height: 80),
                        ],
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
      
      floatingActionButton: CustomFAB(
        onPressed: () async {
          if (_currentUser == null) return;
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewCurrencyPurchaseScreen(userId: _currentUser!.id!),
            ),
          );
          _loadData();
        },
      ),
      
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1, // 1 é o índice de "Saldos"
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 2) {
             Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
      ),
    );
  }
}
