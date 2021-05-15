import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_monitoring/models/expenses.dart';

import 'package:provider/provider.dart';

import '../providers/methodhelps.dart';
import 'package:money_monitoring/UIs/details_screen.dart';

class FilterScreen extends StatefulWidget {
  final String date;

  FilterScreen(this.date);
  @override
  _FilterScreenState createState() => _FilterScreenState(date);
}

class _FilterScreenState extends State<FilterScreen> {
  _FilterScreenState(this._date);

  String _date;

  final _scrollController = ScrollController();

  MethodsNotifier methodsNotifier;

  @override
  void initState() {
    methodsNotifier = Provider.of<MethodsNotifier>(context, listen: false);
    methodsNotifier.filteredExpenses(_date);
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
        padding: const EdgeInsets.only(
          top: 40,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AutoSizeText(
              'Summary of $_date Expenses',
              style: GoogleFonts.ubuntu(
                fontStyle: FontStyle.italic,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 30,
                top: 10,
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
                    padding: const EdgeInsets.only(
                      top: 250,
                      left: 20,
                      right: 20,
                    ),
                    child: Text(
                      'You do not have any expenses recorded for $_date',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ubuntu(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Expanded(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                      .watch<MethodsNotifier>()
                                                      .expenses[index])),
                                        );
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        height: 40,
                                        child: AutoSizeText(
                                          methodsNotifier.expenses[index].title,
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
                                                      .watch<MethodsNotifier>()
                                                      .expenses[index])),
                                        );
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        height: 40,
                                        child: AutoSizeText(
                                          context
                                              .watch<MethodsNotifier>()
                                              .expenses[index]
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
                                            '#${context.watch<MethodsNotifier>().expenses[index].amount.toString()}',
                                            maxLines: 1,
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: context
                                                          .watch<
                                                              MethodsNotifier>()
                                                          .expenses[index]
                                                          .type ==
                                                      'Credit'
                                                  ? Colors.green
                                                  : Colors.redAccent,
                                            ),
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: InkWell(
                                        onTap: () {
                                          context
                                              .read<MethodsNotifier>()
                                              .filteredComfirmationDialog(
                                                  context,
                                                  methodsNotifier
                                                      .expenses[index],
                                                  _date);
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
                          itemCount:
                              context.watch<MethodsNotifier>().expenses.length,
                          shrinkWrap: true,
                        ),
                      ),
                    ),
                  ),
            if (context.watch<MethodsNotifier>().expenseList.isNotEmpty)
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
                    '#${context.watch<MethodsNotifier>().filteredTotal.abs()}',
                    style: GoogleFonts.ubuntu(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: context.watch<MethodsNotifier>().filteredTotal >= 0
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            Divider(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
