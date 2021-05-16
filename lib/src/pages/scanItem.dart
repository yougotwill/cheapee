import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

import '../widgets/header.dart';
import '../pages/addItem.dart' show AddItemPageArguments;

class ScanItemPage extends StatefulWidget {
  ScanItemPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ScanItemPageState createState() => _ScanItemPageState();
}

class _ScanItemPageState extends State<ScanItemPage> {
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
              onPressed: () async {
                var result = await BarcodeScanner.scan();
                if (result.type == ResultType.Cancelled ||
                    result.type == ResultType.Error ||
                    result.format == BarcodeFormat.unknown) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Scan failed. Please try again.'),
                    backgroundColor: Colors.red,
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Scan succeeded!'),
                    backgroundColor: Colors.indigo,
                  ));
                  Navigator.pushNamed(context, '/add',
                      arguments: AddItemPageArguments(result.rawContent));
                }
              },
              child: Text("Let's go!"),
            ),
            Header('Enter the barcode manually'),
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
