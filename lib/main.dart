import 'package:apptry/components/splash_screen.dart';
import 'package:apptry/pages/customers/add_customer.dart';
import 'package:apptry/pages/cold_store_details.dart';
import 'package:apptry/pages/customers/customers.dart';
import 'package:apptry/pages/entries/entry.dart';
import 'package:apptry/pages/entries/new_entry.dart';
import 'package:apptry/pages/login.dart';
import 'package:flutter/material.dart';
import 'pages/home.dart';

void main() async {
  debugPrint = (String? message, {int? wrapWidth}) {};
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          'home': (context) => HomePage(),
          'login': (context) => LoginPage(),
          'customers': (context) => CustomerPage(),
          'new-customer': (context) => AddNewCustomerPage(),
          // 'customer-entries': (context) => CustomerEntriesPage(),
          'new-entry': (context) => EntryPage(),
          'cold-store-details': (context) => ColdStoreDetails(),
          'entry': (context) => EntryHomePage(),
        });
  }
}
