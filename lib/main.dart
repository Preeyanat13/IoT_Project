import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HappyPlant',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final db = FirebaseDatabase.instance.ref("realtime");

  int soil = 0;
  int temp = 0;
  int humidity = 0;
  int light = 0;

  @override
  void initState() {
    super.initState();

    db.onValue.listen((event) {
      final data = event.snapshot.value as Map;

      setState(() {
        soil = data["soil"];
        temp = data["temp"];
        humidity = data["humidity"];
        light = data["light"];
      });
    });
  }

  Widget sensorCard(String title, int value) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 18)),
            Text(value.toString(),
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HappyPlant Dashboard 🌱"),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          sensorCard("Soil Moisture", soil),
          sensorCard("Temperature", temp),
          sensorCard("Humidity", humidity),
          sensorCard("Light", light),
        ],
      ),
    );
  }
}