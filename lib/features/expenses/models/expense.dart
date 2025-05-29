import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Expense {
  final String id;
  final String userId;
  final double amount;
  final String description;
  final DateTime date;
  final String category;
  final String? notes;
  final bool isRecurring;
  final String? receiptUrl;
  final List<String> tags;

  Expense({
    String? id,
    required this.userId,
    required this.amount,
    required this.description,
    required this.date,
    required this.category,
    this.notes,
    this.isRecurring = false,
    this.receiptUrl,
    this.tags = const [],
  }) : id = id ?? const Uuid().v4();

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      category: json['category'] as String,
      notes: json['notes'] as String?,
      isRecurring: json['isRecurring'] as bool? ?? false,
      receiptUrl: json['receiptUrl'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
      'category': category,
      'notes': notes,
      'isRecurring': isRecurring,
      'receiptUrl': receiptUrl,
      'tags': tags,
    };
  }

  Expense copyWith({
    String? id,
    String? userId,
    double? amount,
    String? description,
    DateTime? date,
    String? category,
    String? notes,
    bool? isRecurring,
    String? receiptUrl,
    List<String>? tags,
  }) {
    return Expense(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      date: date ?? this.date,
      category: category ?? this.category,
      notes: notes ?? this.notes,
      isRecurring: isRecurring ?? this.isRecurring,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      tags: tags ?? this.tags,
    );
  }
}

// Common expense categories
class ExpenseCategories {
  static const String food = 'Food';
  static const String groceries = 'Groceries';
  static const String transportation = 'Transportation';
  static const String housing = 'Housing';
  static const String utilities = 'Utilities';
  static const String healthcare = 'Healthcare';
  static const String entertainment = 'Entertainment';
  static const String shopping = 'Shopping';
  static const String education = 'Education';
  static const String travel = 'Travel';
  static const String personal = 'Personal';
  static const String other = 'Other';

  static List<String> values = [
    food,
    groceries,
    transportation,
    housing,
    utilities,
    healthcare,
    entertainment,
    shopping,
    education,
    travel,
    personal,
    other,
  ];

  static Map<String, IconData> icons = {
    food: Icons.restaurant,
    groceries: Icons.shopping_basket,
    transportation: Icons.directions_car,
    housing: Icons.home,
    utilities: Icons.electrical_services,
    healthcare: Icons.medical_services,
    entertainment: Icons.movie,
    shopping: Icons.shopping_bag,
    education: Icons.school,
    travel: Icons.flight,
    personal: Icons.person,
    other: Icons.category,
  };
}
