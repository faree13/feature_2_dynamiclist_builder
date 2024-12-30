import 'package:flutter/material.dart';

class DynamicListBuilder extends StatefulWidget {
  @override
  _DynamicListBuilderState createState() => _DynamicListBuilderState();
}

class _DynamicListBuilderState extends State<DynamicListBuilder> {
  List<String> _items = []; // List to store dynamic items

  // Function to add a new item to the list
  void _addItem() {
    int newItemNumber = _getNextItemNumber(); // Get the next sequential number
    setState(() {
      _items.add('Item $newItemNumber'); // Add the new item
    });
    _showSnackBar('Item added'); // Show notification
  }

  // Function to get the next sequential item number
  int _getNextItemNumber() {
    if (_items.isEmpty) return 1; // Start at 1 if the list is empty
    // Extract the largest number from the current items
    List<int> currentNumbers = _items
        .map((item) => int.parse(item.split(' ')[1])) // Extract numbers
        .toList();
    return currentNumbers.reduce((a, b) => a > b ? a : b) + 1; // Max + 1
  }

  // Function to delete an item
  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index); // Remove the item
    });
    _showSnackBar('Item deleted'); // Show notification
  }

  // Function to edit the name of an item
  void _editItem(int index) {
    TextEditingController _controller =
        TextEditingController(text: _items[index]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Item'),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Enter new name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _items[index] = _controller.text; // Update the item name
              });
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  // Function to show SnackBar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Display duration
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Distinct background color
      appBar: AppBar(
        title: Text('Dynamic List Builder'),
      ),
      body: _items.isEmpty
          ? Center(
              child: Text(
                'No items in the list',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.withOpacity(0.6), // Light gray with opacity
                ),
              ),
            )
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return MouseRegion(
                  child: Container(
                    color: Colors.grey[100], // Light background color
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: ListTile(
                      title: Text(_items[index]),
                      onTap: () => _editItem(index), // Edit item name
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteItem(index), // Delete item
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem, // Add new item
        child: Icon(Icons.add),
        tooltip: 'Add Item',
      ),
    );
  }
}


