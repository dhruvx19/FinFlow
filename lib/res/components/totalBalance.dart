import 'package:flutter/material.dart';
import 'package:expense_tracker/utils/extension/extension.dart';
import 'package:expense_tracker/res/components/expenseComp.dart';
import 'package:expense_tracker/res/components/incomeComp.dart';
import 'package:google_fonts/google_fonts.dart';

class TotalBalanceComp extends StatelessWidget {
  final String value;
  final String Incnomevalue;
  final String Expensevalue;
  
  const TotalBalanceComp({
    super.key,
    required this.value,
    required this.Incnomevalue,
    required this.Expensevalue
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).textScaler.scale(1.0);
    
    // Adjust container height based on screen size
    final containerHeight = size.height * 0.28; // Increased height slightly
    final titleFontSize = (size.width * 0.055).clamp(16.0, 22.0);
    final valueFontSize = (size.width * 0.045).clamp(14.0, 20.0);
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.03,
        vertical: size.height * 0.01, // Reduced vertical margin
      ),
      constraints: BoxConstraints(
        minHeight: containerHeight,
        maxHeight: containerHeight * 1.2,
      ),
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Colors.black, Colors.blue],
          begin: Alignment.center,
          end: Alignment.topLeft,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.height * 0.015,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min, // Changed to min
          children: [
            Text(
              'Total Balance',
              style: GoogleFonts.poppins(
                fontSize: titleFontSize / textScale,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              '₹ ${value}',
              style: GoogleFonts.poppins(
                fontSize: titleFontSize / textScale,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Flexible(
              fit: FlexFit.loose, // Changed to loose
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: size.width * 0.02),
                          padding: EdgeInsets.all(size.width * 0.02),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_downward,
                                    color: Colors.green,
                                    size: valueFontSize * 1.2,
                                  ),
                                  SizedBox(width: size.width * 0.01),
                                  Text(
                                    'Income',
                                    style: GoogleFonts.poppins(
                                      fontSize: valueFontSize / textScale,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height * 0.005),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '₹ $Incnomevalue',
                                  style: GoogleFonts.poppins(
                                    fontSize: valueFontSize / textScale,
                                    color: Colors.green[300],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: size.width * 0.02),
                          padding: EdgeInsets.all(size.width * 0.02),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_upward,
                                    color: Colors.red,
                                    size: valueFontSize * 1.2,
                                  ),
                                  SizedBox(width: size.width * 0.01),
                                  Text(
                                    'Expense',
                                    style: GoogleFonts.poppins(
                                      fontSize: valueFontSize / textScale,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height * 0.005),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '₹ $Expensevalue',
                                  style: GoogleFonts.poppins(
                                    fontSize: valueFontSize / textScale,
                                    color: Colors.red[300],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}