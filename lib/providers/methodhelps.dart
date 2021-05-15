import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../connections/database_management.dart';
import '../models/expenses.dart';

class MethodsNotifier extends ChangeNotifier {
  List<Expenses> _expenseList = [];
  DatabaseManager _databaseManager = DatabaseManager();
  int _total = 0;
  int get total => _total;
  List<Expenses> get expenseList => _expenseList;

  List<Expenses> _expenses = [];
  List<Expenses> get expenses => _expenses;

  int _filteredTotal = 0;
  int get filteredTotal => _filteredTotal;

  getAllValues() async {
    _total = 0;
    _expenseList = [];
    var expenses = await _databaseManager.getAllExpenses();
    expenses.forEach((expense) {
      Expenses expenseModel = Expenses();
      expenseModel.id = expense['id'];
      expenseModel.amount = expense['amount'];
      expenseModel.date = expense['date'];
      expenseModel.details = expense['details'];
      expenseModel.title = expense['title'];
      expenseModel.type = expense['type'];
      _expenseList.add(expenseModel);
    });
    for (int y = 0; y < _expenseList.length; y++) {
      if (_expenseList[y].type == 'Credit')
        _total += _expenseList[y].amount;
      else
        _total -= _expenseList[y].amount;
    }
    notifyListeners();
  }

  filteredExpenses(getDate) async {
    _filteredTotal = 0;
    _expenses = [];
    await getAllValues();
    for (int i = 0; i < expenseList.length; i++) {
      if (expenseList[i].date == getDate) {
        _expenses.add(
          expenseList[i],
        );
      }
    }
    for (int i = 0; i < _expenses.length; i++) {
      if (_expenses[i].type == 'Credit')
        _filteredTotal += _expenses[i].amount;
      else
        _filteredTotal -= _expenses[i].amount;
    }
    notifyListeners();
  }

  comfirmationDialog(BuildContext context, Expenses expenses) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (value) {
        return AlertDialog(
            actionsPadding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: Center(child: Text('Delete Confirmation')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Are you sure you want to delete this expense?',
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ubuntu(
                      fontSize: 20,
                      color: Colors.black,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        var result = await _databaseManager.delete(expenses.id);
                        if (result > 0) {
                          showSnackBar(
                            '${expenses.title} expenses is deleted',
                            context,
                          );
                          getAllValues();
                        }

                        Navigator.pop(context);
                      },
                      child: Text('Delete',
                          style: GoogleFonts.ubuntu(
                            fontSize: 18,
                            color: Colors.red,
                          )),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel',
                          style: GoogleFonts.ubuntu(
                            fontSize: 18,
                            color: Colors.black,
                          )),
                    ),
                  ],
                ),
              ],
            ));
      },
    );
  }

  filteredComfirmationDialog(
      BuildContext context, Expenses expenses, String givenDate) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (value) {
        return AlertDialog(
            actionsPadding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: Center(child: Text('Delete Confirmation')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Are you sure you want to delete this expense?',
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ubuntu(
                      fontSize: 20,
                      color: Colors.black,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        var result = await _databaseManager.delete(expenses.id);
                        if (result > 0) {
                          showSnackBar(
                            '${expenses.title} expenses is deleted',
                            context,
                          );
                          filteredExpenses(givenDate);
                        }

                        Navigator.pop(context);
                      },
                      child: Text('Delete',
                          style: GoogleFonts.ubuntu(
                            fontSize: 18,
                            color: Colors.red,
                          )),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel',
                          style: GoogleFonts.ubuntu(
                            fontSize: 18,
                            color: Colors.black,
                          )),
                    ),
                  ],
                ),
              ],
            ));
      },
    );
  }

  showSnackBar(message, context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.ubuntu(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
