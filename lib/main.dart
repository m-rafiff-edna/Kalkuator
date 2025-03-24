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
        '/profil': (context) => ProfilPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/riwayat') {
          final List<String> history = settings.arguments as List<String>;
          return MaterialPageRoute(
            builder: (context) {
              return RiwayatPage(history: history);
            },
          );
        }
        return null;
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
      // Ganti koma dengan titik untuk mendukung desimal
      expression = expression.replaceAll(',', '.');
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
            _buildButtonRow(['C', '=', '+', '⌫']),
            _buildButtonRow(['7', '8', '9', '÷']),
            _buildButtonRow(['4', '5', '6', '×']),
            _buildButtonRow(['1', '2', '3', '-']),
            _buildButtonRow(['0', ',']), // Tombol untuk desimal
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNavButton('Riwayat', '/riwayat', history),
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
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF00FFFF), // Set the button color to neon blue
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Set the border radius for rounded corners
        ),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30), // Adjust padding for better appearance
      ),
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
      child: Text(label, style: TextStyle(fontSize: 24, color: Colors.black)), // Set text color to black for contrast
    ),
  );
}

  Widget _buildNavButton(String label, String route, [List<String>? history]) {
    return ElevatedButton(
      onPressed: () {
        if (label == 'Riwayat' && history != null) {
          Navigator.pushNamed(context, route, arguments: history);
        } else {
          Navigator.pushNamed(context, route);
        }
      },
      child: Text(label),
    );
  }
}

class RiwayatPage extends StatelessWidget {
  final List<String> history;

  RiwayatPage({required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Riwayat')),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(history[index], style: TextStyle(fontSize: 18)),
          );
        },
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/Kawazaki.jpg'), // Ganti dengan path gambar profil Anda
            ),
            SizedBox(height: 20),
            Text('Muhammad Rafif Edna', style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text('XI RPL 2', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('24', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}