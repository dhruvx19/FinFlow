// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:FinFlow/utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ReuseableFeilds extends StatelessWidget {
  String hint, label;
  TextInputType type;
  TextEditingController controller;
  ReuseableFeilds(
      {super.key,
      required this.hint,
      required this.label,
      required this.type,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColor.blackColor,
              ),
              borderRadius: BorderRadius.circular(20)),
          hintText: hint,
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
    );
  }
}
