import 'package:equatable/equatable.dart';
import 'package:expense_tracker/Models/expenseModel.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeLoadedEvent extends HomeEvent {}

class RefreshHomeEvent extends HomeEvent {}

class DeleteExpenseEvent extends HomeEvent {
  final ExpenseModel expense;
  DeleteExpenseEvent(this.expense);

  @override
  List<Object?> get props => [expense];
}

class UpdateExpenseEvent extends HomeEvent {
  final ExpenseModel oldExpense;
  final ExpenseModel newExpense;
  UpdateExpenseEvent(this.oldExpense, this.newExpense);

  @override
  List<Object?> get props => [oldExpense, newExpense];
}
