import 'package:apptry/components/splash_screen.dart';
import 'package:apptry/pages/customers/add_customer.dart';
import 'package:apptry/pages/cold_store_details.dart';
import 'package:apptry/pages/customers/customers.dart';
import 'package:apptry/pages/entries/entry_home.dart';
import 'package:apptry/pages/entries/new_entry_page.dart';
import 'package:apptry/models/variety_model.dart';
import 'package:apptry/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home.dart';

void main() async {
  runApp(ChangeNotifierProvider(
      create: (context) => VarietyModel(), child: MyApp()));
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
          'new-entry': (context) => NewEntryPage(),
          'cold-store-details': (context) => ColdStoreDetails(),
          'entry': (context) => EntryHomePage(),
        });
  }
}
