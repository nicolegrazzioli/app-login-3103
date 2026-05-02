import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class NewCurrencyPurchaseScreen extends StatefulWidget {
  final Map<String, dynamic>? purchaseData;
  final bool isEditing;

  const NewCurrencyPurchaseScreen({
    super.key,
    this.purchaseData,
    this.isEditing = false,
  });

  @override
  State<NewCurrencyPurchaseScreen> createState() => _NewCurrencyPurchaseScreenState();
}

class _NewCurrencyPurchaseScreenState extends State<NewCurrencyPurchaseScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _totalBRLController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  String _selectedCurrency = 'Euro';
  final List<String> _currencies = ['Euro', 'Dólar', 'Libra'];
  
  String _selectedOrigin = 'Wise';
  final List<String> _origins = ['Wise', 'Revolut', 'Picnic', 'Papel', 'Novo'];
  
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_updateVET);
    _totalBRLController.addListener(_updateVET);

    if (widget.isEditing && widget.purchaseData != null) {
      _amountController.text = widget.purchaseData!['amount'] ?? '';
      _totalBRLController.text = widget.purchaseData!['totalBRL'] ?? '';
      _selectedCurrency = widget.purchaseData!['currency'] ?? 'Euro';
      
      if (widget.purchaseData!['origin'] != null) {
        String origin = widget.purchaseData!['origin'];
        if (!_origins.contains(origin)) {
          _origins.insert(_origins.length - 1, origin);
        }
        _selectedOrigin = origin;
      }
      
      _descriptionController.text = widget.purchaseData!['description'] ?? '';
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _totalBRLController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateVET() {
    setState(() {}); // Trigger rebuild to update the VET text
  }

  String get _calculatedVET {
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0;
    final totalBRL = double.tryParse(_totalBRLController.text.replaceAll(',', '.')) ?? 0;
    if (amount > 0 && totalBRL > 0) {
      return "VET: R\$ ${(totalBRL / amount).toStringAsFixed(2).replaceAll('.', ',')}";
    }
    return "VET: R\$ 0,00";
  }

  void _showNewOriginDialog() {
    final TextEditingController newOriginController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text("Nova Origem", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: newOriginController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Ex: Nomad",
            hintStyle: const TextStyle(color: Colors.white70),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.silverBorder)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.moneyGreen)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedOrigin = _origins.first;
              });
              Navigator.pop(ctx);
            },
            child: const Text("Cancelar", style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              if (newOriginController.text.trim().isNotEmpty) {
                setState(() {
                  _origins.insert(_origins.length - 1, newOriginController.text.trim());
                  _selectedOrigin = newOriginController.text.trim();
                });
              } else {
                setState(() {
                  _selectedOrigin = _origins.first;
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text("Adicionar", style: TextStyle(color: AppColors.moneyGreen, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String hint, 
    TextEditingController? controller, 
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      height: maxLines == 1 ? 45 : null,
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.silverBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w300),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: maxLines == 1 ? 12 : 16),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isEditing ? "editar saldo" : "adicionar saldo",
          style: const TextStyle(color: AppColors.offWhite, fontSize: 24, fontWeight: FontWeight.w500, fontFamily: 'Inter'),
        ),
        centerTitle: true,
        toolbarHeight: 80,
        actions: widget.isEditing ? [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: AppColors.cardBackground,
                  title: const Text("Excluir Saldo", style: TextStyle(color: Colors.white)),
                  content: const Text("Tem certeza que deseja excluir esta compra?", style: TextStyle(color: Colors.white70)),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar", style: TextStyle(color: Colors.white))),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                      },
                      child: const Text("Excluir", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            },
          ),
        ] : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            // Valor e Moeda
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildTextField(
                    hint: "Valor", 
                    controller: _amountController, 
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: AppColors.darkBackground,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: AppColors.silverBorder),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCurrency,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                        dropdownColor: AppColors.darkBackground,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300),
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          if (newValue != null) setState(() => _selectedCurrency = newValue);
                        },
                        items: _currencies.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(value: value, child: Text(value));
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Valor pago em reais
            _buildTextField(
              hint: "Valor pago em reais", 
              controller: _totalBRLController, 
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            
            // Texto do VET
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                _calculatedVET,
                style: const TextStyle(color: AppColors.moneyGreen, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),

            // Origem
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.darkBackground,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.silverBorder),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedOrigin,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  dropdownColor: AppColors.darkBackground,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300),
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    if (newValue == 'Novo') {
                      _showNewOriginDialog();
                    } else if (newValue != null) {
                      setState(() => _selectedOrigin = newValue);
                    }
                  },
                  items: _origins.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value));
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Data
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.darkBackground,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.silverBorder),
              ),
              child: TextButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: AppColors.moneyGreen,
                            surface: AppColors.darkBackground,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
                icon: const Icon(Icons.calendar_today, color: Colors.white70, size: 20),
                label: Text(
                  "${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}", 
                  style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 16, 
                    fontWeight: FontWeight.w300
                  )
                ),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Upload de foto (opcional)
            GestureDetector(
              onTap: () {
                // TODO: Implementar lógica de abrir galeria/câmera
              },
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B), // Cor ligeiramente mais clara que o fundo escuro
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.silverBorder, style: BorderStyle.solid),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate_outlined, color: Colors.white70, size: 32),
                    SizedBox(height: 8),
                    Text("Anexar comprovante (opcional)", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Descrição
            _buildTextField(
              hint: "Descrição (opcional)", 
              controller: _descriptionController,
              maxLines: 3,
            ),
            const SizedBox(height: 48),

            // Botão Salvar
            Center(
              child: SizedBox(
                width: 242,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.bottomGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Salvar", style: TextStyle(color: AppColors.offWhite, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
