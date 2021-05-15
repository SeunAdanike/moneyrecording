import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../connections/database_management.dart';
import '../models/expenses.dart';

class DetailsScreen extends StatefulWidget {
  final Expenses expense;

  DetailsScreen(this.expense);
  @override
  _DetailsScreenState createState() => _DetailsScreenState(expense);
}

class _DetailsScreenState extends State<DetailsScreen> {
  Expenses _expense;

  _DetailsScreenState(this._expense);
  DatabaseManager _databaseManager = DatabaseManager();

  _showSnackBar(message) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(28, 27, 27, 1),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 100,
          right: 20,
          left: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    'Expense Title',
                    style: GoogleFonts.ubuntu(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Divider(
                    height: 10,
                    indent: 70,
                    endIndent: 70,
                    color: Colors.white60,
                  ),
                  AutoSizeText(
                    _expense.title,
                    style: GoogleFonts.ubuntu(
                      fontStyle: FontStyle.italic,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              Divider(
                height: 50,
              ),
              Column(
                children: [
                  Text(
                    'Expense Details',
                    style: GoogleFonts.ubuntu(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Divider(
                    height: 10,
                    indent: 70,
                    endIndent: 70,
                    color: Colors.white60,
                  ),
                  AutoSizeText(
                    _expense.details,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ubuntu(
                      fontStyle: FontStyle.italic,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              Divider(
                height: 50,
              ),
              Column(
                children: [
                  Text(
                    'Amount',
                    style: GoogleFonts.ubuntu(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Divider(
                    height: 10,
                    indent: 70,
                    endIndent: 70,
                    color: Colors.white60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${_expense.type}: ',
                        style: GoogleFonts.ubuntu(
                          fontStyle: FontStyle.italic,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      AutoSizeText(
                        '#${_expense.amount}',
                        style: GoogleFonts.ubuntu(
                          fontStyle: FontStyle.italic,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: _expense.type == 'Debit'
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Divider(
                height: 50,
              ),
              Column(
                children: [
                  Text(
                    'Amount',
                    style: GoogleFonts.ubuntu(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Divider(
                    height: 10,
                    indent: 70,
                    endIndent: 70,
                    color: Colors.white60,
                  ),
                  AutoSizeText(
                    _expense.date,
                    style: GoogleFonts.ubuntu(
                      fontStyle: FontStyle.italic,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              Divider(
                height: 60,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  primary: Colors.white,
                  onPrimary: Colors.black,
                ),
                child: Text('Back',
                    style: GoogleFonts.ubuntu(
                      fontSize: 18,
                      color: Colors.black,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
