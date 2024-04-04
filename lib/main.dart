import 'package:dynamsoft_capture_vision_flutter/dynamsoft_capture_vision_flutter.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:scanbarcode/pages/data_screen.dart';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/scanner_screen.dart';
import 'utils/scan_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => ScanProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  String _udid = 'Unknown';

  @override
  void initState() {
    super.initState();
    initDeviceId();
    _initLicense();
  }

  Future<void> _initLicense() async {
    try {
      await DCVBarcodeReader.initLicense(
          'DLS2eyJoYW5kc2hha2VDb2RlIjoiMTAyNjcyNjAxLVRYbE5iMkpwYkdWUWNtOXFYMlJpY2ciLCJtYWluU2VydmVyVVJMIjoiaHR0cHM6Ly9tZGxzLmR5bmFtc29mdG9ubGluZS5jb20iLCJvcmdhbml6YXRpb25JRCI6IjEwMjY3MjYwMSIsInN0YW5kYnlTZXJ2ZXJVUkwiOiJodHRwczovL3NkbHMuZHluYW1zb2Z0b25saW5lLmNvbSIsImNoZWNrQ29kZSI6LTEwNzgxODUzOTl9');
    } catch (e) {
      print(e);
    }
  }

  Future<void> initDeviceId() async {
    String udid;
    try {
      udid = await FlutterUdid.udid;
    } on PlatformException {
      udid = 'Failed to get Device Id.';
    }
    if (!mounted) return;
    setState(() {
      _udid = udid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          ScannerScreen(device_id: _udid),
          DataScreen(device_id: _udid),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  height: 200,
                  child: Center(
                    child: Text('ID : $_udid', textAlign: TextAlign.center),
                  ),
                );
              },
            );
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scanner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}
