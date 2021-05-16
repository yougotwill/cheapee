import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

import '../widgets/header.dart';
import '../widgets/paragraph.dart';
import '../pages/addItem.dart' show AddItemPageArguments;
import '../widgets/itemList.dart' show Item;
import '../pages/itemDetails.dart' show ItemDetailsPageArguments;

class ScanItemPage extends StatefulWidget {
  ScanItemPage({Key? key, required this.title, required this.isExistingItem})
      : super(key: key);

  final String title;
  final Future<Item?> Function(String barcode) isExistingItem;

  @override
  _ScanItemPageState createState() => _ScanItemPageState();
}

class _ScanItemPageState extends State<ScanItemPage> {
  @override
  Widget build(BuildContext context) {
    Future<void> _showConfirmationDialog(barcode, existingItem) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Warning'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text('Item has been scanned before.'),
                  Text("Update it's information?"),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/details',
                      arguments: ItemDetailsPageArguments(existingItem, true));
                },
              ),
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).popUntil(ModalRoute.withName('/'));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Scan cancelled.'),
                    backgroundColor: Colors.indigo[200],
                  ));
                },
              ),
            ],
          );
        },
      );
    }

    void _scanItem(ScanItemPage widget) async {
      var result = await BarcodeScanner.scan();
      switch (result.type) {
        case ResultType.Barcode:
          Item? existingItem = await widget.isExistingItem(result.rawContent);
          if (existingItem != null) {
            _showConfirmationDialog(result.rawContent, existingItem);
          } else {
            Navigator.pushNamed(context, '/add',
                arguments: AddItemPageArguments(result.rawContent));
          }
          break;
        case ResultType.Error:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Scan failed. Please try again.'),
            backgroundColor: Colors.red[100],
          ));
          break;
        case ResultType.Cancelled:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Scan cancelled.'),
            backgroundColor: Colors.indigo[200],
          ));
          break;
        default:
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 16.0, height: 16.0),
            Header('Barcode Scanner'),
            Paragraph("Use your camera!"),
            SizedBox(width: 8.0, height: 8.0),
            ElevatedButton(
              onPressed: () {
                _scanItem(widget);
              },
              child: Text("Let's go!"),
            ),
            SizedBox(width: 32.0, height: 32.0),
            Header('Manual Entry'),
            Paragraph("Manually enter the item's barcode."),
            SizedBox(width: 8.0, height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add',
                    arguments: AddItemPageArguments(null));
              },
              child: Text("Let's go!"),
            ),
          ],
        ),
      ),
    );
  }
}
