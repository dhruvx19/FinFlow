import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:FinFlow/models/expenseModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:FinFlow/bloc/home_bloc/home_bloc.dart';
import 'package:FinFlow/bloc/home_bloc/home_state.dart';
import 'package:intl/intl.dart';

class ExpenseSummaryScreen extends StatefulWidget {
  const ExpenseSummaryScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseSummaryScreen> createState() => _ExpenseSummaryScreenState();
}

class _ExpenseSummaryScreenState extends State<ExpenseSummaryScreen> {
  bool isMonthlyView = true; // Toggle between weekly and monthly view

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expense Summary',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () {
              setState(() {
                isMonthlyView = !isMonthlyView;
              });
            },
            icon: Icon(isMonthlyView ? Icons.calendar_month : Icons.calendar_view_week),
            label: Text(isMonthlyView ? 'Monthly' : 'Weekly'),
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is HomeLoadedState) {
            return _buildSummaryContent(state.expenseList);
          }
          
          return const Center(child: Text('Failed to load summary'));
        },
      ),
    );
  }

  Widget _buildSummaryContent(List<ExpenseModel> expenses) {
    // Group expenses by period (week or month)
    final groupedExpenses = _groupExpenses(expenses);
    
    return ListView.builder(
      itemCount: groupedExpenses.length,
      itemBuilder: (context, index) {
        final period = groupedExpenses.keys.elementAt(index);
        final periodExpenses = groupedExpenses[period]!;
        
        // Calculate totals for this period
        final totals = _calculatePeriodTotals(periodExpenses);
        
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ExpansionTile(
            title: Text(
              period,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Income: ₹${totals['income']?.toStringAsFixed(2)} | '
              'Expense: ₹${totals['expense']?.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(),
            ),
            children: [
              _buildPeriodSummary(periodExpenses),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPeriodSummary(List<ExpenseModel> expenses) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // List of expenses for this period
          ...expenses.map((expense) => ListTile(
            leading: Icon(
              expense.amountType == 'TransactionType.income'
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              color: expense.amountType == 'TransactionType.income'
                  ? Colors.green
                  : Colors.red,
            ),
            title: Text(expense.descrip, style: GoogleFonts.poppins()),
            trailing: Text(
              '₹${expense.amount}',
              style: GoogleFonts.poppins(
                color: expense.amountType == 'TransactionType.income'
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          )),
        ],
      ),
    );
  }

  Map<String, List<ExpenseModel>> _groupExpenses(List<ExpenseModel> expenses) {
    final groupedExpenses = <String, List<ExpenseModel>>{};
    
    for (var expense in expenses) {
      final date = DateTime.parse(expense.date);
      final period = isMonthlyView
          ? DateFormat('MMMM yyyy').format(date)
          : 'Week ${_getWeekNumber(date)} - ${DateFormat('yyyy').format(date)}';
      
      groupedExpenses.putIfAbsent(period, () => []).add(expense);
    }
    
    return Map.fromEntries(
      groupedExpenses.entries.toList()
        ..sort((a, b) => b.key.compareTo(a.key))
    );
  }

  Map<String, double> _calculatePeriodTotals(List<ExpenseModel> expenses) {
    double income = 0.0;
    double expense = 0.0;
    
    for (var item in expenses) {
      final amount = double.tryParse(item.amount.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
      if (item.amountType == 'TransactionType.income') {
        income += amount;
      } else {
        expense += amount;
      }
    }
    
    return {
      'income': income,
      'expense': expense,
    };
  }

  int _getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysOffset = firstDayOfYear.weekday - 1;
    final firstWeekday = firstDayOfYear.subtract(Duration(days: daysOffset));
    final weeksBetween = date.difference(firstWeekday).inDays ~/ 7;
    return weeksBetween + 1;
  }
}