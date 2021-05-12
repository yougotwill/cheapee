import 'package:flutter/material.dart';
import 'package:cheapee/src/widgets/paragraph.dart';
import 'package:cheapee/src/widgets/iconAndDetail.dart';

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
  ItemList({required this.items});
  final List<Item> items;

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
          DataCell(Text(item.units)),
          DataCell(Text(item.rpu)),
        ],
        onSelectChanged: (value) => {
          showDialog(
              context: context,
              builder: (_) => SimpleDialog(
                    title: const Text('Item Actions'),
                    children: <Widget>[
                      SimpleDialogOption(
                        onPressed: () {
                          // TODO go to item details
                        },
                        child: const IconAndDetail(
                            Icons.info_outline, 'Item details'),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          // Clear list of items
                        },
                        child:
                            const IconAndDetail(Icons.check_box, 'Select Item'),
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