import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:FinFlow/services/hive_helper.dart';
part 'amount_event.dart';
part 'amount_state.dart';

class AmountBloc extends Bloc<AmountEvent, AmountState> {
  final HiveHelper helper;
  final BuildContext context;
  AmountBloc(this.helper, this.context) : super(AmountInitial()) {
    on<AmountAddEvent>((event, emit) async {
      try {
        if (event.amount.isEmpty) {
          emit(const AmountAddedErrorState(
              errormsg: 'Please Enter the amount'));
          if (kDebugMode) {
            print('enter the data');
          }
        } else if (event.descrip.isEmpty) {
          emit(const AmountAddedErrorState(
              errormsg: 'Please Enter the Description'));
        } else {
          emit(AmountValidateState());
          await helper
              .addAmount(
                  event.amount, event.amountType, event.descrip, event.date)
              .then((value) =>
                  emit(const AmountAddedSuccessState(successmsg: 'Success')));
        }
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
        emit(AmountAddedErrorState(errormsg: e.toString()));
      }
    });
  }
}
