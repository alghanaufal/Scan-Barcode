import 'dart:async';

import 'package:dynamsoft_capture_vision_flutter/dynamsoft_capture_vision_flutter.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/scan_provider.dart';
import '../utils/scanner_card.dart';

class ScannerScreen extends StatefulWidget {
  final String device_id;
  const ScannerScreen({
    Key? key,
    required this.device_id,
  }) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with WidgetsBindingObserver {
  late final DCVCameraEnhancer _cameraEnhancer;
  late final DCVBarcodeReader _barcodeReader;

  final DCVCameraView _cameraView = DCVCameraView();
  List<BarcodeResult> result = [];
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
        result = res ?? [];
        String msg = '';
        for (var i = 0; i < result.length; i++) {
          msg += '${result[i].barcodeText}\n';

          if (_scanProvider.results.containsKey(result[i].barcodeText)) {
            continue;
          } else {
            _scanProvider.results[result[i].barcodeText] = result[i];
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

  Widget createSwitchWidget() {
    result = _scanProvider.results.values.toList();

    if (!_isCameraReady) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              _cameraView,
              Positioned(
                  top: 42,
                  left: 0,
                  right: 0,
                  child: ScannerCard(
                    device_id: widget.device_id,
                    result: result,
                    scanProvider: _scanProvider,
                  )),
              Positioned(
                bottom: 24,
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_isScanning) {
                          _isScanning = false;
                          stop();
                          setState(() {});
                        } else {
                          _isScanning = true;
                          start();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 65),
                        backgroundColor: Colors.transparent,
                        side: BorderSide(color: Colors.white),
                      ),
                      child: Icon(
                        _isScanning ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (_isFlashOn) {
                          _isFlashOn = false;
                          _cameraEnhancer.turnOffTorch();
                        } else {
                          _isFlashOn = true;
                          _cameraEnhancer.turnOnTorch();
                        }
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 65),
                        backgroundColor: Colors.transparent,
                        side: BorderSide(color: Colors.white),
                      ),
                      child: Icon(
                        _isFlashOn ? Icons.flashlight_off : Icons.flashlight_on,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
