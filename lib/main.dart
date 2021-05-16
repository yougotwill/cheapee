import 'dart:async';

import 'package:cheapee/src/widgets/itemList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'src/pages/home.dart';
import 'src/pages/scanItem.dart';
import 'src/pages/addItem.dart';
import 'src/pages/itemDetails.dart';

import 'src/widgets/itemList.dart' show Item;

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
          '/': (context) => Consumer<ApplicationState>(
                builder: (context, appState, _) => HomePage(
                    title: 'Cheapee',
                    items: appState.items,
                    clearItems: appState.clearItems),
              ),
          '/scan': (context) => Consumer<ApplicationState>(
                builder: (context, appState, _) =>
                    ScanItemPage(title: 'Add item: Scan'),
              ),
          '/add': (context) => Consumer<ApplicationState>(
                builder: (context, appState, _) => AddItemPage(
                  title: 'Add item: Enter details',
                  saveItem: appState.saveItem,
                ),
              ),
          '/details': (context) => Consumer<ApplicationState>(
                builder: (context, appState, _) => ItemDetailsPage(
                  title: 'Item Details',
                  saveItem: appState.saveItem,
                ),
              ),
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
    _itemsSubscription = FirebaseFirestore.instance
        .collection('items')
        .snapshots()
        .listen((snapshot) {
      _items = [];
      snapshot.docs.forEach((document) {
        _items.add(Item(
          category: document.data()['category'],
          barcode: document.data()['barcode'],
          name: document.data()['name'],
          units: document.data()['units'],
          uom: document.data()['uom'],
          price: document.data()['price'],
          rpu: document.data()['rpu'],
        ));
      });
      notifyListeners();
    });
  }

  // getters and setters
  StreamSubscription<QuerySnapshot>? _itemsSubscription;
  List<Item> _items = [];
  List<Item> get items => _items;

  // methods
  Future<DocumentReference> saveItem(String category, String barcode,
      String name, String units, String uom, String price) {
    // TODO checks shouldn't be needed because form verfies everything?
    // TODO Separate check for existing elements
    // calculate R per UoM (rpu)
    return FirebaseFirestore.instance.collection('items').add({
      'category': category,
      'barcode': barcode,
      'name': name,
      'units': units,
      'uom': uom,
      'price': price,
      'rpu': '0.0',
    });
  }

  Future<void> clearItems() {
    return FirebaseFirestore.instance
        .collection('items')
        .get()
        .then((snapshot) => {
              for (DocumentSnapshot doc in snapshot.docs)
                {doc.reference.delete()}
            });
  }
}
