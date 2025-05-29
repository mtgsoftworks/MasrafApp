import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:masraf_app/auth/providers/auth_provider.dart';
import 'package:masraf_app/features/expenses/models/expense.dart';
import 'package:masraf_app/features/expenses/providers/expense_provider.dart';
import 'package:masraf_app/home/presentation/widgets/expense_list_item.dart';
import 'package:masraf_app/shared/constants/app_theme.dart';

// Tarih aralığı türleri için enum
enum DateRangeType { currentMonth, previousMonth, lastWeek, last30Days }

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Seçili tarih aralığı türü
  DateRangeType _selectedDateRangeType = DateRangeType.currentMonth;

  // Tarih aralığı verisi
  late DateRange _dateRange;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Başlangıçta tarih aralığını ayarla
    _updateDateRange(_selectedDateRangeType);
  }

  // Tarih aralığını güncelle
  void _updateDateRange(DateRangeType type) {
    setState(() {
      _selectedDateRangeType = type;
      switch (type) {
        case DateRangeType.currentMonth:
          _dateRange = DateRange.currentMonth();
          break;
        case DateRangeType.previousMonth:
          _dateRange = DateRange.previousMonth();
          break;
        case DateRangeType.lastWeek:
          _dateRange = DateRange.lastWeek();
          break;
        case DateRangeType.last30Days:
          _dateRange = DateRange.last30Days();
          break;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final filteredExpenses = ref.watch(filteredExpensesProvider(_dateRange));
    final expensesByCategory = ref.watch(expensesByCategoryProvider);
    final totalExpenses = ref.watch(totalExpensesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MasrafApp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                ),
                Text(
                  user?.name ?? 'User',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),

                // Total Spending Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Spending',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          _buildDateRangeDropdown(),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '₺${totalExpenses.toStringAsFixed(2)}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getDateRangeText(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tab Bar
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Expenses'),
              Tab(text: 'Categories'),
              Tab(text: 'Reports'),
            ],
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Overview Tab
                _buildOverviewTab(filteredExpenses, expensesByCategory),

                // Expenses Tab
                _buildExpensesTab(filteredExpenses),

                // Categories Tab
                _buildCategoriesTab(expensesByCategory),

                // Reports Tab
                _buildReportsTab(filteredExpenses),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/add-expense');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDateRangeDropdown() {
    return DropdownButton<DateRangeType>(
      value: _selectedDateRangeType,
      underline: const SizedBox(),
      icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
      onChanged: (DateRangeType? newValue) {
        if (newValue != null) {
          _updateDateRange(newValue);
        }
      },
      items: [
        DropdownMenuItem(
          value: DateRangeType.currentMonth,
          child: const Text('This Month'),
        ),
        DropdownMenuItem(
          value: DateRangeType.previousMonth,
          child: const Text('Last Month'),
        ),
        DropdownMenuItem(
          value: DateRangeType.lastWeek,
          child: const Text('Last 7 Days'),
        ),
        DropdownMenuItem(
          value: DateRangeType.last30Days,
          child: const Text('Last 30 Days'),
        ),
      ],
    );
  }

  String _getDateRangeText() {
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    return '${formatter.format(_dateRange.start)} - ${formatter.format(_dateRange.end)}';
  }

  Widget _buildOverviewTab(
      List<Expense> expenses, Map<String, double> expensesByCategory) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Spending Chart
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Spending by Category',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: expensesByCategory.isEmpty
                        ? const Center(child: Text('No expenses yet'))
                        : PieChart(
                            PieChartData(
                              sections:
                                  _getPieChartSections(expensesByCategory),
                              centerSpaceRadius: 40,
                              sectionsSpace: 2,
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: expensesByCategory.entries
                        .map((entry) => _buildLegendItem(
                              entry.key,
                              entry.value,
                              _getCategoryColor(entry.key),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Recent Expenses
          Text(
            'Recent Expenses',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          expenses.isEmpty
              ? Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.receipt_long,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No expenses found',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add your first expense by tapping the + button',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Column(
                  children: expenses
                      .take(5)
                      .map((expense) => ExpenseListItem(expense: expense))
                      .toList(),
                ),
          if (expenses.length > 5) ...[
            const SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  _tabController.animateTo(1); // Navigate to Expenses tab
                },
                icon: const Icon(Icons.list),
                label: const Text('View All Expenses'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExpensesTab(List<Expense> expenses) {
    return expenses.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No expenses found',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Add your first expense by tapping the + button',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              return ExpenseListItem(expense: expenses[index]);
            },
          );
  }

  Widget _buildCategoriesTab(Map<String, double> expensesByCategory) {
    final sortedCategories = expensesByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Spending by Category',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          expensesByCategory.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.category,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No expenses found',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                )
              : Column(
                  children: sortedCategories
                      .map((entry) => _buildCategoryItem(
                            entry.key,
                            entry.value,
                            _getCategoryColor(entry.key),
                            expensesByCategory.values.reduce((a, b) => a + b),
                          ))
                      .toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildReportsTab(List<Expense> expenses) {
    // Group expenses by day
    final Map<String, double> dailyExpenses = {};

    for (final expense in expenses) {
      final date = DateFormat('yyyy-MM-dd').format(expense.date);
      dailyExpenses[date] = (dailyExpenses[date] ?? 0) + expense.amount;
    }

    // Sort by date
    final sortedDates = dailyExpenses.keys.toList()..sort();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Spending Over Time',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // Line Chart
          SizedBox(
            height: 200,
            child: dailyExpenses.isEmpty
                ? Center(child: Text('No expense data available'))
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= 0 &&
                                  value.toInt() < sortedDates.length) {
                                final date =
                                    DateTime.parse(sortedDates[value.toInt()]);
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    DateFormat('dd/MM').format(date),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(sortedDates.length, (index) {
                            return FlSpot(
                              index.toDouble(),
                              dailyExpenses[sortedDates[index]]!,
                            );
                          }),
                          isCurved: true,
                          color: AppColors.primary,
                          barWidth: 3,
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.primary.withOpacity(0.2),
                          ),
                          dotData: FlDotData(show: false),
                        ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 32),

          // Monthly Summary
          const Text(
            'Monthly Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSummaryItem(
                    'Total Expenses',
                    expenses.fold(0.0, (sum, expense) => sum + expense.amount),
                    Icons.account_balance_wallet,
                  ),
                  const Divider(),
                  _buildSummaryItem(
                    'Average per Day',
                    dailyExpenses.isEmpty
                        ? 0.0
                        : expenses.fold(
                                0.0, (sum, expense) => sum + expense.amount) /
                            dailyExpenses.length,
                    Icons.date_range,
                  ),
                  const Divider(),
                  _buildSummaryItem(
                    'Highest Spending Day',
                    dailyExpenses.isEmpty
                        ? 0.0
                        : dailyExpenses.values.reduce((a, b) => a > b ? a : b),
                    Icons.arrow_upward,
                  ),
                  const Divider(),
                  _buildSummaryItem(
                    'Number of Transactions',
                    expenses.length.toDouble(),
                    Icons.receipt_long,
                    isCount: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String category, double amount, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          category,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(
    String category,
    double amount,
    Color color,
    double total,
  ) {
    final percentage = (amount / total) * 100;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  ExpenseCategories.icons[category] ?? Icons.category,
                  color: color,
                ),
                const SizedBox(width: 8),
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  '₺${amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.grey[200],
                    color: color,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, double value, IconData icon,
      {bool isCount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              Text(
                isCount
                    ? value.toInt().toString()
                    : '₺${value.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getPieChartSections(
      Map<String, double> expensesByCategory) {
    final sections = <PieChartSectionData>[];

    for (final entry in expensesByCategory.entries) {
      final color = _getCategoryColor(entry.key);
      sections.add(
        PieChartSectionData(
          value: entry.value,
          title:
              '${(entry.value / expensesByCategory.values.reduce((a, b) => a + b) * 100).toStringAsFixed(0)}%',
          color: color,
          radius: 50,
          titleStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      );
    }

    return sections;
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

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to profile screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                context.go('/settings');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: AppColors.error),
              title: Text('Logout', style: TextStyle(color: AppColors.error)),
              onTap: () {
                Navigator.pop(context);
                _showLogoutConfirmation(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).logout();
            },
            child: Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
