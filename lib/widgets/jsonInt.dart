import 'package:flutter/material.dart';

class JsonInt extends StatefulWidget {
  final String label;
  final int value;
  final ValueChanged<int> ? onChanged;

  const JsonInt({
    Key? key,
    required this.label,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  _JsonIntState createState() => _JsonIntState();
}

class _JsonIntState extends State<JsonInt> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
      super.initState();
      _controller.text = widget.value.toString();
  }

  //this function makes sure that the widget is updated
  @override
  void didUpdateWidget(covariant JsonInt oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value.toString();
    }
  }

  void _showPopup() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('WARNING: you cant enter a string in a number textfield'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 16.0, right: 16.0),
          duration: Duration(seconds: 1),
        ),
      );
    });
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
                try{
                  widget.onChanged?.call(int.parse(newValue));
                }catch($e){
                  _showPopup();
                }

              });
            },
          ),
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