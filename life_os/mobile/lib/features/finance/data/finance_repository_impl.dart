import 'package:dio/dio.dart';
import '../domain/finance_repository.dart';
import '../domain/transaction.dart';

class FinanceRepositoryImpl implements FinanceRepository {
  final Dio _dio;

  FinanceRepositoryImpl(this._dio);

  @override
  Future<List<Transaction>> getTransactions() async {
    try {
      final response = await _dio.get('/finance/transactions');
      final List<dynamic> data = response.data;
      return data.map((json) => Transaction.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load transactions: $e');
    }
  }

  @override
  Future<Transaction> addTransaction(
      int amount, String category, String type, DateTime date,
      {String? description}) async {
    try {
      final response = await _dio.post('/finance/transactions', data: {
        'amount': amount,
        'category': category,
        'type': type,
        'transaction_date': date.toIso8601String().split('T')[0], // YYYY-MM-DD
        'description': description,
      });
      return Transaction.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }
}
