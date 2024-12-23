import 'package:equatable/equatable.dart';
import 'package:expense_tracker/Models/expenseModel.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoadingState extends HomeState {
  const HomeLoadingState();
}

class HomeErrorState extends HomeState {
  final String message;
  const HomeErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class HomeLoadedState extends HomeState {
  final List<ExpenseModel> expenseList;
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;

  const HomeLoadedState({
    required this.expenseList,
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
  });

  @override
  List<Object?> get props => [
        expenseList,
        totalBalance,
        totalIncome,
        totalExpense,
      ];

  // Add a copyWith method for easier state updates
  HomeLoadedState copyWith({
    List<ExpenseModel>? expenseList,
    double? totalBalance,
    double? totalIncome,
    double? totalExpense,
  }) {
    return HomeLoadedState(
      expenseList: expenseList ?? this.expenseList,
      totalBalance: totalBalance ?? this.totalBalance,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
    );
  }
}