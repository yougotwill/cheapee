import 'dart:async';
import 'package:flutter/material.dart';

import '../widgets/header.dart';
import '../widgets/itemForm.dart';

class AddItemPage extends StatefulWidget {
  AddItemPage({Key? key, required this.title, required this.saveItem})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final FutureOr<void> Function(String category, String barcode, String name,
      String units, String uom, String price) saveItem;

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  void _scanItem() {
    // use package here to scan and store barcode
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
            Header('Scan a barcode'),
            ElevatedButton(
              onPressed: _scanItem,
              child: Text("Let's go!"),
            ),
            Header("Item Details"),
            ItemForm(
              saveItem: widget.saveItem,
              item: null,
              canEdit: true,
            ),
          ],
        ),
      ),
    );
  }
}
