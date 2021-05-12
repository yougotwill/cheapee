import 'dart:async';
import 'package:flutter/material.dart';

class ItemForm extends StatefulWidget {
  ItemForm({required this.saveItem});
  final FutureOr<void> Function(String category, String barcode, String name,
      String units, String uom, String price) saveItem;

  @override
  ItemFormState createState() {
    return ItemFormState();
  }
}

class ItemFormState extends State<ItemForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String categoryValue = 'cheese';
  String uomValue = 'g';

  // TODO make map of <category, uom> which will change
  // the default value of uom on category value changing

  final textBarcodeController = TextEditingController();
  final textNameController = TextEditingController();
  final textUnitsController = TextEditingController();
  final textPriceController = TextEditingController();

  @override
  void dispose() {
    textBarcodeController.dispose();
    textNameController.dispose();
    textUnitsController.dispose();
    textPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: textBarcodeController,
              decoration: InputDecoration(labelText: 'Barcode'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Cannot be empty';
                }
                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return 'Only digits are valid';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Category'),
              // TODO can build items with map https://api.flutter.dev/flutter/material/DropdownButton-class.html
              items: [
                DropdownMenuItem<String>(
                  value: 'cheese',
                  child: Text('Cheese'),
                ),
                DropdownMenuItem<String>(
                  value: 'eggs',
                  child: Text('Eggs'),
                ),
                DropdownMenuItem<String>(
                  value: 'milk',
                  child: Text('Milk'),
                ),
                DropdownMenuItem<String>(
                  value: 'meat',
                  child: Text('Meat'),
                ),
              ],
              onChanged: (String? value) async {
                setState(() {
                  categoryValue = value!;
                });
              },
              value: categoryValue,
              validator: (value) =>
                  value == null ? 'Please choose a category' : null,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: textNameController,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Cannot be empty';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: textUnitsController,
              decoration: InputDecoration(labelText: 'Units'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Cannot be empty';
                }
                if (!RegExp(r'^\d*\.?\d+$').hasMatch(value)) {
                  return 'Only decimals are valid';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'UoM'),
              // TODO can build items with map https://api.flutter.dev/flutter/material/DropdownButton-class.html
              items: [
                DropdownMenuItem<String>(
                  value: 'g',
                  child: Text('gram'),
                ),
                DropdownMenuItem<String>(
                  value: 'kg',
                  child: Text('kilogram'),
                ),
                DropdownMenuItem<String>(
                  value: 'l',
                  child: Text('litre'),
                ),
                DropdownMenuItem<String>(
                  value: 'ea',
                  child: Text('each'),
                ),
              ],
              onChanged: (String? value) async {
                setState(() {
                  uomValue = value!;
                });
              },
              value: uomValue,
              validator: (value) =>
                  value == null ? 'Please choose a unit of measurement' : null,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: textPriceController,
              decoration: InputDecoration(labelText: 'Price'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Cannot be empty';
                }
                if (!RegExp(r'^\d*\.?\d+$').hasMatch(value)) {
                  return 'Only decimals are valid';
                }
                return null;
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await widget.saveItem(
                    categoryValue,
                    textBarcodeController.text,
                    textNameController.text,
                    textUnitsController.text,
                    uomValue,
                    textPriceController.text);
                // TODO confirm this happens after the promise resolves
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Item added'),
                  backgroundColor: Colors.indigo,
                ));
                Navigator.pop(context);
              }
            },
            child: Text('Save Item'),
          ),
        ],
      ),
    );
  }
}
