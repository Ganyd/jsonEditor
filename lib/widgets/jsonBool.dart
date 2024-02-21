import 'package:flutter/material.dart';

class JsonBool extends StatefulWidget {
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const JsonBool({
    Key? key,
    required this.label,
    this.value = false,
    this.onChanged,
  }) : super(key: key);

  @override
  _JsonBoolState createState() => _JsonBoolState();
}

class _JsonBoolState extends State<JsonBool> {
  late bool _isChecked;
  @override
  void initState() {
    super.initState();
    _isChecked = widget.value;
  }

  //this function makes sure that the widget is updated
  @override
  void didUpdateWidget(covariant JsonBool oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _isChecked = widget.value;
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
            widget.label,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        SizedBox(width: 8.0),
        // Checkbox
        Checkbox(
          value: _isChecked,
          onChanged: (newValue) {
            setState(() {
              _isChecked = newValue!;
              if (widget.onChanged != null) {
                widget.onChanged!(newValue!);
              }
            });
          },
        ),
      ],
    );
  }
}
