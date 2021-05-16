import 'dart:async';

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Cheapee',
        theme: ThemeData(
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
                builder: (context, appState, _) => ScanItemPage(
                    title: 'Add Barcode',
                    isExistingItem: appState.isExistingItem),
              ),
          '/add': (context) => Consumer<ApplicationState>(
                builder: (context, appState, _) => AddItemPage(
                  title: 'Add Details',
                  saveItem: appState.saveItem,
                  isExistingItem: appState.isExistingItem,
                ),
              ),
          '/details': (context) => Consumer<ApplicationState>(
                builder: (context, appState, _) => ItemDetailsPage(
                  title: 'View Details',
                  saveItem: appState.saveItem,
                  isExistingItem: appState.isExistingItem,
                ),
              ),
        });
  }
}

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  @override
  void dispose() {
    super.dispose();
    _itemsSubscription?.cancel();
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
  Future<void> saveItem(String category, String barcode, String name,
      String units, String uom, String price) {
    final String rpu =
        (double.parse(price) / double.parse(units)).toStringAsFixed(2);

    return FirebaseFirestore.instance.collection('items').doc(barcode).set({
      'category': category,
      'barcode': barcode,
      'name': name,
      'units': units,
      'uom': uom,
      'price': price,
      'rpu': 'R$rpu / $uom',
    });
  }

  Future<Item?> isExistingItem(String barcode) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('items')
        .where('barcode', isEqualTo: barcode)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 1) {
      DocumentSnapshot<Object?> document = documents.single;
      return new Item(
        category: document.get('category'),
        barcode: document.get('barcode'),
        name: document.get('name'),
        units: document.get('units'),
        uom: document.get('uom'),
        price: document.get('price'),
        rpu: document.get('rpu'),
      );
    }
    return null;
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
