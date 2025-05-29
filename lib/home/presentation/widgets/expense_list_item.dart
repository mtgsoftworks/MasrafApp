import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:masraf_app/features/expenses/models/expense.dart';
import 'package:masraf_app/shared/constants/app_theme.dart';

class ExpenseListItem extends StatelessWidget {
  final Expense expense;
  
  const ExpenseListItem({
    super.key,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          context.push('/expense/${expense.id}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Category Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getCategoryColor(expense.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  ExpenseCategories.icons[expense.category] ?? Icons.category,
                  color: _getCategoryColor(expense.category),
                ),
              ),
              const SizedBox(width: 16),
              
              // Expense Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.description,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          expense.category,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.circle,
                          size: 4,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('MMM dd, yyyy').format(expense.date),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₺${expense.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  if (expense.isRecurring)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Recurring',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.warning,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    final Map<String, Color> categoryColors = {
      ExpenseCategories.food: Colors.red[400]!,
      ExpenseCategories.groceries: Colors.green[400]!,
      ExpenseCategories.transportation: Colors.blue[400]!,
      ExpenseCategories.housing: Colors.purple[400]!,
      ExpenseCategories.utilities: Colors.orange[400]!,
      ExpenseCategories.healthcare: Colors.pink[400]!,
      ExpenseCategories.entertainment: Colors.teal[400]!,
      ExpenseCategories.shopping: Colors.amber[400]!,
      ExpenseCategories.education: Colors.indigo[400]!,
      ExpenseCategories.travel: Colors.cyan[400]!,
      ExpenseCategories.personal: Colors.deepOrange[400]!,
      ExpenseCategories.other: Colors.grey[400]!,
    };
    
    return categoryColors[category] ?? Colors.grey;
  }
}