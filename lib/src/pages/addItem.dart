import 'dart:async';
import 'package:cheapee/src/widgets/itemList.dart' show Item;
import 'package:flutter/material.dart';

import '../widgets/header.dart';
import '../widgets/itemForm.dart';

class AddItemPageArguments {
  final String? barcode;
  AddItemPageArguments(this.barcode);
}

class AddItemPage extends StatefulWidget {
  AddItemPage(
      {Key? key,
      required this.title,
      required this.saveItem,
      required this.isExistingItem})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final Future<void> Function(String category, String barcode, String name,
      String units, String uom, String price) saveItem;
  final Future<Item?> Function(String barcode) isExistingItem;

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as AddItemPageArguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Header("Item Details"),
            ItemForm(
              saveItem: widget.saveItem,
              item: null,
              canEdit: true,
              barcode: args.barcode,
              isExistingItem: widget.isExistingItem,
            ),
          ],
        ),
      ),
    );
  }
}
