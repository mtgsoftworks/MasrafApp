import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:masraf_app/features/expenses/models/expense.dart';
import 'package:masraf_app/features/expenses/providers/expense_provider.dart';
import 'package:masraf_app/shared/constants/app_theme.dart';
import 'package:masraf_app/shared/widgets/custom_button.dart';
import 'package:masraf_app/shared/widgets/error_screen.dart';

class ExpenseDetailsScreen extends ConsumerWidget {
  final String expenseId;

  const ExpenseDetailsScreen({
    super.key,
    required this.expenseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseState = ref.watch(expenseProvider);

    if (expenseState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (expenseState.error != null) {
      return ErrorScreen(error: Exception(expenseState.error));
    }

    final expense = expenseState.expenses.firstWhere(
      (e) => e.id == expenseId,
      orElse: () => Expense(
        userId: '',
        amount: 0,
        description: '',
        date: DateTime.now(),
        category: ExpenseCategories.values.first,
      ),
    );

    if (expense.userId.isEmpty) {
      return ErrorScreen(error: Exception('Expense not found'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit expense screen
              context.push('/edit-expense/$expenseId');
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmation(context, ref, expense);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.attach_money,
                        color: AppColors.primary,
                        size: 48,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Amount',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '₺${expense.amount.toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Description and Category
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            ExpenseCategories.icons[expense.category] ??
                                Icons.category,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            expense.category,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      Text(
                        expense.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Date and Recurring info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: AppColors.info,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Date',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat('EEEE, MMMM dd, yyyy').format(expense.date),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      if (expense.isRecurring) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.repeat,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Recurring Expense',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Notes
              if (expense.notes != null && expense.notes!.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.note,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Notes',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          expense.notes!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Tags
              if (expense.tags.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.label,
                              color: AppColors.info,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Tags',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: expense.tags
                              .map((tag) => Chip(
                                    label: Text(tag),
                                    backgroundColor:
                                        AppColors.primary.withOpacity(0.1),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onPressed: () {
                        // Duplicate expense
                        final newExpense = expense.copyWith(
                          id: null,
                          date: DateTime.now(),
                        );
                        ref
                            .read(expenseProvider.notifier)
                            .addExpense(newExpense);
                        GoRouter.of(context).pop();
                      },
                      text: 'Duplicate',
                      icon: Icons.copy,
                      isOutlined: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      onPressed: () {
                        // Share expense
                        // TODO: Implement sharing functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sharing coming soon')),
                        );
                      },
                      text: 'Share',
                      icon: Icons.share,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, WidgetRef ref, Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content:
            Text('Are you sure you want to delete "${expense.description}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(expenseProvider.notifier).deleteExpense(expense.id);
              Navigator.pop(context); // Close dialog
              GoRouter.of(context).pop(); // Go back to previous screen
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
