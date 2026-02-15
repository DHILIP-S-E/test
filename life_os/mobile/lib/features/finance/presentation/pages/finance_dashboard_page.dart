import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/finance_provider.dart';

class FinanceDashboardPage extends ConsumerWidget {
  const FinanceDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionListProvider);

    return Scaffold(
      backgroundColor: AppColors.bgLightGray,
      appBar: AppBar(
        title: Text('Financial Dashboard', style: AppTheme.h2),
        backgroundColor: AppColors.bgWhite,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: AppColors.finance, size: 20),
                const SizedBox(width: 4),
                Text('4,250', style: AppTheme.body.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(transactionListProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Financial City Visualization Placeholder
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.financeLighter,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.financeLight.withOpacity(0.3)),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_city, size: 48, color: AppColors.finance),
                      const SizedBox(height: 8),
                      Text('Financial City Visualization', style: AppTheme.h3.copyWith(color: AppColors.financeDark)),
                      Text('Build your city by saving!', style: AppTheme.small),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Today's Summary
              Text("TODAY'S SUMMARY", style: AppTheme.caption),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      label: 'Spent',
                      value: '₹847',
                      icon: Icons.arrow_downward,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      label: 'Saved',
                      value: '₹200',
                      icon: Icons.savings,
                      color: AppColors.finance,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Quick Actions
              Text("QUICK ACTIONS", style: AppTheme.caption),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _QuickActionButton(
                    label: 'Add Expense',
                    icon: Icons.add,
                    color: AppColors.finance,
                    onTap: () => context.push('/finance/add'),
                  ),
                  _QuickActionButton(
                    label: 'View Goals',
                    icon: Icons.track_changes,
                    color: AppColors.finance,
                    onTap: () {},
                  ),
                  _QuickActionButton(
                    label: 'See Budget',
                    icon: Icons.pie_chart,
                    color: AppColors.finance,
                    onTap: () {},
                  ),
                  _QuickActionButton(
                    label: 'Learn',
                    icon: Icons.school,
                    color: AppColors.finance,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Daily Quest
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.financeLight.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.finance.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.emoji_events, color: AppColors.tasks, size: 20),
                        const SizedBox(width: 8),
                        Text('DAILY QUEST', style: AppTheme.caption.copyWith(color: AppColors.financeDark)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Stay under ₹500 today', style: AppTheme.bodyLarge),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: 0.69,
                      backgroundColor: AppColors.bgLightGray,
                      color: AppColors.finance,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Progress: ₹347 / ₹500', style: AppTheme.small),
                        Text('Reward: 100 coins', style: AppTheme.small.copyWith(fontWeight: FontWeight.bold, color: AppColors.tasks)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Text("RECENT TRANSACTIONS", style: AppTheme.caption),
              const SizedBox(height: 8),

              transactionsAsync.when(
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return const Center(child: Text('No transactions yet'));
                  }
                  return Column(
                    children: transactions.map((t) => Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.financeLighter,
                          child: Icon(Icons.fastfood, color: AppColors.financeDark), // Placeholder icon logic
                        ),
                        title: Text(t.category, style: AppTheme.bodyLarge),
                        subtitle: Text(t.date.toString().split(' ')[0], style: AppTheme.small),
                        trailing: Text(
                          '₹${t.amount}',
                          style: AppTheme.bodyLarge.copyWith(
                            color: t.type == 'expense' ? AppColors.error : AppColors.finance,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.bgOffWhite),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(label, style: AppTheme.small),
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: AppTheme.h2),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 8),
          Text(label, style: AppTheme.small.copyWith(fontSize: 10)),
        ],
      ),
    );
  }
}
