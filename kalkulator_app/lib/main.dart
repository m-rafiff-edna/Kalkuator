import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/riwayat': (context) => RiwayatPage(),
        '/profil': (context) => ProfilPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String input = '';
  List<String> history = [];

  // Tambahkan karakter ke dalam input
  void appendInput(String value) {
    setState(() {
      input += value;
    });
  }

  // Hapus seluruh input
  void clearInput() {
    setState(() {
      input = '';
    });
  }

  // Hapus satu karakter terakhir
  void deleteLastInput() {
    setState(() {
      if (input.isNotEmpty) {
        input = input.substring(0, input.length - 1);
      }
    });
  }

  // Hitung hasil ekspresi matematika
  void calculateResult() {
    try {
      final result = _evaluateExpression(input);
      setState(() {
        history.add('$input = $result');
        input = result.toString();
      });
    } catch (e) {
      setState(() {
        input = 'Error';
      });
    }
  }

  // Evaluasi ekspresi menggunakan math_expressions
  double _evaluateExpression(String expression) {
    try {
      expression = expression.replaceAll('×', '*').replaceAll('÷', '/');
      Parser parser = Parser();
      Expression exp = parser.parse(expression);
      ContextModel cm = ContextModel();
      return exp.evaluate(EvaluationType.REAL, cm);
    } catch (e) {
      throw Exception("Invalid operation");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kalkulator')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: BoxConstraints(minHeight: 50, minWidth: 300, maxHeight: 80, maxWidth: 400),
              child: Text(
                input,
                style: TextStyle(fontSize: 32),
              ),
            ),
            SizedBox(height: 20),
            _buildButtonRow(['7', '8', '9', '÷']),
            _buildButtonRow(['4', '5', '6', '×']),
            _buildButtonRow(['1', '2', '3', '-']),
            _buildButtonRow(['0', '⌫', 'C', '=']),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNavButton('Riwayat', '/riwayat'),
                SizedBox(width: 10),
                _buildNavButton('Profil', '/profil'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonRow(List<String> labels) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: labels.map((label) => _buildButton(label)).toList(),
    );
  }

  Widget _buildButton(String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          if (label == 'C') {
            clearInput();
          } else if (label == '⌫') {
            deleteLastInput();
          } else if (label == '=') {
            calculateResult();
          } else {
            appendInput(label);
          }
        },
        child: Text(label, style: TextStyle(fontSize: 24)),
      ),
    );
  }

  Widget _buildNavButton(String label, String route) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      child: Text(label),
    );
  }
}

class RiwayatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Riwayat')),
      body: Center(
        child: Text('Riwayat Kalkulasi', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class ProfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profil')),
      body: Center(
        child: Text('Profil Pengguna', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

