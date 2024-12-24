import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SelectableListViewExample(),
    );
  }
}

class SelectableListViewExample extends StatefulWidget {
  const SelectableListViewExample({super.key});

  @override
  _SelectableListViewExampleState createState() => _SelectableListViewExampleState();
}

class _SelectableListViewExampleState extends State<SelectableListViewExample> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _options = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];
  final List<bool> _selectedOptions = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Selectable ListView Example"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: _options.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_options[index]),
                            trailing: Checkbox(
                              value: _selectedOptions[index],
                              onChanged: (bool? value) {
                                setState(() {
                                  _selectedOptions[index] = value!;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Selected options',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  maxLines: 1,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: _getSelectedButtons(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Toggle all items
                setState(() {
                  bool allSelected = _selectedOptions.every((selected) => selected);
                  for (int i = 0; i < _selectedOptions.length; i++) {
                    _selectedOptions[i] = !allSelected;
                  }
                });
              },
              child: const Text("Toggle Select/Deselect All"),
            ),
          ],
        ),
      ),
    );
  }

  // Get buttons for selected options
  List<Widget> _getSelectedButtons() {
    List<Widget> selectedButtons = [];
    for (int i = 0; i < _selectedOptions.length; i++) {
      if (_selectedOptions[i]) {
        selectedButtons.add(
          Chip(
            label: Text(_options[i]),
            deleteIcon: const Icon(Icons.clear),
            onDeleted: () {
              setState(() {
                _selectedOptions[i] = false;
              });
            },
          ),
        );
      }
    }
    return selectedButtons;
  }
}
