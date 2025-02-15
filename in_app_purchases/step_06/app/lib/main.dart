import 'package:flutter/material.dart';
import 'package:dashclicker/logic/dash_purchases.dart';
import 'package:dashclicker/logic/firebase_notifier.dart';
import 'package:dashclicker/repo/iap_repo.dart';
import 'package:provider/provider.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'logic/dash_upgrades.dart';
import 'logic/dash_counter.dart';
import 'pages/home_page.dart';
import 'pages/purchase_page.dart';

// Gives the option to override in tests.
class IAPConnection {
  static InAppPurchaseConnection? _instance;
  static set instance(InAppPurchaseConnection value) {
    _instance = value;
  }

  static InAppPurchaseConnection get instance {
    _instance ??= InAppPurchaseConnection.instance;
    return _instance!;
  }
}

void main() {
  InAppPurchaseConnection.enablePendingPurchases();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dash Clicker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Dash Clicker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

typedef PageBuilder = Widget Function();

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = [
    HomePage(),
    PurchasePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FirebaseNotifier>(
            create: (_) => FirebaseNotifier()),
        ChangeNotifierProvider<DashCounter>(create: (_) => DashCounter()),
        ChangeNotifierProvider<DashUpgrades>(
          create: (context) => DashUpgrades(
            context.read<DashCounter>(),
            context.read<FirebaseNotifier>(),
          ),
        ),
        ChangeNotifierProvider<IAPRepo>(
          create: (context) => IAPRepo(context.read<FirebaseNotifier>()),
        ),
        ChangeNotifierProvider<DashPurchases>(
          create: (context) => DashPurchases(
            context.read<DashCounter>(),
          ),
          lazy: false,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: _widgetOptions[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shop),
              label: 'Purchase',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: (index) => setState(() => _selectedIndex = index),
        ),
      ),
    );
  }
}
