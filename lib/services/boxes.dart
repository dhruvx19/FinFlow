import 'package:hive/hive.dart';
import 'package:expense_tracker/Models/expenseModel.dart';

class Boxes {
  static Future<Box<ExpenseModel>> getData() async {
    return await Hive.openBox<ExpenseModel>('expenses');
  }
}