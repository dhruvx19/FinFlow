import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:FinFlow/bloc/home_bloc/home_event.dart';
import 'package:FinFlow/bloc/home_bloc/home_state.dart';
import 'package:FinFlow/services/hive_helper.dart';
import 'package:flutter/foundation.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HiveHelper helper;

  HomeBloc(this.helper) : super(const HomeInitial()) {
    on<HomeLoadedEvent>(_onHomeLoaded);
    on<RefreshHomeEvent>(_onHomeRefresh);
    on<DeleteExpenseEvent>(_onDeleteExpense);
    on<UpdateExpenseEvent>(_onUpdateExpense);
  }

  Future<void> _onHomeLoaded(HomeLoadedEvent event, Emitter<HomeState> emit) async {
    emit(const HomeLoadingState());
    await _loadAndEmitData(emit);
  }

  Future<void> _onHomeRefresh(RefreshHomeEvent event, Emitter<HomeState> emit) async {
    emit(const HomeLoadingState());
    await _loadAndEmitData(emit);
  }

  Future<void> _onDeleteExpense(DeleteExpenseEvent event, Emitter<HomeState> emit) async {
    try {
      emit(const HomeLoadingState());
      final success = await helper.deleteExpense(event.expense);
      
      if (success) {
        if (kDebugMode) {
          print('Expense deleted successfully');
        }
        await _loadAndEmitData(emit);
      } else {
        if (kDebugMode) {
          print('Failed to delete expense');
        }
        emit(const HomeErrorState('Failed to delete expense'));
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting expense: $e');
      }
      emit(HomeErrorState('Error deleting expense: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateExpense(UpdateExpenseEvent event, Emitter<HomeState> emit) async {
    try {
      emit(const HomeLoadingState());
      final success = await helper.updateExpense(event.oldExpense, event.newExpense);
      
      if (success) {
        if (kDebugMode) {
          print('Expense updated successfully');
        }
        await _loadAndEmitData(emit);
      } else {
        if (kDebugMode) {
          print('Failed to update expense');
        }
        emit(const HomeErrorState('Failed to update expense'));
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating expense: $e');
      }
      emit(HomeErrorState('Error updating expense: ${e.toString()}'));
    }
  }

  Future<void> _loadAndEmitData(Emitter<HomeState> emit) async {
    try {
      final expenses = await helper.getAllExpenses();
      
      double totalIncome = 0.0;
      double totalExpense = 0.0;
      
      // Calculate totals with improved error handling
      for (var expense in expenses) {
        double amount;
        try {
          // Handle various number formats and clean the input
          final cleanAmount = expense.amount.replaceAll(RegExp(r'[^0-9.]'), '');
          amount = double.parse(cleanAmount);
        } catch (e) {
          if (kDebugMode) {
            print('Error parsing amount "${expense.amount}": $e');
          }
          amount = 0.0;
        }
        
        // Check for exact string match to prevent type confusion
        if (expense.amountType == 'TransactionType.income') {
          totalIncome += amount;
        } else if (expense.amountType == 'TransactionType.expense') {
          totalExpense += amount;
        } else {
          if (kDebugMode) {
            print('Unknown transaction type: ${expense.amountType}');
          }
        }
      }

      // Calculate balance and round values
      final totalBalance = totalIncome - totalExpense;

      if (kDebugMode) {
        print('Total Income: $totalIncome');
        print('Total Expense: $totalExpense');
        print('Total Balance: $totalBalance');
      }

      emit(HomeLoadedState(
        expenseList: expenses.reversed.toList(),
        totalBalance: totalBalance.roundToDouble(),
        totalIncome: totalIncome.roundToDouble(),
        totalExpense: totalExpense.roundToDouble(),
      ));
    } catch (e) {
      if (kDebugMode) {
        print('Error loading data: $e');
      }
      emit(HomeErrorState('Failed to load expenses: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() async {
    // Clean up resources when the bloc is closed
    await helper.closeBox();
    return super.close();
  }
}