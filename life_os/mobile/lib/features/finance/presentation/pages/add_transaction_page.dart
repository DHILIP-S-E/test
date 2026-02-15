import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/finance_provider.dart';

class AddTransactionPage extends ConsumerStatefulWidget {
  const AddTransactionPage({super.key});

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _type = 'expense';
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final amount = int.tryParse(_amountController.text) ?? 0;
      final category = _categoryController.text;
      final description = _descriptionController.text;

      ref.read(transactionListProvider.notifier).addTransaction(
            amount: amount,
            category: category,
            type: _type,
            date: _date,
            description: description,
          );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      appBar: AppBar(
        title: Text('Add Transaction', style: AppTheme.h2),
        backgroundColor: AppColors.financeLighter,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Input Method Tabs
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: AppColors.financeLighter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _InputMethodTab(icon: Icons.mic, label: 'Voice', isActive: false),
                  _InputMethodTab(icon: Icons.camera_alt, label: 'Photo', isActive: false),
                  _InputMethodTab(icon: Icons.chat, label: 'Chat', isActive: false),
                  _InputMethodTab(icon: Icons.edit, label: 'Manual', isActive: true),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _amountController,
                      style: AppTheme.display.copyWith(color: AppColors.financeDark),
                      decoration: InputDecoration(
                        labelText: 'Amount (in paise)',
                        prefixIcon: const Icon(Icons.currency_rupee, color: AppColors.finance),
                        border: InputBorder.none,
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.finance, width: 2)),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter amount';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    Text('DETAILS', style: AppTheme.caption),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        prefixIcon: Icon(Icons.category),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter category';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: _type,
                      items: const [
                        DropdownMenuItem(value: 'expense', child: Text('Expense')),
                        DropdownMenuItem(value: 'income', child: Text('Income')),
                      ],
                      onChanged: (val) => setState(() => _type = val!),
                      decoration: const InputDecoration(
                        labelText: 'Type',
                        prefixIcon: Icon(Icons.swap_horiz),
                      ),
                    ),
                    const SizedBox(height: 16),

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Date: ${_date.toLocal().toString().split(' ')[0]}', style: AppTheme.bodyLarge),
                      trailing: const Icon(Icons.calendar_today, color: AppColors.finance),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _date,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null) {
                          setState(() => _date = picked);
                        }
                      },
                    ),
                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.finance,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Save Transaction', style: AppTheme.h3.copyWith(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputMethodTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _InputMethodTab({required this.icon, required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.finance : AppColors.bgWhite,
            shape: BoxShape.circle,
            border: Border.all(color: isActive ? AppColors.finance : AppColors.financeLight),
          ),
          child: Icon(icon, color: isActive ? Colors.white : AppColors.finance),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTheme.small.copyWith(fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}
