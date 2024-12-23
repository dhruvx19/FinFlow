import 'package:expense_tracker/bloc/amount_bloc/amount_bloc.dart';
import 'package:expense_tracker/bloc/cubit/setDateCubit.dart';
import 'package:expense_tracker/bloc/cubit/transactionCubit.dart';
import 'package:expense_tracker/notification/notification.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/Models/expenseModel.dart';
import 'package:expense_tracker/bloc/home_bloc/home_bloc.dart';
import 'package:expense_tracker/services/hive_helper.dart';
import 'package:expense_tracker/views/homepage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';


final navigatorKey = GlobalKey<NavigatorState>();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
await LocalNotifications.init();

 
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(ExpenseModelAdapter());
  await Hive.openBox<ExpenseModel>('ExpenseBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TransactionCubit(),
        ),
        BlocProvider(
          create: (context) => DateCubit(),
        ),
        BlocProvider(
          create: (context) => AmountBloc(HiveHelper(), context),
        ),
        BlocProvider(
          create: (context) => HomeBloc(HiveHelper()),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense Tracker App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        home: const HomeView(),
      ),
    );
  }
}
