import 'package:FinFlow/bloc/amount_bloc/amount_bloc.dart';
import 'package:FinFlow/bloc/cubit/setDateCubit.dart';
import 'package:FinFlow/bloc/cubit/transactionCubit.dart';
import 'package:FinFlow/firebase_options.dart';
import 'package:FinFlow/services/notification/notification.dart';
import 'package:FinFlow/views/login/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:FinFlow/models/expenseModel.dart';
import 'package:FinFlow/bloc/home_bloc/home_bloc.dart';
import 'package:FinFlow/services/hive_helper.dart';
import 'package:FinFlow/views/homepage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

final navigatorKey = GlobalKey<NavigatorState>();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Initialize notifications
  await LocalNotifications.init();
  
  // Initialize Hive
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(ExpenseModelAdapter());
  await Hive.openBox<ExpenseModel>('ExpenseBox');
  await Hive.openBox('authBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TransactionCubit()),
        BlocProvider(create: (context) => DateCubit()),
        BlocProvider(create: (context) => AmountBloc(HiveHelper(), context)),
        BlocProvider(create: (context) => HomeBloc(HiveHelper()))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'Expense Tracker App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              return const HomeView();
            }
            return Signup();
          },
        ),
      ),
    );
  }
}