import 'dart:convert';
import 'package:dynamsoft_capture_vision_flutter/dynamsoft_capture_vision_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_udid/flutter_udid.dart';

import 'barcode_utils.dart';
import 'scan_provider.dart';
import 'config.dart';
import 'restapi.dart';

class ScannerCard extends StatefulWidget {
  final List<BarcodeResult> result;
  final List<BarcodeResult> tempResult;
  final List<BarcodeResult> saveResult;
  final ScanProvider scanProvider;

  const ScannerCard({
    Key? key,
    required this.result,
    required this.tempResult,
    required this.saveResult,
    required this.scanProvider,
  }) : super(key: key);

  @override
  _ScannerCardState createState() => _ScannerCardState();
}

class _ScannerCardState extends State<ScannerCard> {
  int dataCount = 0;
  String device_id = 'Unknown';
  String code = '';
  String format = '';
  String created_date = '';
  String created_month = '';
  String created_month_name = '';
  String created_year = '';

  @override
  void initState() {
    super.initState();
    iniDeviceId();

    // Set the current date
    DateTime now = DateTime.now();
    created_date = now.day.toString();
    created_month = now.month.toString();
    created_month_name = _getMonthName(now.month);
    created_year = now.year.toString();
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'JAN';
      case 2:
        return 'FEB';
      case 3:
        return 'MAR';
      case 4:
        return 'APR';
      case 5:
        return 'MAY';
      case 6:
        return 'JUN';
      case 7:
        return 'JUL';
      case 8:
        return 'AUG';
      case 9:
        return 'SEP';
      case 10:
        return 'OCT';
      case 11:
        return 'NOV';
      case 12:
        return 'DEC';
      default:
        return '';
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
      device_id = udid;
    });
  }

  DataService ds = DataService();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Scanner (${widget.result.length})",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        setState(() async {
                          // Initialize a list to hold the results to be saved
                          List<Map<String, dynamic>> resultsToSave = [];

                          // Iterate through each item in widget.result
                          widget.result.forEach((item) {
                            // Prepare a map containing attributes for insertion
                            Map<String, dynamic> resultAttributes = {
                              'appid': appid,
                              'device_id': device_id,
                              'code': item
                                  .barcodeText, // Using barcode text as code
                              'format': item.barcodeFormatString,
                              'created_date': created_date,
                              'created_month': created_month,
                              'created_month_name': created_month_name,
                              'created_year': created_year
                            };
                            // Add the map to the list of results to be saved
                            resultsToSave.add(resultAttributes);
                            widget.scanProvider.results
                                .remove(item.barcodeText);
                          });

                          // Insert each result using the DataService
                          List res = await Future.wait(
                              resultsToSave.map((result) async {
                            // Insert the result and decode the response
                            return jsonDecode(await ds.insertScanned(
                                result['appid'],
                                result['device_id'],
                                result['code'],
                                result['format'],
                                result['created_date'],
                                result['created_month'],
                                result['created_month_name'],
                                result['created_year']));
                          }));

                          // Update dataCount with the number of saved results
                          dataCount = res.length;

                          // Remove saved results from widget.result and add them to widget.saveResult
                          widget.result.removeWhere((item) =>
                              res.any((r) => r['code'] == item.barcodeText));
                          widget.saveResult.addAll(widget.result);

                          // Clear widget.result and widget.tempResult
                          widget.result.clear();
                          widget.tempResult.clear();

                          // Show a SnackBar to confirm the number of saved results
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
                          widget.result.forEach((item) {
                            if (!widget.saveResult.contains(item)) {
                              dataCount++;
                            }
                          });
                          // Memperbarui _scanProvider.results dengan data yang tersimpan
                          widget.result.forEach((item) {
                            widget.scanProvider.results
                                .remove(item.barcodeText);
                          });
                          // Kosongkan result setelah disimpan di saveResult
                          widget.result.clear();
                          // Kosongkan tempResult setelah disimpan di saveResult
                          widget.tempResult.clear();
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
                itemCount: widget.result.length,
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
                          widget.result.elementAt(index).barcodeText),
                      subtitle: createURLString(
                          widget.result.elementAt(index).barcodeFormatString),
                      trailing: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // Hapus data di indeks saat ini dari result
                            BarcodeResult removedData =
                                widget.result.elementAt(index);
                            widget.scanProvider.results.removeWhere(
                                (key, value) => key == removedData.barcodeText);
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
    );
  }
}
