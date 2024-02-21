import 'package:flutter/material.dart';


class JsonList extends StatefulWidget {
  final String label;
  final List<dynamic> textFieldValues;
  final ValueChanged<List<dynamic>>? onChanged;
  final VoidCallback? onDeleteItem;

  JsonList({
    required this.label,
    required this.textFieldValues,
    this.onChanged,
    this.onDeleteItem
  });

  @override
  _JsonListState createState() => _JsonListState();
}

class _JsonListState extends State<JsonList> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.textFieldValues.length, (index) {
      return TextEditingController(text: widget.textFieldValues[index].toString());
    });


  }

  @override
  void didUpdateWidget(covariant JsonList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.textFieldValues != widget.textFieldValues) {
      for (int i = 0; i < _controllers.length; i++) {
        _controllers[i].text = widget.textFieldValues[i].toString();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if textFieldValues list is empty so that it gets removed from the json string
    if (widget.textFieldValues.isEmpty) {
      // Return SizedBox.shrink() to remove the widget from the UI
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label.toString(),
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        // TextFields
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(widget.textFieldValues.length, (index) {
            return Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: TextField(
                      controller: _controllers[index],
                      decoration: const InputDecoration(
                        hintText: 'Enter value',
                      ),
                      onChanged: (newValue) {
                        widget.onChanged?.call(_controllers.map((controller) => controller.text.toString()).toList());
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      widget.textFieldValues.removeAt(index);
                      _controllers.removeAt(index).dispose();
                      if (widget.onDeleteItem != null) {
                        widget.onDeleteItem!();
                      }
                    });
                  },
                ),
              ],
            );
          }),
        ),
        const SizedBox(height: 8.0),
        // Add Button
        ElevatedButton(
          onPressed: () {
            setState(() {
              widget.textFieldValues.add('');
              _controllers.add(TextEditingController());
            });
          },
          child: const Text('Add'),
        ),
      ],
    );
  }


}
