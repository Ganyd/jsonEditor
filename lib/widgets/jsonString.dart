import 'package:flutter/material.dart';


class JsonString extends StatefulWidget {
  final String label;
  String value = '';
  final ValueChanged<String>? onChanged;

  JsonString({
    Key? key,
    required this.label,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  _JsonStringState createState() => _JsonStringState();
}
class _JsonStringState extends State<JsonString> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant JsonString oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Label
        Expanded(
          flex: 1,
          child: Text(
            widget.label.toString(),
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        const SizedBox(width: 8.0),
        // TextField
        Expanded(
          flex: 2,
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter value',
            ),
            onChanged: (newValue) {
              setState(() {
                widget.onChanged?.call(newValue);
              });
            },
          )
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}