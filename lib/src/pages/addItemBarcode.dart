import 'package:flutter/material.dart';

import '../widgets/header.dart';
import '../widgets/paragraph.dart';

class AddItemBarcodePage extends StatefulWidget {
  AddItemBarcodePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AddItemBarcodePageState createState() => _AddItemBarcodePageState();
}

class _AddItemBarcodePageState extends State<AddItemBarcodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Header("Let's scan the item."),
            Paragraph("¥Camera scanner here.¥"),
          ],
        ),
      ),
    );
  }
}
