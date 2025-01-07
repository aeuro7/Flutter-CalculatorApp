import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart'; // นำเข้า package expressions

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Padding(
          //   padding: const EdgeInsets.only(bottom: 0.0), 
          //   child: Text(title, style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
          // ),
          toolbarHeight: 50,
          flexibleSpace: Container(
          decoration: const BoxDecoration(
           gradient: LinearGradient(
               colors: [Color.fromARGB(255, 187, 187, 187), Color.fromARGB(0, 255, 255, 255)],
               begin: Alignment.topCenter,
                 end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),

      body: const Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final List<String> buttons = [
  'C', '()', '%', '÷',
  '1', '2', '3', 'x',
  '4', '5', '6', '-',
  '7', '8', '9', '+',
  'DE', '0', 'A', '='
];

  String input = '0';
  String lastInput = '';
  bool isThatfinished = false;

  void onButtonPressed(String buttonText) {
    setState(() {
      if (isThatfinished) {
        if (buttonText == 'C' || buttonText == 'DEL') {
          input = '0';
          lastInput = ''; 
          isThatfinished = false;
        } else if (RegExp(r'^[0-9]$').hasMatch(buttonText)) {
          input = buttonText;
          isThatfinished = false;
        } else if (['+', '-', 'x', '÷'].contains(buttonText)) {
          input += buttonText;
          isThatfinished = false;
        } else {
          return; 
        }
      } else {
        // กรณีทั่วไป
        if (buttonText == 'C') {
          input = '0';
          lastInput = '';
        } else if (buttonText == 'DEL') {
          if (input.length > 1) {
            input = input.substring(0, input.length - 1);
          } else {
            input = '0';
          }
        } else if (RegExp(r'^[0-9]$').hasMatch(buttonText)) {
          if (input == '0') {
            input = buttonText;
          } else {
            input += buttonText;
          }
        } else if (['+', '-', 'x', '÷'].contains(buttonText)) {
          // ตัวดำเนินการ
          if (input.isNotEmpty &&
              !['+', '-', 'x', '÷'].contains(input[input.length - 1])) {
            input += buttonText;
          }
        } else if (buttonText == '=') {
          // กดคำนวณผลลัพธ์
          try {
            final expression = Expression.parse(
              input
                  .replaceAll('x', '*')
                  .replaceAll('÷', '/'), 
            );
            final evaluator = ExpressionEvaluator();
            final result = evaluator.eval(expression, {}); // คำนวณผลลัพธ์
            lastInput = input;
            input = result.toString();
            isThatfinished = true;
          } catch (e) {
            input = 'Error';
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Column(
          children: [
            Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              margin: const EdgeInsets.fromLTRB(0, 80, 20, 0),
              alignment: Alignment.bottomRight,
              height: 50, // ปรับความสูงให้เหมาะสม
              child: Text(
                lastInput,
                style: const TextStyle(
                  fontSize: 40,
                  color: Color.fromARGB(255, 109, 109, 109),
                ),
              ),
            ),
            Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              margin: const EdgeInsets.fromLTRB(0, 0, 20, 20),
              alignment: Alignment.bottomRight,
              height: 80, // ปรับความสูงให้เหมาะสม
              child: Text(
                input,
                style: const TextStyle(
                  fontSize: 70,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        Expanded(
          flex: 2,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1,
            ),
            itemCount: buttons.length,
            padding: const EdgeInsets.all(10),
              physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return MyB(
                buttonText: buttons[index],
                onPressed: onButtonPressed,
              );
            },
          ),
        ),
      ],
    );
  }
}

class MyB extends StatelessWidget {
  final String buttonText;
  final Function(String) onPressed;

  const MyB({super.key, required this.buttonText, required this.onPressed});

  Color colorBT(String x) {
    var ls = ['x', '-', '+', '÷'];
    var ls2 = ['C','()','%',];
    if (ls.contains(x)) {
      return const Color.fromARGB(255, 40, 40, 40);
    }
    if (ls2.contains(x)) {
      return const Color.fromARGB(255, 206, 206, 206);
    }
    if (x == '=') {
      return const Color.fromARGB(255, 179, 24, 24);
    }
    return Colors.white;
  }

  Color colorT(String x) {
    var ls = ['x', '-', '+', '=', '÷'];
    if (ls.contains(x)) {
      return const Color.fromARGB(255, 255, 255, 255);
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: ElevatedButton(
        onPressed: () => onPressed(buttonText),
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(colorBT(buttonText)),
          elevation: MaterialStateProperty.all<double>(5),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 30,
            color: colorT(buttonText),
          ),
        ),
      ),
    );
  }
}
