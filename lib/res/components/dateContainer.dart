// ignore_for_file: must_be_immutable


import 'package:expense_tracker/utils/extension/extension.dart';
import 'package:expense_tracker/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class DateContainer extends StatelessWidget {
  String date;
  DateContainer({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.mh * 0.07,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColor.blackColor)),
      child: Center(
        child: Text(Utils.dateFormated(date),
            style:
                GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
