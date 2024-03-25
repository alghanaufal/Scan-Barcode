import 'dart:async';

import 'package:dynamsoft_capture_vision_flutter/dynamsoft_capture_vision_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:share_plus/share_plus.dart';

import 'scan_provider.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with WidgetsBindingObserver {
  late final DCVCameraEnhancer _cameraEnhancer;
  late final DCVBarcodeReader _barcodeReader;

  final DCVCameraView _cameraView = DCVCameraView();
  List<BarcodeResult> result = [];
  List<BarcodeResult> tempResult = [];
  List<BarcodeResult> saveResult = [];
  int dataCount = 0;

  bool _isFlashOn = false;
  bool _isScanning = true;
  bool _isCameraReady = false;
  late ScanProvider _scanProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _sdkInit();
  }

  Future<void> _sdkInit() async {
    _scanProvider = Provider.of<ScanProvider>(context, listen: false);

    _barcodeReader = await DCVBarcodeReader.createInstance();
    _cameraEnhancer = await DCVCameraEnhancer.createInstance();

    DBRRuntimeSettings currentSettings =
        await _barcodeReader.getRuntimeSettings();

    if (_scanProvider.types != 0) {
      currentSettings.barcodeFormatIds = _scanProvider.types;
    } else {
      currentSettings.barcodeFormatIds = EnumBarcodeFormat.BF_ALL;
    }

    currentSettings.expectedBarcodeCount = 0;

    await _barcodeReader
        .updateRuntimeSettingsFromTemplate(EnumDBRPresetTemplate.DEFAULT);
    await _barcodeReader.updateRuntimeSettings(currentSettings);

    _cameraView.overlayVisible = true;

    _cameraView.torchButton = TorchButton(
      visible: true,
    );

    await _barcodeReader.enableResultVerification(true);

    _barcodeReader.receiveResultStream().listen((List<BarcodeResult>? res) {
      if (mounted) {
        tempResult = res ?? [];
        String msg = '';
        for (var i = 0; i < tempResult.length; i++) {
          msg += '${tempResult[i].barcodeText}\n';

          if (_scanProvider.results.containsKey(tempResult[i].barcodeText)) {
            continue;
          } else {
            _scanProvider.results[tempResult[i].barcodeText] = tempResult[i];
          }
        }

        setState(() {});
      }
    });
    start();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraEnhancer.close();
    _barcodeReader.stopScanning();
    super.dispose();
  }

  Future<void> stop() async {
    await _cameraEnhancer.close();
    await _barcodeReader.stopScanning();
  }

  Future<void> start() async {
    _isCameraReady = true;
    setState(() {});

    Future.delayed(const Duration(milliseconds: 100), () async {
      _cameraView.overlayVisible = true;
      await _barcodeReader.startScanning();
      await _cameraEnhancer.open();
    });
  }

  Widget createURLString(String text) {
    // Create a regular expression to match URL strings.
    RegExp urlRegExp = RegExp(
      r'^(https?|http)://[^\s/$.?#].[^\s]*$',
      caseSensitive: false,
      multiLine: false,
    );

    if (urlRegExp.hasMatch(text)) {
      return InkWell(
        onLongPress: () {
          Share.share(text, subject: 'Scan Result');
        },
        child: Text(
          text,
          style: const TextStyle(color: Colors.blue),
        ),
        onTap: () async {
          launchUrlString(text);
        },
      );
    } else {
      return InkWell(
        onLongPress: () async {
          Share.share(text, subject: 'Scan Result');
        },
        child: Text(text),
      );
    }
  }

  Widget createSwitchWidget() {
    result = _scanProvider.results.values.toList();

    if (result.isEmpty) {
      result = tempResult;
    }
    if (!_isCameraReady) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                _cameraView,
                Positioned(
                  bottom: 16,
                  child: InkWell(
                    onTap: () {
                      if (_isScanning) {
                        _isScanning = false;
                        stop();
                        setState(() {});
                      } else {
                        _isScanning = true;
                        start();
                      }
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Icon(
                          _isScanning ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 16,
                  child: InkWell(
                    onTap: () {
                      if (_isFlashOn) {
                        _isFlashOn = false;
                        _cameraEnhancer.turnOffTorch();
                      } else {
                        _isFlashOn = true;
                        _cameraEnhancer.turnOnTorch();
                      }
                      setState(() {});
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Icon(
                          _isFlashOn ? Icons.flash_off : Icons.flash_on,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Card(
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Scanner (${result.length})",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  dataCount = 0;
                                  result.forEach((item) {
                                    if (!saveResult.contains(item)) {
                                      saveResult.add(item);
                                      dataCount++;
                                    }
                                  });
                                  // Memperbarui _scanProvider.results dengan data yang tersimpan
                                  saveResult.forEach((item) {
                                    _scanProvider.results
                                        .remove(item.barcodeText);
                                  });
                                  // Kosongkan result setelah disimpan di saveResult
                                  result.clear();
                                  // Kosongkan tempResult setelah disimpan di saveResult
                                  tempResult.clear();
                                  // Konfirmasi
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("$dataCount data saved."),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                });
                              },
                              icon: Icon(Icons.save),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  dataCount = 0;
                                  result.forEach((item) {
                                    if (!saveResult.contains(item)) {
                                      dataCount++;
                                    }
                                  });
                                  // Memperbarui _scanProvider.results dengan data yang tersimpan
                                  result.forEach((item) {
                                    _scanProvider.results
                                        .remove(item.barcodeText);
                                  });
                                  // Kosongkan result setelah disimpan di saveResult
                                  result.clear();
                                  // Kosongkan tempResult setelah disimpan di saveResult
                                  tempResult.clear();
                                  // Konfiramsi
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("$dataCount data removed."),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                });
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: ListView.separated(
                        itemCount: result.length,
                        separatorBuilder: (context, index) => Divider(),
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 2.0,
                            margin: EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 8.0,
                            ),
                            child: ListTile(
                              title: createURLString(
                                  result.elementAt(index).barcodeText),
                              subtitle: createURLString(
                                  result.elementAt(index).barcodeFormatString),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    // Hapus data di indeks saat ini dari result
                                    BarcodeResult removedData =
                                        result.elementAt(index);
                                    _scanProvider.results.removeWhere(
                                        (key, value) =>
                                            key == removedData.barcodeText);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Data dihapus: ${removedData.barcodeText} - ${removedData.barcodeFormatString}"),
                                      ),
                                    );
                                  });
                                },
                                child: Icon(Icons.delete),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner'),
      ),
      body: createSwitchWidget(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        start();
        break;
      case AppLifecycleState.inactive:
        stop();
        break;
      case AppLifecycleState.paused:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.detached:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        break;
    }
  }
}
