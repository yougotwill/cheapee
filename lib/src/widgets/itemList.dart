import 'dart:async';
import 'package:flutter/material.dart';

import '../pages/itemDetails.dart' show ItemDetailsPageArguments;
import 'paragraph.dart';
import 'iconAndDetail.dart';

class Item {
  Item(
      {required this.category,
      required this.barcode,
      required this.name,
      required this.units,
      required this.uom,
      required this.price,
      required this.rpu});
  final String category;
  final String barcode;
  final String name;
  final String units;
  final String uom;
  final String price;
  final String rpu;
}

class ItemList extends StatefulWidget {
  ItemList({required this.items, required this.clearItems});
  final List<Item> items;
  final FutureOr<void> Function() clearItems;

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  Future<void> _showActionsDialog(item) async {
    return showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              title: const Text('Item Actions'),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/details',
                        arguments: ItemDetailsPageArguments(item, false));
                  },
                  child:
                      const IconAndDetail(Icons.info_outline, 'View Details'),
                ),
                SimpleDialogOption(
                  onPressed: () async {
                    await widget.clearItems();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Good choice! Whats next?'),
                      backgroundColor: Colors.indigo,
                    ));
                    Navigator.pop(context);
                  },
                  child:
                      const IconAndDetail(Icons.check_box, 'Choose this item'),
                ),
              ],
            ));
  }

  List<DataRow> _getRows(items) {
    List<DataRow> rows = [];
    for (var item in items) {
      rows.add(new DataRow(
        cells: <DataCell>[
          DataCell(Text(item.name)),
          DataCell(Text(item.units)),
          DataCell(Text(item.rpu)),
        ],
        onSelectChanged: (value) => {_showActionsDialog(item)},
      ));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        if (widget.items.length > 0) ...[
          SizedBox(width: 16.0, height: 16.0),
          Paragraph(
              'You are shopping for: ${widget.items[0].category[0].toUpperCase()}${widget.items[0].category.substring(1)}'),
          DataTable(
            showCheckboxColumn: false,
            columns: const <DataColumn>[
              DataColumn(
                label: Flexible(
                    child: Text(
                  'Name',
                  style: TextStyle(fontStyle: FontStyle.italic),
                )),
              ),
              DataColumn(
                label: Flexible(
                    child: Text(
                  'Units',
                  style: TextStyle(fontStyle: FontStyle.italic),
                )),
              ),
              DataColumn(
                label: Flexible(
                    child: Text(
                  'R per UoM',
                  style: TextStyle(fontStyle: FontStyle.italic),
                )),
              ),
            ],
            rows: _getRows(widget.items),
          ),
        ],
        if (widget.items.length == 0) ...[
          SizedBox(width: 16.0, height: 16.0),
          Paragraph('Step 1: Add some items to Cheapee.'),
          Paragraph("Step 2: Check each item's details."),
          Paragraph('Step 3: Choose the best deal.'),
          Paragraph("Step 4: Profit"),
          SizedBox(width: 16.0, height: 16.0),
          Paragraph('Add items by tapping the plus button.'),
        ],
      ],
    );
  }
}
