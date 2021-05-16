import 'dart:async';
import 'package:flutter/material.dart';

import '../widgets/itemForm.dart';
import '../widgets/itemList.dart' show Item;

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
