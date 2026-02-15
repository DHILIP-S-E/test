import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/finance_repository.dart';
import '../../data/finance_repository_impl.dart';
import '../../domain/transaction.dart';

final financeRepositoryProvider = Provider<FinanceRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return FinanceRepositoryImpl(dio);
});

// AsyncNotifier for transactions list
class TransactionListController extends AsyncNotifier<List<Transaction>> {
  @override
  Future<List<Transaction>> build() async {
    final repository = ref.watch(financeRepositoryProvider);
    return repository.getTransactions();
  }

  Future<void> addTransaction({
    required int amount,
    required String category,
    required String type,
    required DateTime date,
    String? description,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(financeRepositoryProvider);
      await repository.addTransaction(amount, category, type, date,
          description: description);
      // Refresh the list
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final transactionListProvider =
    AsyncNotifierProvider<TransactionListController, List<Transaction>>(
  TransactionListController.new,
);
