import 'package:dynamsoft_capture_vision_flutter/dynamsoft_capture_vision_flutter.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:scanbarcode/pages/data_screen.dart';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/scanner_screen.dart';
import 'utils/scan_provider.dart';
import 'utils/theme.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UiProvider()),
    ChangeNotifierProvider(create: (_) => ScanProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);
    final theme =
        uiProvider.isDark ? uiProvider.darkTheme : uiProvider.lightTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const MyHomePage(),
    );
  }
}

class ThemeBuilder {}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  String _udid = 'Unknown';
  bool light = false;
  late UiProvider _uiProvider;

  @override
  void initState() {
    super.initState();
    initDeviceId();
    _initLicense();
    _uiProvider = Provider.of<UiProvider>(context, listen: false);
    _uiProvider.init();
  }

  Future<void> _initLicense() async {
    try {
      await DCVBarcodeReader.initLicense('DLS2(License)');
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
        selectedItemColor: Color.fromRGBO(30, 76, 160, 1.0),
        onTap: (index) {
          if (index == 2) {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Setting',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1,
                        child: Container(color: Colors.grey[400]),
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: _udid));
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Teks berhasil disalin'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(35, 155, 219, 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: DottedBorder(
                            padding: EdgeInsets.all(16.0),
                            borderType: BorderType.RRect,
                            radius: Radius.circular(8.0),
                            dashPattern: [6, 3],
                            strokeWidth: 2,
                            color: Color.fromRGBO(30, 76, 160, 1.0),
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.copy,
                                    color: Color.fromRGBO(30, 76, 160, 1.0),
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    'ID : $_udid',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color:
                                            Color.fromRGBO(30, 76, 160, 1.0)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.dark_mode),
                        title: Text('Dark Mode'),
                        trailing: Switch(
                          value: _uiProvider
                              .isDark, // Use UiProvider to get current dark mode state
                          onChanged: (bool value) {
                            setState(() {
                              light = value;
                            });
                            // Call changeTheme() from UiProvider to change theme
                            _uiProvider.changeTheme();
                          },
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.code),
                        title: Text('GoCloud & ETTER'),
                      )
                    ]);
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
