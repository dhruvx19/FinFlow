// ignore_for_file: use_build_context_synchronously

import 'package:expense_tracker/Models/expenseModel.dart';
import 'package:expense_tracker/bloc/amount_bloc/amount_bloc.dart';
import 'package:expense_tracker/bloc/cubit/setDateCubit.dart';
import 'package:expense_tracker/bloc/cubit/transactionCubit.dart';
import 'package:expense_tracker/bloc/home_bloc/home_bloc.dart';
import 'package:expense_tracker/bloc/home_bloc/home_event.dart';
import 'package:expense_tracker/notification/notification.dart';
import 'package:expense_tracker/res/components/TextFromFeilds.dart';
import 'package:expense_tracker/res/components/dateContainer.dart';
import 'package:expense_tracker/res/components/resuableContainer.dart';
import 'package:expense_tracker/res/components/reuseableBtn.dart';
import 'package:expense_tracker/utils/colors.dart';
import 'package:expense_tracker/utils/extension/extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class AddAmount extends StatefulWidget {
  final bool isEditing;
  final ExpenseModel? expenseToEdit;
  const AddAmount({
    super.key,
    this.isEditing = false,
    this.expenseToEdit,
  });

  @override
  State<AddAmount> createState() => _AddAmountState();
}

class _AddAmountState extends State<AddAmount> {
  TextEditingController amountController = TextEditingController();
  TextEditingController dscripController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.expenseToEdit != null) {
      amountController.text = widget.expenseToEdit!.amount;
      dscripController.text = widget.expenseToEdit!.descrip;
      context.read<TransactionCubit>().setType(
            widget.expenseToEdit!.amountType == 'TransactionType.income'
                ? TransactionType.income
                : TransactionType.expense,
          );
      context
          .read<DateCubit>()
          .setDate(DateTime.parse(widget.expenseToEdit!.date));
    }
  }

  void dispose() {
    //implement dispose
    super.dispose();
    amountController.dispose();
    dscripController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('Print');
    }
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
          title: Text(
            'Add Amount',
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              0.05.ph(context),
              BlocBuilder<TransactionCubit, TransactionType>(
                builder: (context, type) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: context.mw * 0.04),
                    child: Column(
                      children: [
                        BlocBuilder<AmountBloc, AmountState>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    ReuseAbleContainer(
                                        icon: FontAwesomeIcons.indianRupeeSign),
                                    0.04.pw(context),
                                    Expanded(
                                        child: ReuseableFeilds(
                                      hint: '0',
                                      label: 'Amount',
                                      type: TextInputType.number,
                                      controller: amountController,
                                    ))
                                  ],
                                ),
                                state is AmountAddedErrorState &&
                                        state.errormsg ==
                                            "Please Enter the amount"
                                    ? Text(
                                        state.errormsg,
                                        style: GoogleFonts.poppins(
                                            color: Colors.red),
                                      )
                                    : Container(),
                                0.03.ph(context),
                                Row(
                                  children: [
                                    ReuseAbleContainer(
                                        icon: Icons.details_outlined),
                                    0.04.pw(context),
                                    Expanded(
                                        child: ReuseableFeilds(
                                      hint: '',
                                      label: 'Description',
                                      type: TextInputType.text,
                                      controller: dscripController,
                                    ))
                                  ],
                                ),
                                state is AmountAddedErrorState &&
                                        state.errormsg ==
                                            "Please Enter the Description"
                                    ? Text(
                                        state.errormsg,
                                        style: GoogleFonts.poppins(
                                            color: Colors.red),
                                      )
                                    : Container(),
                              ],
                            );
                          },
                        ),
                        0.03.ph(context),
                        Row(
                          children: [
                            ReuseAbleContainer(icon: Icons.moving_sharp),
                            0.04.pw(context),
                            Row(
                              children: [
                                Container(
                                  width: 120,
                                  child: ChoiceChip(
                                      selectedColor: AppColor.blackColor,
                                      label: Text(
                                        'Expense',
                                        style: GoogleFonts.poppins(
                                            color:
                                                type == TransactionType.expense
                                                    ? AppColor.whiteColor
                                                    : AppColor.blackColor),
                                      ),
                                      onSelected: (value) {
                                        context
                                            .read<TransactionCubit>()
                                            .setType(TransactionType.expense);
                                      },
                                      selected: type == TransactionType.expense
                                          ? true
                                          : false),
                                ),
                                0.04.pw(context),
                                Container(
                                  width: 110,
                                  child: ChoiceChip(
                                      selectedColor: AppColor.blackColor,
                                      label: Text(
                                        'Income',
                                        style: GoogleFonts.poppins(
                                            color:
                                                type == TransactionType.income
                                                    ? AppColor.whiteColor
                                                    : AppColor.blackColor),
                                      ),
                                      onSelected: (value) {
                                        context
                                            .read<TransactionCubit>()
                                            .setType(TransactionType.income);
                                      },
                                      selected: type == TransactionType.income
                                          ? true
                                          : false),
                                ),
                              ],
                            )
                          ],
                        ),
                        0.03.ph(context),
                        BlocBuilder<DateCubit, DateTime>(
                          builder: (context, selectedDate) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        final newDate = await showDatePicker(
                                          context: context,
                                          initialDate: selectedDate,
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2101),
                                        );
                                        if (newDate != null) {
                                          context
                                              .read<DateCubit>()
                                              .setDate(newDate);
                                        }
                                      },
                                      child: ReuseAbleContainer(
                                          icon: Icons.date_range),
                                    ),
                                    0.04.pw(context),
                                    Expanded(
                                        child: DateContainer(
                                            date: selectedDate
                                                .toLocal()
                                                .toString()))
                                  ],
                                ),
                                0.04.ph(context),
                                // ReuseAbleBtn(
                                //   ontap: () async {
                                //     // Add the amount to the system
                                //     context.read<AmountBloc>().add(
                                //           AmountAddEvent(
                                //             amount: amountController.text,
                                //             amountType: type.toString(),
                                //             descrip: dscripController.text,
                                //             date: selectedDate.toString(),
                                //           ),
                                //         );

                                //     // Refresh the home screen data
                                //     context
                                //         .read<HomeBloc>()
                                //         .add(RefreshHomeEvent());

                                //     // Show success toast message
                                //     Fluttertoast.showToast(
                                //       msg: "Amount added successfully!",
                                //       toastLength: Toast.LENGTH_SHORT,
                                //       gravity: ToastGravity.BOTTOM,
                                //       backgroundColor: Colors.green,
                                //       textColor: Colors.white,
                                //       fontSize: 16.0,
                                //     );

                                //     // Delay for a brief moment to allow the toast to show
                                //     await Future.delayed(
                                //         const Duration(seconds: 1));

                                //     // After delay, navigate back to the home page if mounted
                                //     if (context.mounted) {
                                //       Navigator.pop(context);
                                //     }
                                //   },
                                // )
                                ReuseAbleBtn(
                                  ontap: () async {
                                    if (amountController.text.isEmpty) {
                                      Fluttertoast.showToast(
                                        msg: "Please enter amount",
                                        backgroundColor: Colors.red,
                                      );
                                      return;
                                    }
                                    if (dscripController.text.isEmpty) {
                                      Fluttertoast.showToast(
                                        msg: "Please enter description",
                                        backgroundColor: Colors.red,
                                      );
                                      return;
                                    }

                                    if (widget.isEditing) {
                                      final newExpense = ExpenseModel(
                                        amount: amountController.text,
                                        amountType: type.toString(),
                                        descrip: dscripController.text,
                                        date: selectedDate.toString(),
                                      );
                                      context.read<HomeBloc>().add(
                                            UpdateExpenseEvent(
                                                widget.expenseToEdit!,
                                                newExpense),
                                          );
                                      Fluttertoast.showToast(
                                        msg: "Expense updated successfully!",
                                        backgroundColor: Colors.green,
                                      );
                                    } else {
                                      context.read<AmountBloc>().add(
                                            AmountAddEvent(
                                              amount: amountController.text,
                                              amountType: type.toString(),
                                              descrip: dscripController.text,
                                              date: selectedDate.toString(),
                                            ),
                                          );

                                      // Initialize notifications for new expense
                                      await LocalNotifications
                                          .initializeExpenseNotifications();

                                      context
                                          .read<HomeBloc>()
                                          .add(RefreshHomeEvent());

                                      Fluttertoast.showToast(
                                        msg: "Amount added successfully!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    }

                                    await Future.delayed(
                                        const Duration(seconds: 1));
                                    if (context.mounted) {
                                      Navigator.pop(context, true);
                                    }
                                  },
                                )
                              ],
                            );
                          },
                        )
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ));
  }
}
