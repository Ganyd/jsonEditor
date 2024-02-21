import 'package:flutter/material.dart';
import 'package:untitled5/widgets/jsonBool.dart';
import 'package:untitled5/widgets/jsonInt.dart';
import 'dart:convert';
import 'package:untitled5/widgets/jsonString.dart';
import 'package:untitled5/widgets/jsonList.dart';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _textEditingController = TextEditingController();
  bool showAlert = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _textEditingController.addListener(_onTextChanged);
    _startTimer();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _startTimer() {
    // Activate the _showPopup function every 1 second using a Timer
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if(showAlert)_showPopup();
    });
  }

  void _onTextChanged() {
    setState(() {
      newRows.clear();
      String text = _textEditingController.text;
      _decodeJSON(text);
    });
  }
  void _showPopup() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('WARNING: the json string entered isn\'t in the correct format'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 16.0, right: 16.0),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }


  // this encodes the new values changed in text fields into a new json string
  void encodeJson(String key, String value, String newValue) {
    String oldJson = _textEditingController.text;

    int indexOfSubstring = oldJson.indexOf(value.toString(), oldJson.lastIndexOf(key));
    String newJson = oldJson.replaceRange(indexOfSubstring, indexOfSubstring + value.length , newValue.toString());

    // check if the new JSON string is different from the old one
    if (oldJson != newJson) {
      JsonEncoder encoder = const JsonEncoder.withIndent('    ');
      String prettyPrint = encoder.convert(jsonDecode(newJson));
      // split the string by newline character and add a newline at the end of each line
      List<String> lines = prettyPrint.split('\n');
      prettyPrint = lines.map((line) => '$line\n').join();
      _textEditingController.text = prettyPrint;
      _onTextChanged();
    }
  }


  List<Padding> newRows = [];
  // decodes the json string into suitable widgets
  void _decodeJSON(String jsonString) {
    try {
        showAlert = false;
        Map<String,dynamic> json = jsonDecode(jsonString);
        json.forEach((key, value) {
          var type = value.runtimeType;
          if(type.toString() == 'String') {
            newRows.add(
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: JsonString(
                  label: key.toString(),
                  value: value.toString(),
                  onChanged: (newValue) {
                    setState(() {
                      json[key] = newValue.toString();
                      String newJson = jsonEncode(json);
                      _textEditingController.text = newJson;
                    });
                  },
                ),
              ),
            );
          }
          else if(type.toString() == 'bool') {
            newRows.add(
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: JsonBool(
                  label: key.toString(),
                  value: value,
                  onChanged: (newValue) {
                    setState(() {
                      json[key] = newValue;
                      String newJson = jsonEncode(json);
                      _textEditingController.text = newJson;
                    });
                  },
                ),
              ),
            );
          }
          else if(type.toString() == 'int') {

            newRows.add(
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: JsonInt(
                  label: key.toString(),
                  value: value,
                  onChanged: (newValue) {
                    setState(() {
                      json[key] = newValue;
                      String newJson = jsonEncode(json);
                      _textEditingController.text = newJson;
                    });
                  },
                ),
              ),
            );
          }
          else if(type.toString() == 'List<dynamic>'){
            newRows.add(
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: JsonList(
                  label: key.toString(),
                  textFieldValues: value,
                  onChanged: (newValue){
                    setState(() {
                      json[key] = newValue;
                      String newJson = jsonEncode(json);
                      _textEditingController.text = newJson;
                    });

                  },
                    onDeleteItem: () {
                      setState(() {
                        String newJson = jsonEncode(json);
                        _textEditingController.text = newJson;
                      });
                    }
                ),
              ),
            );
          }
          else if(type.toString() == '_Map<String, dynamic>'){
            newRows.add(
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Text(
                      key.toString(),
                      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            );
            value.forEach((k, v) {
              var t = v.runtimeType;
              if(t.toString() == 'String') {
                newRows.add(
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: JsonString(
                      label: k.toString(),
                      value: v.toString(),
                      onChanged: (newValue) {
                        setState(() {
                          json[key][k] = newValue.toString();
                          String newJson = jsonEncode(json);
                          _textEditingController.text = newJson;
                        });
                      },
                    ),
                  ),
                );
              }else if(t.toString() == 'bool'){
                newRows.add(
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: JsonBool(
                      label: k.toString(),
                      value: v,
                      onChanged: (newValue) {
                        setState(() {
                          json[key][k] = newValue;
                          String newJson = jsonEncode(json);
                          _textEditingController.text = newJson;
                        });
                      },
                    ),
                  ),
                );
              }else if(type.toString() == 'int'){
                newRows.add(
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: JsonInt(
                      label: k.toString(),
                      value: v,
                      onChanged: (newValue) {
                        setState(() {
                          json[key][k] = newValue;
                          String newJson = jsonEncode(json);
                          _textEditingController.text = newJson;
                        });
                      },
                    ),
                  ),
                );
              }else if(type.toString() == 'List<dynamic>'){
                newRows.add(
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: JsonList(
                        label: k.toString(),
                        textFieldValues: v,
                        onChanged: (newValue){
                          setState(() {
                            json[key][k] = newValue;
                            String newJson = jsonEncode(json);
                            _textEditingController.text = newJson;
                          });
                        },
                        onDeleteItem: () {
                          setState(() {
                            String newJson = jsonEncode(json);
                            _textEditingController.text = newJson;
                          });
                        }
                    ),
                  ),
                );
              }
              else{
                print(type.toString());
              }

              json.forEach((key, value) {
                if (value is List && value.isEmpty) {
                  json.remove(key);
                  String newJson = jsonEncode(json);
                  _textEditingController.text = newJson;
                }
              });
            });
          }
          else{
            print(type.toString());
          }

          //make sure that there are no empty lists within the json string
          json.forEach((key, value) {
            if (value is List && value.isEmpty) {
              json.remove(key);
              String newJson = jsonEncode(json);
              _textEditingController.text = newJson;
            }
          });
        });
    } catch (e) {
      showAlert = true;
      print('Error decoding JSON: $e');
    }
    return;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.shadow,
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.grey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _textEditingController,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.black87,
                                hintText: 'Enter JSON script...',
                              ),
                              expands: true,
                              maxLines: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            children: newRows,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey,
    );
  }
}
