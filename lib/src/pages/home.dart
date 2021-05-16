import 'dart:async';
import 'package:flutter/material.dart';

import '../widgets/header.dart';
import '../widgets/itemList.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {Key? key,
      required this.title,
      required this.items,
      required this.clearItems})
      : super(key: key);

  final String title;
  final List<Item> items;
  final FutureOr<void> Function() clearItems;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _showScanItemPage() {
    Navigator.of(context).pushNamed('/scan');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 16.0, height: 16.0),
            Header("Let's get the best deal!"),
            ItemList(items: widget.items, clearItems: widget.clearItems),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showScanItemPage,
        tooltip: 'Add Item',
        child: Icon(Icons.add),
      ),
    );
  }
}
