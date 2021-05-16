import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cheapee/src/widgets/paragraph.dart';
import 'package:cheapee/src/widgets/iconAndDetail.dart';
import 'package:cheapee/src/pages/itemDetails.dart'
    show ItemDetailsPageArguments;

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
  final double units;
  final String uom;
  final double price;
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
  List<DataRow> _getRows(items) {
    List<DataRow> rows = [];
    for (var item in items) {
      rows.add(new DataRow(
        cells: <DataCell>[
          DataCell(Text(item.name)),
          DataCell(Text(item.units.toString())),
          DataCell(Text(item.rpu)),
        ],
        onSelectChanged: (value) => {
          showDialog(
              context: context,
              builder: (_) => SimpleDialog(
                    title: const Text('Actions'),
                    children: <Widget>[
                      SimpleDialogOption(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/details',
                              arguments: ItemDetailsPageArguments(item, false));
                        },
                        child: const IconAndDetail(
                            Icons.info_outline, 'More information'),
                      ),
                      SimpleDialogOption(
                        onPressed: () async {
                          await widget.clearItems();
                          // TODO confirm this happens after the promise resolves
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Good choice! Whats next?'),
                            backgroundColor: Colors.indigo,
                          ));
                          Navigator.pop(context);
                        },
                        child: const IconAndDetail(
                            Icons.check_box, 'Choose this item'),
                      ),
                    ],
                  ))
        },
      ));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Paragraph(
            '${widget.items.length > 0 ? 'Looking at: ${widget.items[0].category}' : 'Add items by tapping the bottom button.'}'),
        if (widget.items.length > 0)
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
    );
  }
}
