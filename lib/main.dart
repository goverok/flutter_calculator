import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(Calculator());
}

class Calculator extends StatelessWidget {
  const Calculator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SimpleCalculator(),
    );
  }
}

class SimpleCalculator extends StatefulWidget {
  SimpleCalculator({Key key}) : super(key: key);

  @override
  _SimpleCalculatorState createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  String equation = "0", result = "0", expression = "";
  double equationFontSize = 38.0, resultFontSize = 48.0;

  _buttonPressed(String btnText) {
    setState(() {
      if (btnText == "C") {
        equation = "0";
        result = "0";
        equationFontSize = 38.0;
        resultFontSize = 48.0;
      } else if (btnText == "⌫") {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        equation = equation.substring(0, equation.length - 1);
        if (equation == "") {
          equation = "0";
        }
      } else if (btnText == "=") {
        equationFontSize = 38.0;
        resultFontSize = 48.0;

        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');

        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
        } catch (e) {
          result = "Error";
        }
      } else {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        if (equation == "0") {
          equation = btnText;
        } else {
          if ((equation[equation.length-1] == '×' || equation[equation.length-1] == '÷'
              || equation[equation.length-1] == '-' || equation[equation.length-1] == '+')
              && (btnText == '×' || btnText == '÷' || btnText == '-' || btnText == "+")) {
            equation = equation.substring(0, equation.length - 1) + btnText;
            return;
          }

          equation = equation + btnText;
        }
      }
    });
  }

  Widget _buildBtn(String btnText, double btnHeight, Color btnColor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * btnHeight,
      color: btnColor,
      child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
              side: BorderSide(
                  color: Colors.white, width: 1, style: BorderStyle.solid)),
          padding: EdgeInsets.all(16.0),
          onPressed: () => _buttonPressed(btnText),
          child: Text(
            btnText,
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.normal,
                color: Colors.white),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simple Calculator')),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Text(
              equation,
              style: TextStyle(fontSize: equationFontSize),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Text(
              result,
              style: TextStyle(fontSize: resultFontSize),
            ),
          ),
          Expanded(
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Table(
                  children: [
                    TableRow(children: [
                      _buildBtn("C", 1, Colors.redAccent),
                      _buildBtn("⌫", 1, Colors.blue),
                      _buildBtn("÷", 1, Colors.blue),
                    ]),
                    TableRow(children: [
                      _buildBtn("7", 1, Colors.black54),
                      _buildBtn("8", 1, Colors.black54),
                      _buildBtn("9", 1, Colors.black54),
                    ]),
                    TableRow(children: [
                      _buildBtn("4", 1, Colors.black54),
                      _buildBtn("5", 1, Colors.black54),
                      _buildBtn("6", 1, Colors.black54),
                    ]),
                    TableRow(children: [
                      _buildBtn("1", 1, Colors.black54),
                      _buildBtn("2", 1, Colors.black54),
                      _buildBtn("3", 1, Colors.black54),
                    ]),
                    TableRow(children: [
                      _buildBtn(".", 1, Colors.black54),
                      _buildBtn("0", 1, Colors.black54),
                      _buildBtn("00", 1, Colors.black54),
                    ]),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Table(
                  children: [
                    TableRow(children: [
                      _buildBtn("×", 1, Colors.blue),
                    ]),
                    TableRow(children: [
                      _buildBtn("-", 1, Colors.blue),
                    ]),
                    TableRow(children: [
                      _buildBtn("+", 1, Colors.blue),
                    ]),
                    TableRow(children: [
                      _buildBtn("=", 2, Colors.redAccent),
                    ]),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
