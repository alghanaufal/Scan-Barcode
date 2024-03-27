import 'package:dynamsoft_capture_vision_flutter/dynamsoft_capture_vision_flutter.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:scanbarcode/data_screen.dart';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'scanner_screen.dart';
import 'scan_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => ScanProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  final List<String> _titles = ['Scanner', 'Data'];
  String _udid = 'Unknown';

  @override
  void initState() {
    super.initState();
    iniDeviceId();
    _initLicense();
  }

  Future<void> _initLicense() async {
    try {
      await DCVBarcodeReader.initLicense('DLS2(License)');
    } catch (e) {
      print(e);
    }
  }

  Future<void> iniDeviceId() async {
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
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          IconButton(
            onPressed: () {
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
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          ScannerScreen(),
          DataScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
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
        ],
      ),
    );
  }
}
