import 'package:bloc/bloc.dart';

enum TransactionType { income, expense }

class TransactionCubit extends Cubit<TransactionType> {
  TransactionCubit() : super(TransactionType.income);

  void setType(TransactionType type) {
    emit(type);
  }
}
