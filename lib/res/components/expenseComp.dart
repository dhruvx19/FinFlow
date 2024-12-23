import 'package:expense_tracker/utils/extension/extension.dart';
import 'package:flutter/material.dart';

class ExpenseComp extends StatelessWidget {
  final String value;
  const ExpenseComp({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: context.mw * 0.05),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: context.mw * 0.03),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: Colors.white60, borderRadius: BorderRadius.circular(20)),
            child: Icon(
              Icons.arrow_upward,
              size: 30,
              color: Colors.red[700],
            ),
          ),
          Column(
            children: [
              const Text(
                'Expense',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              Text(
                value,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.white70),
              )
            ],
          )
        ],
      ),
    );
  }
}
