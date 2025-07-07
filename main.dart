
import 'package:flutter/material.dart';

void main() {
  runApp(AviatorApp());
}

class AviatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aviator Predictor',
      theme: ThemeData.dark(),
      home: AviatorHomePage(),
    );
  }
}

class AviatorHomePage extends StatefulWidget {
  @override
  _AviatorHomePageState createState() => _AviatorHomePageState();
}

class _AviatorHomePageState extends State<AviatorHomePage> {
  final TextEditingController _controller = TextEditingController();
  List<int> _predictedRounds = [];

  List<int> predictHighMultiplierRounds(List<double> data, {double threshold = 2.0, int lookback = 10, int futureWindow = 3}) {
    List<int> predictions = [];
    for (int i = 0; i < data.length - lookback - futureWindow; i++) {
      List<double> recent = data.sublist(i, i + lookback);
      if (recent.every((val) => val < threshold)) {
        for (int j = 0; j < futureWindow; j++) {
          predictions.add(i + lookback + j);
        }
      }
    }
    return predictions.toSet().toList()..sort();
  }

  void _analyzeData() {
    try {
      List<double> values = _controller.text
          .split(',')
          .map((e) => double.parse(e.trim()))
          .toList();
      List<int> result = predictHighMultiplierRounds(values);
      setState(() {
        _predictedRounds = result;
      });
    } catch (e) {
      setState(() {
        _predictedRounds = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Aviator Predictor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Enter multipliers (comma-separated)',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _analyzeData,
              child: Text('Predict'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: _predictedRounds
                    .map((i) => ListTile(
                          title: Text('High multiplier likely at round index: $i'),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
