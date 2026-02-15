import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String id;
  final int amount;
  final String type;
  final String category;
  final String? description;
  final DateTime date;

  const Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.category,
    this.description,
    required this.date,
  });

  @override
  List<Object?> get props => [id, amount, type, category, description, date];

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      amount: json['amount'] as int,
      type: json['type'] as String,
      category: json['category'] as String,
      description: json['description'] as String?,
      date: DateTime.parse(json['transaction_date'] as String),
    );
  }
}
