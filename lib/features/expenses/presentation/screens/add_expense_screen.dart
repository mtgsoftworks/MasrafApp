import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:masraf_app/auth/providers/auth_provider.dart';
import 'package:masraf_app/features/expenses/models/expense.dart';
import 'package:masraf_app/features/expenses/providers/expense_provider.dart';
import 'package:masraf_app/shared/constants/app_theme.dart';
import 'package:masraf_app/shared/widgets/custom_button.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  final String? expenseId;

  const AddExpenseScreen({super.key, this.expenseId});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = ExpenseCategories.values.first;
  bool _isRecurring = false;
  List<String> _selectedTags = [];

  bool _isEdit = false;
  late Expense? _existingExpense;

  XFile? _receipt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExpenseIfEditing();
    });
  }

  Future<void> _loadExpenseIfEditing() async {
    if (widget.expenseId != null) {
      final expenses = ref.read(expenseProvider).expenses;
      _existingExpense = expenses.firstWhere(
        (e) => e.id == widget.expenseId,
        orElse: () => Expense(
          userId: '',
          amount: 0,
          description: '',
          date: DateTime.now(),
          category: ExpenseCategories.values.first,
        ),
      );

      if (_existingExpense != null) {
        setState(() {
          _isEdit = true;
          _amountController.text = _existingExpense!.amount.toString();
          _descriptionController.text = _existingExpense!.description;
          _notesController.text = _existingExpense!.notes ?? '';
          _selectedDate = _existingExpense!.date;
          _selectedCategory = _existingExpense!.category;
          _isRecurring = _existingExpense!.isRecurring;
          _selectedTags = List.from(_existingExpense!.tags);
        });
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    _receipt = null;
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty && !_selectedTags.contains(tag)) {
      setState(() {
        _selectedTags.add(tag);
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _selectedTags.remove(tag);
    });
  }

  Future<void> _pickReceipt() async {
    final file = await ImagePicker().pickImage(source: ImageSource.camera);
    if (file != null) setState(() => _receipt = file);
  }

  Widget _buildReceiptPreview() {
    return Image.file(File(_receipt!.path), width: 100, height: 100, fit: BoxFit.cover);
  }

  Future<void> _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      final authState = ref.read(authProvider);

      if (!authState.isAuthenticated || authState.user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('You must be logged in to add expenses')),
        );
        return;
      }

      final amount = double.parse(_amountController.text);
      final description = _descriptionController.text.trim();
      final notes = _notesController.text.trim();

      final expense = Expense(
        id: _isEdit ? _existingExpense!.id : null,
        userId: authState.user!.id,
        amount: amount,
        description: description,
        date: _selectedDate,
        category: _selectedCategory,
        notes: notes.isNotEmpty ? notes : null,
        isRecurring: _isRecurring,
        tags: _selectedTags,
      );

      String? receiptUrl;
      if (_receipt != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final receiptsDir = Directory('${appDir.path}/receipts');
        if (!await receiptsDir.exists()) {
          await receiptsDir.create(recursive: true);
        }
        final fileName = _receipt!.name;
        final newPath = '${receiptsDir.path}/$fileName';
        await File(_receipt!.path).copy(newPath);
        receiptUrl = newPath;
      }
      final toSave = receiptUrl != null ? expense.copyWith(receiptUrl: receiptUrl) : expense;

      if (_isEdit) {
        await ref.read(expenseProvider.notifier).updateExpense(toSave);
      } else {
        await ref.read(expenseProvider.notifier).addExpense(toSave);
      }

      if (mounted) {
        GoRouter.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Expense' : 'Add Expense'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Amount
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    hintText: 'Enter amount',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter a description',
                    prefixIcon: Icon(Icons.description),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Date
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      DateFormat('MMMM dd, yyyy').format(_selectedDate),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Category
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: ExpenseCategories.values
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Row(
                              children: [
                                Icon(ExpenseCategories.icons[category]),
                                const SizedBox(width: 8),
                                Text(category),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Recurring
                SwitchListTile(
                  title: const Text('Recurring Expense'),
                  subtitle: const Text('This expense repeats regularly'),
                  value: _isRecurring,
                  onChanged: (value) {
                    setState(() {
                      _isRecurring = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Notes
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Notes (Optional)',
                    hintText: 'Add any additional notes',
                    prefixIcon: Icon(Icons.note),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 24),

                // Tags
                Text(
                  'Tags',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._selectedTags.map((tag) => Chip(
                          label: Text(tag),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () => _removeTag(tag),
                        )),
                    ActionChip(
                      avatar: const Icon(Icons.add, size: 18),
                      label: const Text('Add Tag'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            String newTag = '';
                            return AlertDialog(
                              title: const Text('Add Tag'),
                              content: TextField(
                                onChanged: (value) => newTag = value,
                                decoration: const InputDecoration(
                                  hintText: 'Enter tag name',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _addTag(newTag);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Add'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Text(
                  'Receipt (Optional)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickReceipt,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Add Receipt'),
                    ),
                    const SizedBox(width: 16),
                    if (_receipt != null)
                      _buildReceiptPreview(),
                  ],
                ),

                const SizedBox(height: 32),

                // Save Button
                CustomButton(
                  onPressed: _saveExpense,
                  text: _isEdit ? 'Update Expense' : 'Save Expense',
                  icon: Icons.save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
