// ignore_for_file: must_be_immutable

import 'package:FinFlow/utils/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:FinFlow/utils/colors.dart';

class ReuseAbleContainer extends StatelessWidget {
  IconData icon;
  ReuseAbleContainer({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.mh * 0.06,
      width: context.mw * 0.12,
      decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            AppColor.blackColor,
            AppColor.blueColor,
          ], begin: Alignment.center, end: Alignment.topLeft),
          borderRadius: BorderRadius.circular(16.0)),
      child: Icon(
        icon,
        color: AppColor.whiteColor,
      ),
    );
  }
}
