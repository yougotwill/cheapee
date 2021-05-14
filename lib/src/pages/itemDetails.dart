import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cheapee/src/widgets/itemList.dart' show Item;

import '../widgets/itemForm.dart';

class ItemDetailsPageArguments {
  final Item item;
  final bool canEdit;
  ItemDetailsPageArguments(this.item, this.canEdit);
}

class ItemDetailsPage extends StatefulWidget {
  ItemDetailsPage({
    Key? key,
    required this.title,
    required this.saveItem,
  }) : super(key: key);

  final String title;
  final FutureOr<void> Function(String category, String barcode, String name,
      String units, String uom, String price) saveItem;

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
            ),
          ],
        ),
      ),
    );
  }
}
