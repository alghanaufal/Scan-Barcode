import 'package:dynamsoft_capture_vision_flutter/dynamsoft_capture_vision_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'scanner_screen.dart';
import 'scan_provider.dart';

void main() {
  // menginisiasi scan provider yang akan digunakan untu menyimpan hasil scan barcode
  runApp(
      // dibuat agar memuat beberapa provider ke dalam aplikasi
      ChangeNotifierProvider(
          create: (_) =>
              ScanProvider(), // membungkus scan provider dengan changenotifierprovider agar dapat di akses seluruh widget di dalam aplikasi dan memungkinkan pembaruan tampilan saat status berubah
          child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _initLicense();
  }

  Future<void> _initLicense() async {
    try {
      await DCVBarcodeReader.initLicense('DLS2(License)');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ScannerScreen(),
    );
  }
}
