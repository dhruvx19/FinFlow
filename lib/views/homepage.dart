import 'package:expense_tracker/notification/notification.dart';
import 'package:expense_tracker/res/components/add_del.dart';
import 'package:expense_tracker/res/components/totalBalance.dart';
import 'package:expense_tracker/utils/Asset/imageAsset.dart';
import 'package:expense_tracker/utils/extension/extension.dart';
import 'package:expense_tracker/utils/utils.dart';
import 'package:expense_tracker/views/AddAmount.dart';
import 'package:expense_tracker/views/dashboard.dart';
import 'package:expense_tracker/views/summary.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/bloc/home_bloc/home_bloc.dart';
import 'package:expense_tracker/bloc/home_bloc/home_event.dart';
import 'package:expense_tracker/bloc/home_bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    listenToNotifications();
    context.read<HomeBloc>().add(HomeLoadedEvent());
  }

  listenToNotifications() {
    print("Listening to notification");
    LocalNotifications.onClickNotification.stream.listen((event) {
      print(event);
      Navigator.pushNamed(context, '/', arguments: event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DashBoard',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: context.mw * 0.04),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExpenseSummaryScreen(),
                    ));
              },
              icon: Image.asset(
                ImageAsset.leadingHome,
                height: context.mh * 0.09,
                width: context.mw * 0.09,
                color: Colors.black,
                semanticLabel: 'Summary',
                
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is HomeLoadedState) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(RefreshHomeEvent());
              },
              child: Column(
                children: [
                  // In your HomeView, update the TotalBalanceComp usage:
                  TotalBalanceComp(
                    value: state.totalBalance.toStringAsFixed(2),
                    Incnomevalue: state.totalIncome.toStringAsFixed(2),
                    Expensevalue: state.totalExpense.toStringAsFixed(2),
                  ),
                  0.03.ph(context),
                  Expanded(
                    child: state.expenseList.isEmpty
                        ? Center(
                            child: Text(
                              'No expenses yet',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: state.expenseList.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            ExpenseActionDialog(
                                          expense: state.expenseList[index],
                                          onEdit: () async {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => AddAmount(
                                                  isEditing: true,
                                                  expenseToEdit:
                                                      state.expenseList[index],
                                                ),
                                              ),
                                            );
                                            // Refresh after returning from edit screen
                                            if (context.mounted) {
                                              context
                                                  .read<HomeBloc>()
                                                  .add(RefreshHomeEvent());
                                            }
                                          },
                                          onDelete: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text('Confirm Delete',
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                content: Text(
                                                    'Are you sure you want to delete this expense?',
                                                    style:
                                                        GoogleFonts.poppins()),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text('Cancel',
                                                        style: GoogleFonts
                                                            .poppins()),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      context
                                                          .read<HomeBloc>()
                                                          .add(DeleteExpenseEvent(
                                                              state.expenseList[
                                                                  index]));
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Expense deleted successfully',
                                                              style: GoogleFonts
                                                                  .poppins()),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      );
                                                    },
                                                    child: Text('Delete',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .red)),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    leading: Container(
                                      height: context.mh * 0.14,
                                      width: context.mh * 0.07,
                                      margin: EdgeInsets.only(
                                          right: context.mw * 0.03),
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                              colors: [
                                                Colors.black,
                                                Colors.blue,
                                              ],
                                              begin: Alignment.center,
                                              end: Alignment.topLeft),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: const Icon(
                                          Icons.currency_rupee_rounded,
                                          size: 20,
                                          color: Colors.white),
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '₹${state.expenseList[index].amount.toString()}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: state.expenseList[index]
                                                        .amountType ==
                                                    'TransactionType.income'
                                                ? Colors.green[700]
                                                : Colors.red[700],
                                          ),
                                        ),
                                        Text(
                                          state.expenseList[index].descrip,
                                          style: GoogleFonts.poppins(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(Utils.dateFormated(state
                                        .expenseList[index].date
                                        .toString())),
                                    trailing: state.expenseList[index]
                                                .amountType ==
                                            'TransactionType.income'
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                right: context.mw * 0.03),
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Icon(
                                              Icons.arrow_downward,
                                              size: 30,
                                              color: Colors.green[700],
                                            ),
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(
                                                right: context.mw * 0.03),
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Icon(
                                              Icons.arrow_upward,
                                              size: 30,
                                              color: Colors.red[700],
                                            ),
                                          ),
                                  ),
                                  const Divider(
                                    endIndent: 30,
                                    indent: 30,
                                  )
                                ],
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddAmount(),
            ),
          );
          // Refresh after returning from add screen
          if (context.mounted) {
            context.read<HomeBloc>().add(RefreshHomeEvent());
          }
          LocalNotifications.showScheduleNotification(
              title: "Reminder",
              body: "Add your Expense Now!!",
              payload: "Notification");
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
