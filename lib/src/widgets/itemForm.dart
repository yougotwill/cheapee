import 'dart:async';
import 'package:flutter/material.dart';

import '../pages/itemDetails.dart' show ItemDetailsPageArguments;
import 'itemList.dart' show Item;

class ItemForm extends StatefulWidget {
  ItemForm({
    required this.saveItem,
    required this.item,
    required this.canEdit,
    required this.barcode,
    required this.isExistingItem,
  });
  final Future<void> Function(String category, String barcode, String name,
      String units, String uom, String price) saveItem;
  final Item? item;
  final bool canEdit;
  final String? barcode;
  final Future<Item?> Function(String barcode) isExistingItem;

  @override
  ItemFormState createState() {
    return ItemFormState();
  }
}

class ItemFormState extends State<ItemForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> categories = {
    'cheese': 'g',
    'eggs': 'ea',
    'milk': 'l',
    'meat': 'kg'
  };
  String categoryValue = '';

  Map<String, String> uoms = {
    'g': 'Grams',
    'ea': 'Each',
    'l': 'Litres',
    'kg': 'Kilograms'
  };
  String uomValue = '';

  final uomDropdownState = GlobalKey<FormFieldState>();
  final textBarcodeController = TextEditingController();
  final textNameController = TextEditingController();
  final textUnitsController = TextEditingController();
  final textPriceController = TextEditingController();

  void _initFormState(widget) {
    if (widget.barcode != null) {
      textBarcodeController.text = widget.barcode;
    } else {
      textBarcodeController.text = widget.item?.barcode ?? '';
    }
    categoryValue = this.widget.item?.category ?? 'cheese';
    uomValue = this.widget.item?.uom ?? 'g';
    textUnitsController.text = this.widget.item?.units ?? '';
    textNameController.text = this.widget.item?.name ?? '';
    textPriceController.text = this.widget.item?.price ?? '';
  }

  void _saveItem() async {
    await widget.saveItem(
      categoryValue,
      textBarcodeController.text,
      textNameController.text,
      textUnitsController.text,
      uomValue,
      textPriceController.text,
    );
    // TODO confirm this happens after the promise resolves
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Added Item'),
      backgroundColor: Colors.indigo,
    ));
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
  }

  void _cancelSave() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Update cancelled'),
      backgroundColor: Colors.indigo[200],
    ));
    Navigator.of(context).pop();
  }

  void _enabledEditing(ItemForm widget) async {
    Item? existingItem =
        await widget.isExistingItem(textBarcodeController.text);
    Navigator.of(context).pop();
    Navigator.pushNamed(context, '/details',
        arguments: ItemDetailsPageArguments(existingItem, true));
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Editing an existing item.'),
                Text("Update it's information?"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                _saveItem();
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                _cancelSave();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initFormState(this.widget);
  }

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
              enabled: widget.canEdit,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Cannot be empty';
                }
                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return 'Can only be numbers';
                }
                if (value.length != 13) {
                  return 'Must be 13 digits';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Category'),
              disabledHint: Text(categoryValue),
              items: categories.keys.map<DropdownMenuItem<String>>((key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text('${key[0].toUpperCase()}${key.substring(1)}'),
                  onTap: () => {
                    uomDropdownState.currentState!.didChange(categories[key])
                  },
                );
              }).toList(),
              onChanged: widget.canEdit
                  ? (String? value) async {
                      setState(() {
                        categoryValue = value!;
                      });
                    }
                  : null,
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
              enabled: widget.canEdit,
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
              enabled: widget.canEdit,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Cannot be empty';
                }
                if (!RegExp(r'^\d*\.?\d+$').hasMatch(value)) {
                  return 'Must be decimal';
                }
                if (double.parse(value) <= 0.0) {
                  return 'Cannot be 0 or negative';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'UoM'),
              key: uomDropdownState,
              disabledHint: Text(uomValue),
              items: categories.values.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(uoms[value]!),
                );
              }).toList(),
              onChanged: widget.canEdit
                  ? (String? value) async {
                      setState(() {
                        uomValue = value!;
                      });
                    }
                  : null,
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
              enabled: widget.canEdit,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Cannot be empty';
                }
                if (!RegExp(r'^(?!^0\.00$)(([1-9][\d]{0,6})|([0]))\.[\d]{2}$')
                    .hasMatch(value)) {
                  return 'Must be 2 decimal point number';
                }
                if (double.parse(value) < 0.0) {
                  return 'Cannot be negative';
                }
                return null;
              },
            ),
          ),
          SizedBox(width: 16.0, height: 16.0),
          if (widget.canEdit || widget.item == null)
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Item? existingItem =
                      await widget.isExistingItem(textBarcodeController.text);
                  if (existingItem != null) {
                    _showConfirmationDialog();
                  } else {
                    _saveItem();
                  }
                }
              },
              child: Text('Save'),
            ),
          if (!widget.canEdit)
            ElevatedButton(
              onPressed: () {
                _enabledEditing(widget);
              },
              child: Text('Edit'),
            ),
        ],
      ),
    );
  }
}
