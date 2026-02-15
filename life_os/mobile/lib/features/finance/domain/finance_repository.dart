import 'transaction.dart';

abstract class FinanceRepository {
  Future<List<Transaction>> getTransactions();
  Future<Transaction> addTransaction(int amount, String category, String type, DateTime date, {String? description});
}
