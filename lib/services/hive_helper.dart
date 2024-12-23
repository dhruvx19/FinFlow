import 'package:flutter/foundation.dart';
import 'package:FinFlow/models/expenseModel.dart';
import 'package:FinFlow/services/boxes.dart';
import 'package:hive/hive.dart';

class HiveHelper {
  late Box<ExpenseModel> _expenseBox;
  bool _isInitialized = false;

  // Constructor to initialize the Hive box
  HiveHelper() {
    _initHive();
  }

  // Initialize the Hive box
  Future<void> _initHive() async {
    if (!_isInitialized) {
      _expenseBox = await Boxes.getData();
      _isInitialized = true;
    }
  }

  // Add amount with proper error handling and async handling
  Future<bool> addAmount(String amount, String amountType, String descrip, String date) async {
    try {
      await _initHive(); // Ensure box is initialized

      final data = ExpenseModel(
        amount: amount,
        amountType: amountType,
        descrip: descrip,
        date: date,
      );

      await _expenseBox.add(data);
      if (kDebugMode) {
        print('Added expense: ${data.amount}');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error adding expense: $e');
      }
      return false;
    }
  }

  // Delete expense with proper error handling
  Future<bool> deleteExpense(ExpenseModel expense) async {
    try {
      await _initHive(); // Ensure box is initialized
      
      // Find the expense in the box
      final index = _expenseBox.values.toList().indexOf(expense);
      if (index != -1) {
        await _expenseBox.deleteAt(index);
        if (kDebugMode) {
          print('Deleted expense at index: $index');
        }
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting expense: $e');
      }
      return false;
    }
  }

  // Update expense with proper error handling
  Future<bool> updateExpense(ExpenseModel oldExpense, ExpenseModel newExpense) async {
    try {
      await _initHive(); // Ensure box is initialized
      
      // Find the expense in the box
      final index = _expenseBox.values.toList().indexOf(oldExpense);
      if (index != -1) {
        await _expenseBox.putAt(index, newExpense);
        if (kDebugMode) {
          print('Updated expense at index: $index');
        }
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating expense: $e');
      }
      return false;
    }
  }

  // Get all expenses with proper error handling
  Future<List<ExpenseModel>> getAllExpenses() async {
    try {
      await _initHive(); // Ensure box is initialized
      return _expenseBox.values.toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting expenses: $e');
      }
      return [];
    }
  }

  // Close the box when done
  Future<void> closeBox() async {
    if (_isInitialized && _expenseBox.isOpen) {
      await _expenseBox.close();
      _isInitialized = false;
    }
  }
}