import 'package:hive/hive.dart';
part 'expenseModel.g.dart';

@HiveType(typeId: 0)
class ExpenseModel extends HiveObject {
  @HiveField(0)
  String amount;

  @HiveField(1)
  String amountType;

  @HiveField(2)
  String descrip;

  @HiveField(3)    
  String date;

  ExpenseModel(
      {required this.amount,
      required this.amountType,
      required this.descrip,
      required this.date});
}
