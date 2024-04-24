import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:typed_data/typed_buffers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      theme: ThemeData(
        brightness: Brightness.light, // Set initial theme to light mode
        primarySwatch: Colors.red,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark, // Set dark theme
      ),
      home: const MyHomePage(title: 'Light Control System'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _toggleValue1 = false;
  bool _toggleValue2 = false;
  bool _toggleValue3 = false;
  bool _toggleValue4 = false;
  bool _isDarkMode = false;
  final topic = 'nishant/again';

  late MqttServerClient client;

  @override
  void initState() {
    super.initState();

    _connectToMqttServer();
  }

  void _connectToMqttServer() async {
    client = MqttServerClient('broker.emqx.io', 'rand');
    client.port = 1883;

    try {
      await client.connect();
      print('Connected to MQTT server');
    } catch (e) {
      print('Error connecting to MQTT server: $e');
    }
  }

  void _toggle1() {
    setState(() {
      _toggleValue1 = !_toggleValue1;
      if (_toggleValue1) {
        _sendMessage(topic, 'blue/on');
      } else {
        _sendMessage(topic, 'blue/off');
      }
    });
  }

  void _toggle2() {
    setState(() {
      _toggleValue2 = !_toggleValue2;
      if (_toggleValue2) {
        _sendMessage(topic, 'green/on');
      } else {
        _sendMessage(topic, 'green/off');
      }
    });
  }

  void _toggle3() {
    setState(() {
      _toggleValue3 = !_toggleValue3;
      if (_toggleValue3) {
        _sendMessage(topic, 'yellow/on');
      } else {
        _sendMessage(topic, 'yellow/off');
      }
    });
  }

  void _toggle4() {
    setState(() {
      _toggleValue4 = !_toggleValue4;
      if (_toggleValue4) {
        _sendMessage(topic, 'red/on');
      } else {
        _sendMessage(topic, 'red/off');
      }
    });
  }

  void _sendMessage(String topic, String message) {
    Uint8List data = Uint8List.fromList(message.codeUnits);
    Uint8Buffer dataBuffer = Uint8Buffer();
    dataBuffer.addAll(data);

    client.publishMessage(topic, MqttQos.exactlyOnce, dataBuffer);
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: _isDarkMode
          ? Colors.black
          : Colors.white, // Dynamically set background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue),
              ),
              child: Switch(
                value: _toggleValue1,
                onChanged: (value) {
                  _toggle1();
                },
                thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.blue; // Set blue color when toggle is on
                  }
                  return Color.fromARGB(
                      255, 159, 159, 159); // Set red color when toggle is off
                }),
                activeTrackColor: Colors.blue[100],
                activeColor: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green),
              ),
              child: Switch(
                value: _toggleValue2,
                onChanged: (value) {
                  _toggle2();
                },
                thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.green; // Set green color when toggle is on
                  }
                  return Color.fromARGB(255, 159, 159,
                      159); // Set yellow color when toggle is off
                }),
                activeTrackColor: Colors.green[100],
                activeColor: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.yellow),
              ),
              child: Switch(
                value: _toggleValue3,
                onChanged: (value) {
                  _toggle3();
                },
                thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.yellow; // Set yellow color when toggle is on
                  }
                  return Color.fromARGB(
                      255, 159, 159, 159); // Set green color when toggle is off
                }),
                activeTrackColor: Colors.yellow[100],
                activeColor: const Color.fromARGB(255, 248, 223, 0),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red),
              ),
              child: Switch(
                value: _toggleValue4,
                onChanged: (value) {
                  _toggle4();
                },
                thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.red; // Set red color when toggle is on
                  }
                  return Color.fromARGB(255, 159, 159, 159);
                }),
                activeTrackColor: Colors.red[100],
                activeColor: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleTheme,
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.resolveWith<Color>((states) {
                  return _isDarkMode
                      ? Colors.white
                      : Colors.black; // Set button color based on theme mode
                }),
                foregroundColor:
                    MaterialStateProperty.resolveWith<Color>((states) {
                  return _isDarkMode
                      ? Colors.black
                      : Colors.white; // Set text color based on theme mode
                }),
              ),
              child: Text(_isDarkMode ? 'Light Mode' : 'Dark Mode'),
            ),
          ],
        ),
      ),
    );
  }
}
