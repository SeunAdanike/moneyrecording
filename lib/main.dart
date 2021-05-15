import 'package:flutter/material.dart';
import 'package:money_monitoring/UIs/first__screen.dart';

import 'package:provider/provider.dart';

import './UIs/adcodepassword.dart';

import './providers/methodhelps.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MethodsNotifier(),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Money Management',
        home: AdcodePassword(),
        routes: {
          '/FirstScreen': (context) => FirstScreen(),
        },
      ),
    );
  }
}
