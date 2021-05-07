import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'src/pages/home.dart';
import 'src/pages/addItem.dart';
import 'package:cheapee/src/pages/addItemManual.dart';
import 'package:cheapee/src/pages/addItemBarcode.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, _) => App(),
    ),
  );
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Cheapee',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.indigo,
        ),
        routes: {
          '/': (context) => HomePage(title: 'Cheapee'),
          '/add': (context) => AddItemPage(title: 'Add item'),
          '/add/manual': (context) =>
              AddItemManualPage(title: 'Add item manually'),
          '/add/scan': (context) =>
              AddItemBarcodePage(title: 'Add item manually'),
        });
  }
}

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();

    // fetch ListItems from the store

    // getters and setters

    // methods
  }
}
