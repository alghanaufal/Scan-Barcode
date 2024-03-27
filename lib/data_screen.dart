import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'scan_provider.dart';
import 'barcode_utils.dart';

class DataScreen extends StatelessWidget {
  final List<Map<String, String>> dummyData = [
    {"barcodeText": "Barcode 1", "barcodeFormatString": "Format 1"},
    {"barcodeText": "Barcode 2", "barcodeFormatString": "Format 2"},
    {"barcodeText": "Barcode 3", "barcodeFormatString": "Format 3"},
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ScanProvider>(
      builder: (context, scanProvider, _) {
        return ListView.separated(
          itemCount: dummyData.length,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) {
            final result = dummyData.toList();
            final barcodeText = dummyData[index]["barcodeText"]!;
            final barcodeFormatString =
                dummyData[index]["barcodeFormatString"]!;
            return Card(
              elevation: 2.0,
              margin: EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 8.0,
              ),
              child: ListTile(
                title: createURLString(barcodeText),
                subtitle: createURLString(barcodeFormatString),
                trailing: ElevatedButton(
                  onPressed: () {
                    final removedData = result.elementAt(index);
                    scanProvider.results
                        .removeWhere((key, value) => key == removedData);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "Data dihapus: ${removedData} - ${removedData}"),
                      ),
                    );
                  },
                  child: Icon(Icons.delete),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

                  // onPressed: () {
                  //   // Hapus data di indeks saat ini dari result
                  //   final removedData = result.elementAt(index);
                  //   dummyData.removeWhere(
                  //       (key, value) => key == removedData.barcodeText);
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //       content: Text(
                  //           "Data dihapus: ${removedData.barcodeText} - ${removedData.barcodeFormatString}"),
                  //     ),
                  //   );
                  // },