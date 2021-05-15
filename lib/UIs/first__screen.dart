import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'dart:ui' as ui;

import '../UIs/details_screen.dart';
import '../UIs/filter_screen.dart';
import '../connections/database_management.dart';
import '../providers/methodhelps.dart';
import '../models/expenses.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  var _titleController = TextEditingController();
  var _detailsController = TextEditingController();
  var _amountController = TextEditingController();
  var _dueDate = TextEditingController();
  var _chosenVal;
  DateTime _date;

  Expenses newExpenses;

  DatabaseManager _databaseManager = DatabaseManager();

  final _scrollController = ScrollController();

  MethodsNotifier methodsNotifier;

  final _formKey = GlobalKey<FormState>();

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

  _addExpensesToDb() async {
    newExpenses = Expenses();
    newExpenses.date = _dueDate.text;
    newExpenses.amount = int.parse(_amountController.text);
    newExpenses.title = _titleController.text;
    newExpenses.details = _detailsController.text;
    newExpenses.type = _chosenVal;

    var addingTask = await _databaseManager.saveExpense(newExpenses.taskMap());

    if (addingTask > 0) {
      _showSnackBar('Expense has been added successfully');
    }
  }

  _selectDueDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2018),
        lastDate: DateTime(2099),
        helpText: 'Choose Date',
        cancelText: 'Return',
        confirmText: 'Select',
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: Colors.black,
              accentColor: Colors.black,
              colorScheme: ColorScheme.light(primary: Colors.black),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child,
          );
        });
    if (_pickedDate != null) {
      setState(() {
        _date = _pickedDate;
        _dueDate.text = DateFormat.yMMMEd().format(_pickedDate);
      });
    }
  }

  @override
  void initState() {
    _date = DateTime.now();
    methodsNotifier = Provider.of<MethodsNotifier>(context, listen: false);
    methodsNotifier.getAllValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromRGBO(28, 27, 27, 1),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 40, 10, 40),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: InkWell(
                      onTap: () {
                        _selectDueDate(context);
                      },
                      child: TextFormField(
                        style: GoogleFonts.ubuntu(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                        readOnly: true,
                        controller: _dueDate,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(),
                          ),
                          hintText: 'Choose Date',
                          hintStyle: GoogleFonts.ubuntu(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            color: Colors.black54,
                          ),
                          suffixIcon: InkWell(
                              onTap: () {
                                _selectDueDate(context);
                              },
                              child: Icon(Icons.calendar_today)),
                          labelStyle: GoogleFonts.ubuntu(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please pick a date';
                          }
                        },
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          var _todaysDate = DateTime.now();
                          setState(() {
                            _dueDate.text =
                                DateFormat.yMMMEd().format(_todaysDate);
                          });
                        },
                        child: Text(
                          'Today\'s Date',
                          style: GoogleFonts.ubuntu(
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                            fontSize: 21,
                          ),
                        ),
                      ),
                      Directionality(
                        textDirection: ui.TextDirection.ltr,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            primary: Colors.white,
                            onPrimary: Colors.black,
                          ),
                          onPressed: () {
                            _dueDate.text.isNotEmpty
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FilterScreen(_dueDate.text)),
                                  )
                                : showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (value) {
                                      return AlertDialog(
                                          actionsPadding: EdgeInsets.all(10),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          title: Center(
                                              child: Text('Invalid Entry')),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  'Please select the date you want to filter with the calendar icon',
                                                  softWrap: true,
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.ubuntu(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                  )),
                                              Directionality(
                                                textDirection:
                                                    ui.TextDirection.rtl,
                                                child: TextButton.icon(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  icon: Icon(
                                                    Icons.cancel_outlined,
                                                    color: Colors.red,
                                                  ),
                                                  label: Text('Cancel',
                                                      style: GoogleFonts.ubuntu(
                                                        fontSize: 18,
                                                        color: Colors.black,
                                                      )),
                                                ),
                                              ),
                                            ],
                                          ));
                                    },
                                  );
                            ;
                          },
                          icon: Icon(
                            Icons.filter_alt_sharp,
                            color: Colors.blue,
                          ),
                          label: Text(
                            'Filter Date',
                            style: GoogleFonts.ubuntu(
                              fontSize: 19,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                    ),
                    child: Container(
                      height: 70,
                      width: MediaQuery.of(context).size.width * 0.39,
                      child: TextFormField(
                        maxLength: 10,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        controller: _titleController,
                        style: GoogleFonts.ubuntu(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(),
                          ),
                          hintText: 'Title',
                          hintStyle: GoogleFonts.ubuntu(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter a Title';
                          }
                        },
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        focusColor: Colors.white,
                        value: _chosenVal,
                        style: TextStyle(color: Colors.white),
                        iconEnabledColor: Colors.black,
                        items: <String>[
                          'Debit',
                          'Credit',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: GoogleFonts.ubuntu(
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontSize: 21,
                              ),
                            ),
                          );
                        }).toList(),
                        hint: Text(
                          "Type",
                          style: GoogleFonts.ubuntu(
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                            fontSize: 20,
                          ),
                        ),
                        onChanged: (String value) {
                          setState(() {
                            _chosenVal = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 17,
                    ),
                    child: SizedBox(
                      height: 70,
                      width: MediaQuery.of(context).size.width * 0.255,
                      child: TextFormField(
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        maxLength: 7,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        controller: _amountController,
                        style: GoogleFonts.ubuntu(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(),
                          ),
                          hintText: 'Amount',
                          hintStyle: GoogleFonts.ubuntu(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter Amount';
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 7,
                  bottom: 15,
                ),
                child: Container(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _detailsController,
                    style: GoogleFonts.ubuntu(
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(),
                      ),
                      hintText: 'Enter Expenses Details',
                      hintStyle: GoogleFonts.ubuntu(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Expenses Details';
                      }
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _addExpensesToDb().then((_) {
                          methodsNotifier.getAllValues();
                          FocusScope.of(context).unfocus();
                          setState(() {
                            _titleController.clear();
                            _detailsController.clear();
                            _amountController.clear();
                            _dueDate.clear();
                          });
                        });
                      }
                    },
                    icon: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    label: Text(
                      'Submit',
                      style: GoogleFonts.ubuntu(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        primary: Colors.white,
                        onPrimary: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _titleController.clear();
                          _detailsController.clear();
                          _amountController.clear();
                          _dueDate.clear();
                        });
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                      label: Text(
                        'Clear',
                        style: GoogleFonts.ubuntu(
                          fontSize: 19,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Divider(),
              Divider(
                thickness: 3,
                color: Colors.white,
              ),
              Text(
                'Summary',
                style: GoogleFonts.ubuntu(
                  fontStyle: FontStyle.italic,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(
                  left: 28,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Text(
                        'Title',
                        style: GoogleFonts.ubuntu(
                          fontStyle: FontStyle.italic,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Text(
                        'Date',
                        style: GoogleFonts.ubuntu(
                          fontStyle: FontStyle.italic,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Text(
                        'Amount',
                        style: GoogleFonts.ubuntu(
                          fontStyle: FontStyle.italic,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              context.watch<MethodsNotifier>().expenseList.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Text(
                        'You are yet to add any expenses',
                        style: GoogleFonts.ubuntu(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: RawScrollbar(
                              radius: Radius.circular(30),
                              thickness: 3,
                              thumbColor: Colors.white54,
                              isAlwaysShown: true,
                              controller: _scrollController,
                              child: Consumer<MethodsNotifier>(
                                builder: (_, notifier, __) => ListView.builder(
                                  controller: _scrollController,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              '${index + 1}',
                                              style: GoogleFonts.ubuntu(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailsScreen(context
                                                              .watch<
                                                                  MethodsNotifier>()
                                                              .expenseList[index])),
                                                );
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.25,
                                                height: 40,
                                                child: AutoSizeText(
                                                  methodsNotifier
                                                      .expenseList[index].title,
                                                  maxLines: 1,
                                                  style: GoogleFonts.ubuntu(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailsScreen(context
                                                              .watch<
                                                                  MethodsNotifier>()
                                                              .expenseList[index])),
                                                );
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                height: 40,
                                                child: AutoSizeText(
                                                  context
                                                      .watch<MethodsNotifier>()
                                                      .expenseList[index]
                                                      .date,
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.ubuntu(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                  height: 40,
                                                  child: AutoSizeText(
                                                    '#${context.watch<MethodsNotifier>().expenseList[index].amount.toString()}',
                                                    maxLines: 1,
                                                    style: GoogleFonts.ubuntu(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: context
                                                                  .watch<
                                                                      MethodsNotifier>()
                                                                  .expenseList[
                                                                      index]
                                                                  .type ==
                                                              'Credit'
                                                          ? Colors.green
                                                          : Colors.redAccent,
                                                    ),
                                                  )),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: InkWell(
                                                onTap: () {
                                                  context
                                                      .read<MethodsNotifier>()
                                                      .comfirmationDialog(
                                                        context,
                                                        methodsNotifier
                                                            .expenseList[index],
                                                      );
                                                },
                                                child: Icon(
                                                  Icons.remove,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Divider(
                                          endIndent: 10,
                                          thickness: 2,
                                          color: Colors.white,
                                        )
                                      ],
                                    );
                                  },
                                  itemCount: context
                                      .watch<MethodsNotifier>()
                                      .expenseList
                                      .length,
                                  shrinkWrap: true,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Total :\t ',
                                style: GoogleFonts.ubuntu(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '#${context.watch<MethodsNotifier>().total.abs()}',
                                style: GoogleFonts.ubuntu(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      context.watch<MethodsNotifier>().total >=
                                              0
                                          ? Colors.green
                                          : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
