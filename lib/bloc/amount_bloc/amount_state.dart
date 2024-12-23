part of 'amount_bloc.dart';

abstract class AmountState extends Equatable {
  const AmountState();

  @override
  List<Object> get props => [];
}

class AmountInitial extends AmountState {}

class AmountValidateState extends AmountState {}

class AmountAddedSuccessState extends AmountState {
  final String successmsg;

  const AmountAddedSuccessState({required this.successmsg});
  @override
  List<Object> get props => [];
}

class AmountAddedErrorState extends AmountState {
  final String errormsg;

  const AmountAddedErrorState({required this.errormsg});
  @override
  List<Object> get props => [errormsg];
}
