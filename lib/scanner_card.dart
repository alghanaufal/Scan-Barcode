import 'package:dynamsoft_capture_vision_flutter/dynamsoft_capture_vision_flutter.dart';
import 'package:flutter/material.dart';

import 'barcode_utils.dart';
import 'scan_provider.dart';

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
                      onPressed: () {
                        setState(() {
                          dataCount = 0;
                          widget.result.forEach((item) {
                            if (!widget.saveResult.contains(item)) {
                              widget.saveResult.add(item);
                              dataCount++;
                            }
                          });
                          // Memperbarui _scanProvider.results dengan data yang tersimpan
                          widget.saveResult.forEach((item) {
                            widget.scanProvider.results
                                .remove(item.barcodeText);
                          });
                          // Kosongkan result setelah disimpan di saveResult
                          widget.result.clear();
                          // Kosongkan tempResult setelah disimpan di saveResult
                          widget.tempResult.clear();
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
