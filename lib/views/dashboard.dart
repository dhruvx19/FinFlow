// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pie_chart/pie_chart.dart';

// class ExpenseIncomeChart extends StatelessWidget {
//   final double totalExpense;
//   final double totalIncome;

//   const ExpenseIncomeChart({
//     Key? key,
//     required this.totalExpense,
//     required this.totalIncome,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final totalAmount = totalExpense + totalIncome;

//     return Column(
//       children: [
//         Text(
//           'Expense vs Income',
//           style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 16),
//         AspectRatio(
//           aspectRatio: 1.3,
//           child: PieChart(
//             PieChartData(
//               sections: [
//                 PieChartSectionData(
//                   color: Colors.red,
//                   value: totalExpense,
//                   title: '${((totalExpense / totalAmount) * 100).toStringAsFixed(1)}%',
//                   titleStyle: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   radius: 60,
//                 ),
//                 PieChartSectionData(
//                   color: Colors.green,
//                   value: totalIncome,
//                   title: '${((totalIncome / totalAmount) * 100).toStringAsFixed(1)}%',
//                   titleStyle: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   radius: 60,
//                 ),
//               ],
//               sectionsSpace: 2,
//               centerSpaceRadius: 40,
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             LegendItem(color: Colors.red, text: "Expense"),
//             const SizedBox(width: 16),
//             LegendItem(color: Colors.green, text: "Income"),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class LegendItem extends StatelessWidget {
//   final Color color;
//   final String text;

//   const LegendItem({
//     Key? key,
//     required this.color,
//     required this.text,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 12,
//           height: 12,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: color,
//           ),
//         ),
//         const SizedBox(width: 4),
//         Text(
//           text,
//           style: GoogleFonts.poppins(fontSize: 14),
//         ),
//       ],
//     );
//   }
// }
