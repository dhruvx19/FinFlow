import 'package:bloc_test/bloc_test.dart';
import 'package:FinFlow/models/expenseModel.dart';
import 'package:FinFlow/bloc/home_bloc/home_bloc.dart';
import 'package:FinFlow/bloc/home_bloc/home_event.dart';
import 'package:FinFlow/bloc/home_bloc/home_state.dart';

import 'package:FinFlow/services/hive_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHiveHelper extends Mock implements HiveHelper {}

void main() {
  late MockHiveHelper mockHiveHelper;
  late HomeBloc homeBloc;

  setUp(() {
    mockHiveHelper = MockHiveHelper();
    homeBloc = HomeBloc(mockHiveHelper);
  });

  tearDown(() {
    homeBloc.close();
  });

  group('HomeBloc Tests', () {
    test('Initial state is HomeInitial', () {
      expect(homeBloc.state, equals(const HomeInitial()));
    });

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoadingState, HomeLoadedState] when HomeLoadedEvent is added and data is loaded successfully',
      build: () {
        when(() => mockHiveHelper.getAllExpenses()).thenAnswer((_) async => [
              ExpenseModel(
                  amount: '100.00',
                  amountType: 'TransactionType.income',
                  descrip: 'Salary',
                  date: '2024-01-01'),
              ExpenseModel(
                  amount: '50.00',
                  amountType: 'TransactionType.expense',
                  descrip: 'Groceries',
                  date: '2024-01-02'),
            ]);
        return homeBloc;
      },
      act: (bloc) => bloc.add(HomeLoadedEvent()),
      expect: () => [
        const HomeLoadingState(),
        HomeLoadedState(
          expenseList: [
            ExpenseModel(
                amount: '50.00',
                amountType: 'TransactionType.expense',
                descrip: 'Groceries',
                date: '2024-01-02'),
            ExpenseModel(
                amount: '100.00',
                amountType: 'TransactionType.income',
                descrip: 'Salary',
                date: '2024-01-01'),
          ],
          totalBalance: 50.0,
          totalIncome: 100.0,
          totalExpense: 50.0,
        ),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoadingState, HomeErrorState] when getAllExpenses throws an exception',
      build: () {
        when(() => mockHiveHelper.getAllExpenses())
            .thenThrow(Exception('Error loading expenses'));
        return homeBloc;
      },
      act: (bloc) => bloc.add(HomeLoadedEvent()),
      expect: () => [
        const HomeLoadingState(),
        HomeErrorState('Failed to load expenses: Exception: Error loading expenses'),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoadingState, HomeErrorState] when deleteExpense fails',
      build: () {
        when(() => mockHiveHelper.deleteExpense(any())).thenAnswer((_) async => false);
        return homeBloc;
      },
      act: (bloc) => bloc.add(DeleteExpenseEvent(ExpenseModel(
          amount: '50.00',
          amountType: 'TransactionType.expense',
          descrip: 'Groceries',
          date: '2024-01-02'))),
      expect: () => [
        const HomeLoadingState(),
        const HomeErrorState('Failed to delete expense'),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoadingState, HomeLoadedState] when deleteExpense succeeds',
      build: () {
        when(() => mockHiveHelper.deleteExpense(any())).thenAnswer((_) async => true);
        when(() => mockHiveHelper.getAllExpenses()).thenAnswer((_) async => [
              ExpenseModel(
                  amount: '100.00',
                  amountType: 'TransactionType.income',
                  descrip: 'Salary',
                  date: '2024-01-01'),
            ]);
        return homeBloc;
      },
      act: (bloc) => bloc.add(DeleteExpenseEvent(ExpenseModel(
          amount: '50.00',
          amountType: 'TransactionType.expense',
          descrip: 'Groceries',
          date: '2024-01-02'))),
      expect: () => [
        const HomeLoadingState(),
        HomeLoadedState(
          expenseList: [
            ExpenseModel(
                amount: '100.00',
                amountType: 'TransactionType.income',
                descrip: 'Salary',
                date: '2024-01-01'),
          ],
          totalBalance: 100.0,
          totalIncome: 100.0,
          totalExpense: 0.0,
        ),
      ],
    );
  });
}
