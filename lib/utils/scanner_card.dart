import 'dart:convert';
import 'package:dynamsoft_capture_vision_flutter/dynamsoft_capture_vision_flutter.dart';
import 'package:flutter/material.dart';

import 'barcode_utils.dart';
import 'scan_provider.dart';
import '../config/config.dart';
import '../config/restapi.dart';

class ScannerCard extends StatefulWidget {
  final String device_id;
  final List<BarcodeResult> result;
  final ScanProvider scanProvider;

  const ScannerCard({
    Key? key,
    required this.device_id,
    required this.result,
    required this.scanProvider,
  }) : super(key: key);

  @override
  _ScannerCardState createState() => _ScannerCardState();
}

class _ScannerCardState extends State<ScannerCard> {
  int dataCount = 0;
  String code = '';
  String format = '';
  String created_date = '';
  String created_month = '';
  String created_month_name = '';
  String created_year = '';

  @override
  void initState() {
    super.initState();

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
                  "Scanner (${widget.result.length}- ${widget.device_id})",
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
                          List<Map<String, dynamic>> resultsToSave = [];
                          // lakukan looping untuk widget.result
                          widget.result.forEach((item) {
                            // siapkan map berisi atribut untuk dimasukkan
                            Map<String, dynamic> resultAttributes = {
                              'appid': appid,
                              'device_id': widget.device_id,
                              'code': item.barcodeText,
                              'format': item.barcodeFormatString,
                              'created_date': created_date,
                              'created_month': created_month,
                              'created_month_name': created_month_name,
                              'created_year': created_year
                            };
                            // tambahkan map to the list results untuk di save
                            resultsToSave.add(resultAttributes);
                            widget.scanProvider.results
                                .remove(item.barcodeText);
                          });

                          // Insert seluruh result menggunakan DataService
                          List res = await Future.wait(
                              resultsToSave.map((result) async {
                            // Insert result dan decode ke response
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

                          widget.result.removeWhere((item) =>
                              res.any((r) => r['code'] == item.barcodeText));

                          widget.result.clear();

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
                            dataCount++;
                          });
                          // Memperbarui _scanProvider.results dengan data yang tersimpan
                          widget.result.forEach((item) {
                            widget.scanProvider.results
                                .remove(item.barcodeText);
                          });
                          // Kosongkan result setelah disimpan di saveResult
                          widget.result.clear();
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
