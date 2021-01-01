import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'How good is your choccy milky mommers',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: MyHomePage(title: 'Choccy Milk Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double c = 0;
  double mF = 0;
  double vA = 0;
  double avaliability = 0;

  double finalCalc = 0;

  final _formKey = GlobalKey<FormState>();
  final _textKey =  TextEditingController();

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
            Text(
              'Chocolate Quality',
            ),
            Slider(
              value: c.toDouble(),
              min: 0,
              max: 10,
              divisions: 100,
              label: c.toStringAsFixed(1),
              onChanged: (double value) {
                setState(() {
                  c = value;
                });
              },
            ),
            Text(
              'Mouth Feel',
            ),
            Slider(
              value: mF.toDouble(),
              min: 0,
              max: 5,
              divisions: 100,
              label: mF.toStringAsFixed(1),
              onChanged: (double value) {
                setState(() {
                  mF = value;
                });
              },
            ),
            Text(
              'Visual Appeal',
            ),
            Slider(
              value: vA.toDouble(),
              min: 0,
              max: 5,
              divisions: 100,
              label: vA.toStringAsFixed(1),
              onChanged: (double value) {
                setState(() {
                  vA = value;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _textKey,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Price',
                    alignLabelWithHint: true,
                  ),
                  textAlign: TextAlign.center,
                  inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (String value) {
                    return value.isEmpty ? 'Please enter a price' : null;
                  },
                ),
              ),
            ),
            Text(
              'Avaliability',
            ),
            Slider(
              value: avaliability.toDouble(),
              min: 0,
              max: 10,
              divisions: 100,
              label: avaliability.toStringAsFixed(1),
              onChanged: (double value) {
                setState(() {
                  avaliability = value;
                });
              },
            ),
            RaisedButton(
              child: Text("Calculate the Choccy Factor"),
              color: Colors.brown[200],
              onPressed: () => {
                if (_formKey.currentState.validate())
                  {
                    setState(() {
                      finalCalc = _calculateChoccyFactor(
                          c, mF, vA, double.tryParse(_textKey.text) , avaliability);
                    })
                  }
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: Text(
                "${finalCalc.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 69),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  double _calculateChoccyFactor(
      double c, double mF, double vA, double price, double avaliability) {
    return c * (mF + vA) - math.exp(math.sqrt(price/avaliability));
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}
