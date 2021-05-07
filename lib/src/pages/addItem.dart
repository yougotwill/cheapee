import 'package:flutter/material.dart';

import '../widgets/header.dart';
import '../widgets/paragraph.dart';

class AddItemPage extends StatefulWidget {
  AddItemPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  void _showAddItemManualPage() {
    Navigator.of(context).pushNamed('/add/manual');
  }

  void _showAddItemBarcodePage() {
    Navigator.of(context).pushNamed('/add/scan');
  }

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
            Header("Make a manual entry?"),
            ElevatedButton(
              onPressed: _showAddItemManualPage,
              child: Text("Let's go!"),
            ),
            Header('Scan a barcode'),
            ElevatedButton(
              onPressed: _showAddItemBarcodePage,
              child: Text("Let's go!"),
            ),
          ],
        ),
      ),
    );
  }
}
