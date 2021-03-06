import 'dart:async';
import 'package:flutter/material.dart';

import '../widgets/itemForm.dart';
import '../widgets/itemList.dart' show Item;

class ItemDetailsPageArguments {
  final Item? item;
  final bool canEdit;
  ItemDetailsPageArguments(this.item, this.canEdit);
}

class ItemDetailsPage extends StatefulWidget {
  ItemDetailsPage({
    Key? key,
    required this.title,
    required this.saveItem,
    required this.isExistingItem,
  }) : super(key: key);

  final String title;
  final Future<void> Function(String category, String barcode, String name,
      String units, String uom, String price) saveItem;
  final Future<Item?> Function(String barcode) isExistingItem;

  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ItemDetailsPageArguments;
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
              item: args.item,
              canEdit: args.canEdit,
              barcode: null,
              isExistingItem: widget.isExistingItem,
            ),
          ],
        ),
      ),
    );
  }
}
