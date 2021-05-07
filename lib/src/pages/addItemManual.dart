import 'package:flutter/material.dart';

import '../widgets/header.dart';
import '../widgets/paragraph.dart';

class AddItemManualPage extends StatefulWidget {
  AddItemManualPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AddItemManualPageState createState() => _AddItemManualPageState();
}

class _AddItemManualPageState extends State<AddItemManualPage> {
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
            Header("Tell us about the item."),
            Paragraph("¥Editable table here¥"),
          ],
        ),
      ),
    );
  }
}
