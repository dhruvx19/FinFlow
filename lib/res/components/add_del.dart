import 'package:FinFlow/models/expenseModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpenseActionDialog extends StatelessWidget {
  final ExpenseModel expense;
  final Function() onEdit;
  final Function() onDelete;

  const ExpenseActionDialog({
    Key? key,
    required this.expense,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Manage Expense',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Amount: ₹${expense.amount}',
              style: GoogleFonts.poppins()),
          Text('Description: ${expense.descrip}',
              style: GoogleFonts.poppins()),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onEdit();
          },
          child: Text('Edit', style: GoogleFonts.poppins()),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onDelete();
          },
          child: Text('Delete',
              style: GoogleFonts.poppins(color: Colors.red)),
        ),
      ],
    );
  }
}
