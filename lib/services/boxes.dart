import 'package:hive/hive.dart';
import 'package:FinFlow/models/expenseModel.dart';

class Boxes {
  static Future<Box<ExpenseModel>> getData() async {
    return await Hive.openBox<ExpenseModel>('expenses');
  }
}