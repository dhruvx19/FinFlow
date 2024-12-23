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
    LocalNotifications.init(); // Initialize notifications when app starts
    LocalNotifications.onClickNotification.stream.listen((payload) {
      if (payload == 'expense_reminder') {
        // Navigate to add expense screen or show summary
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ExpenseSummaryScreen()),
        );
      }
    });
    context.read<HomeBloc>().add(HomeLoadedEvent());
  }

  @override
  void dispose() {
    LocalNotifications.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).textScaler.scale(1.0);

    // Calculate responsive dimensions
    final double appBarHeight = size.height * 0.08;
    final double iconSize = (size.width * 0.05).clamp(20.0, 30.0);
    final double titleFontSize = (size.width * 0.05).clamp(16.0, 20.0);
    final double listItemFontSize = (size.width * 0.022).clamp(14.0, 17.0);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: appBarHeight,
        title: Text(
          'DashBoard',
          style: GoogleFonts.poppins(
              fontSize: titleFontSize / textScale, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: size.width * 0.04),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExpenseSummaryScreen(),
                  ),
                );
              },
              icon: Image.asset(
                ImageAsset.leadingHome,
                height: size.height * 0.04,
                width: size.width * 0.08,
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
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeLoadedState) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(RefreshHomeEvent());
              },
              child: Column(
                children: [
                  TotalBalanceComp(
                    value: state.totalBalance.toStringAsFixed(2),
                    Incnomevalue: state.totalIncome.toStringAsFixed(2),
                    Expensevalue: state.totalExpense.toStringAsFixed(2),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Expanded(
                    child: state.expenseList.isEmpty
                        ? Center(
                            child: Text(
                              'No expenses yet',
                              style: GoogleFonts.poppins(
                                fontSize: listItemFontSize,
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
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.04,
                                      vertical: size.height * 0.01,
                                    ),
                                    onLongPress: () => _showActionDialog(
                                        context, state.expenseList[index]),
                                    leading: Container(
                                      height: size.height * 0.06,
                                      width: size.width * 0.12,
                                      padding:
                                          EdgeInsets.all(size.width * 0.015),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Colors.black, Colors.blue],
                                          begin: Alignment.center,
                                          end: Alignment.topLeft,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Icon(
                                        Icons.currency_rupee_rounded,
                                        size: iconSize,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '₹${state.expenseList[index].amount.toString()}',
                                          style: GoogleFonts.poppins(
                                            fontSize: listItemFontSize,
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
                                            fontSize: listItemFontSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      Utils.dateFormated(state
                                          .expenseList[index].date
                                          .toString()),
                                      style: GoogleFonts.poppins(
                                        fontSize: listItemFontSize * 0.8,
                                      ),
                                    ),
                                    trailing: _buildTransactionIcon(
                                      context,
                                      state.expenseList[index].amountType ==
                                          'TransactionType.income',
                                      iconSize,
                                    ),
                                  ),
                                  Divider(
                                    endIndent: size.width * 0.08,
                                    indent: size.width * 0.08,
                                  ),
                                ],
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
      floatingActionButton: SizedBox(
        height: size.width * 0.14,
        width: size.width * 0.14,
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddAmount(),
              ),
            ).then((value) async {
              // Only initialize notifications if an expense was actually added
              if (value == true) {
                // Initialize notifications after expense is added
                await LocalNotifications.initializeExpenseNotifications();

                // Show confirmation notification
                await LocalNotifications.showNotification(
                  title: 'Expense Added',
                  body: 'Your expense has been tracked successfully!',
                  payload: 'expense_added',
                );
              }

              if (context.mounted) {
                context.read<HomeBloc>().add(RefreshHomeEvent());
              }
            });
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: iconSize,
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionIcon(
      BuildContext context, bool isIncome, double iconSize) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(right: size.width * 0.02),
      padding: EdgeInsets.all(size.width * 0.015),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        isIncome ? Icons.arrow_downward : Icons.arrow_upward,
        size: iconSize,
        color: isIncome ? Colors.green[700] : Colors.red[700],
      ),
    );
  }

  void _showActionDialog(BuildContext context, dynamic expense) {
    showDialog(
      context: context,
      builder: (context) => ExpenseActionDialog(
        expense: expense,
        onEdit: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAmount(
                isEditing: true,
                expenseToEdit: expense,
              ),
            ),
          );
          if (context.mounted) {
            context.read<HomeBloc>().add(RefreshHomeEvent());
          }
        },
        onDelete: () => _showDeleteConfirmation(context, expense),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, dynamic expense) {
    final textScale = MediaQuery.of(context).textScaler.scale(1.0);
    final fontSize =
        (MediaQuery.of(context).size.width * 0.04).clamp(14.0, 16.0);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirm Delete',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: fontSize / textScale,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this expense?',
          style: GoogleFonts.poppins(
            fontSize: fontSize / textScale,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                fontSize: fontSize / textScale,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<HomeBloc>().add(DeleteExpenseEvent(expense));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Expense deleted successfully',
                    style: GoogleFonts.poppins(
                      fontSize: fontSize / textScale,
                    ),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontSize: fontSize / textScale,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
