
import 'package:flutter/material.dart';
import 'package:expense_tracker/utils/extension/extension.dart';
import 'package:expense_tracker/res/components/expenseComp.dart';
import 'package:expense_tracker/res/components/incomeComp.dart';
import 'package:google_fonts/google_fonts.dart';

class TotalBalanceComp extends StatelessWidget {
  final String value;
  final String Incnomevalue;
  final String Expensevalue;
  const TotalBalanceComp(
      {super.key,
      required this.value,
      required this.Incnomevalue,
      required this.Expensevalue});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: context.mw * 0.03, vertical: context.mh * 0.02),
        height: context.mh * 0.25,
        width: context.mw,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(colors: [
              Colors.black,
              Colors.blue
            ], begin: Alignment.center, end: Alignment.topLeft)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Total Balance',
                style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              0.02.ph(context),
              Text(
                '₹ ${value}',
                style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              0.03.ph(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IncomeComp(value: Incnomevalue),
                  ExpenseComp(value: Expensevalue)
                ],
              )
            ]));
  }
}
