// // import 'dart:convert';

// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:scanbarcode/ScannedModel.dart';
// // import 'package:scanbarcode/restapi.dart';

// // import 'scan_provider.dart';
// // import 'barcode_utils.dart';
// // import 'config.dart';

// // // class DataScreen extends StatefulWidget {
// // //   @override
// // //   _DataScreenState createState() => _DataScreenState();
// // // }

// // // class _DataScreenState extends State<DataScreen> {
// // //   DataService ds = DataService();
// // //   List<ScannedModel> dataResult = [];

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     selectIdScannedModel();
// // //   }

// // //   Future<void> selectIdScannedModel() async {
// // //     List data =
// // //         jsonDecode(await ds.selectAll(token, project, 'scanned', appid));
// // //     setState(() {
// // //       dataResult = data.map((e) => ScannedModel.fromJson(e)).toList();
// // //     });
// // //   }

// // //   // final List<Map<String, String>> dummyData = [
// // //   //   {"barcodeText": "Barcode 1", "barcodeFormatString": "Format 1"},
// // //   //   {"barcodeText": "Barcode 2", "barcodeFormatString": "Format 2"},
// // //   //   {"barcodeText": "Barcode 3", "barcodeFormatString": "Format 3"},
// // //   // ];

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Consumer<ScanProvider>(
// // //       builder: (context, scanProvider, _) {
// // //         return ListView.separated(
// // //           itemCount: dataResult.length,
// // //           separatorBuilder: (context, index) => Divider(),
// // //           itemBuilder: (context, index) {
// // //             final scannedModel = dataResult[index];
// // //             // final result = dataResult.toList();
// // //             // final barcodeText = dataResult[index]["barcodeText"]!;
// // //             // final barcodeFormatString =
// // //             //     dataResult[index]["barcodeFormatString"]!;
// // //             return Card(
// // //               elevation: 2.0,
// // //               margin: EdgeInsets.symmetric(
// // //                 vertical: 4.0,
// // //                 horizontal: 8.0,
// // //               ),
// // //               child: ListTile(
// // //                 title: createURLString(scannedModel.code), // Adjust as needed
// // //                 subtitle: createURLString(scannedModel.format),
// // //                 trailing: ElevatedButton(
// // //                   onPressed: () {
// // //                     setState(() {
// // //                       // Remove the selected scanned model
// // //                       dataResult.removeAt(index);
// // //                       // Perform additional actions if needed
// // //                     });
// // //                     // final removedData = result.elementAt(index);
// // //                     // scanProvider.results
// // //                     //     .removeWhere((key, value) => key == removedData);
// // //                     ScaffoldMessenger.of(context).showSnackBar(
// // //                       SnackBar(
// // //                         content: Text(
// // //                             "Data dihapus: ${scannedModel.code} - ${scannedModel.format}"),
// // //                       ),
// // //                     );
// // //                   },
// // //                   child: Icon(Icons.delete),
// // //                 ),
// // //               ),
// // //             );
// // //           },
// // //         );
// // //       },
// // //     );
// // //   }
// // // }

// // //                   // onPressed: () {
// // //                   //   // Hapus data di indeks saat ini dari result
// // //                   //   final removedData = result.elementAt(index);
// // //                   //   dummyData.removeWhere(
// // //                   //       (key, value) => key == removedData.barcodeText);
// // //                   //   ScaffoldMessenger.of(context).showSnackBar(
// // //                   //     SnackBar(
// // //                   //       content: Text(
// // //                   //           "Data dihapus: ${removedData.barcodeText} - ${removedData.barcodeFormatString}"),
// // //                   //     ),
// // //                   //   );
// // //                   // },
// // class DataScreen extends StatefulWidget {
// //   @override
// //   _DataScreenState createState() => _DataScreenState();
// // }

// // class _DataScreenState extends State<DataScreen> {
// //   final DataService ds = DataService();
// //   late Future<List<ScannedModel>> _futureData;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _futureData = fetchData();
// //   }

// //   Future<List<ScannedModel>> fetchData() async {
// //     List data =
// //         jsonDecode(await ds.selectAll(token, project, 'scanned', appid));
// //     List<ScannedModel> scannedModels = [];
// //     for (var item in data) {
// //       scannedModels.add(ScannedModel.fromJson(item));
// //     }
// //     return scannedModels;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return FutureBuilder<List<ScannedModel>>(
// //       future: _futureData,
// //       builder: (context, snapshot) {
// //         if (snapshot.connectionState == ConnectionState.waiting) {
// //           return Center(child: CircularProgressIndicator());
// //         } else if (snapshot.hasError) {
// //           return Center(child: Text('Error: ${snapshot.error}'));
// //         } else {
// //           List<ScannedModel> dataResult = snapshot.data!;
// //           return ListView.separated(
// //             itemCount: dataResult.length,
// //             separatorBuilder: (context, index) => Divider(),
// //             itemBuilder: (context, index) {
// //               final scannedModel = dataResult[index];
// //               return Card(
// //                 elevation: 2.0,
// //                 margin: EdgeInsets.symmetric(
// //                   vertical: 4.0,
// //                   horizontal: 8.0,
// //                 ),
// //                 child: ListTile(
// //                   title: Text(scannedModel.code), // Adjust as needed
// //                   subtitle: Text(scannedModel.format), // Adjust as needed
// //                   trailing: ElevatedButton(
// //                     onPressed: () {
// //                       // Perform delete action if needed
// //                       ScaffoldMessenger.of(context).showSnackBar(
// //                         SnackBar(
// //                           content: Text("Data dihapus: ${scannedModel.code}"),
// //                         ),
// //                       );
// //                     },
// //                     child: Icon(Icons.delete),
// //                   ),
// //                 ),
// //               );
// //             },
// //           );
// //         }
// //       },
// //     );
// //   }
// // }

// class DataScreen extends StatefulWidget {
//   @override
//   _DataScreenState createState() => _DataScreenState();
// }

// class _DataScreenState extends State<DataScreen> {
//   late Future<ScannedModel?> _dataFuture;
//   final DataService ds = DataService();
//   String id = ''; // variabel untuk menyimpan ID yang dimasukkan pengguna

//   @override
//   void initState() {
//     super.initState();
//     _dataFuture = fetchData();
//   }

//   Future<ScannedModel?> fetchData() async {
//     // Jika ID belum dimasukkan, tampilkan dialog untuk memasukkan ID
//     if (id.isEmpty) {
//       id = (await _showIdInputDialog()) as String;
//     }

//     // Pastikan ID tidak kosong
//     if (id.isNotEmpty) {
//       String result = await ds.selectId(token, project, 'scanned', appid, id);
//       Map<String, dynamic> jsonData = jsonDecode(result);
//       return ScannedModel.fromJson(jsonData);
//     } else {
//       // Jika ID kosong, kembalikan null
//       return null;
//     }
//   }

//   Future<Future<String?>> _showIdInputDialog() async {
//     String id = ''; // Variabel untuk menyimpan ID yang dimasukkan pengguna
//     return showDialog<String>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Masukkan ID'),
//           content: TextField(
//             onChanged: (value) {
//               id = value;
//             },
//             decoration: InputDecoration(hintText: 'Masukkan ID'),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(id);
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ScanProvider>(
//       builder: (context, scanProvider, _) {
//         return FutureBuilder<ScannedModel?>(
//           future: _dataFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else {
//               if (snapshot.data != null) {
//                 final scannedModel = snapshot.data!;
//                 final barcodeText = scannedModel.code;
//                 final barcodeFormatString = scannedModel.format;
//                 return Card(
//                   elevation: 2.0,
//                   margin: EdgeInsets.symmetric(
//                     vertical: 4.0,
//                     horizontal: 8.0,
//                   ),
//                   child: ListTile(
//                     title: createURLString(barcodeText),
//                     subtitle: Text(barcodeFormatString),
//                     trailing: ElevatedButton(
//                       onPressed: () {
//                         // Hapus data
//                       },
//                       child: Icon(Icons.delete),
//                     ),
//                   ),
//                 );
//               } else {
//                 return Center(child: Text('Data tidak ditemukan'));
//               }
//             }
//           },
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanbarcode/ScannedModel.dart';
import 'dart:convert';

import 'scan_provider.dart';
import 'barcode_utils.dart';
import 'restapi.dart';
import 'config.dart';

class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  List<ScannedModel> scannedData = [];
  DataService ds = DataService();
  String id = ''; // Variabel untuk menyimpan ID yang dimasukkan pengguna
  String errorMessage = ''; // Pesan kesalahan

  Future<void> fetchData() async {
    try {
      final response = await ds.selectId(token, project, 'scanned', appid, id);
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = jsonDecode(response.body);
        final ScannedModel scannedItem = ScannedModel.fromJson(decodedData);
        setState(() {
          scannedData = [scannedItem];
          errorMessage =
              ''; // Bersihkan pesan kesalahan jika berhasil memuat data
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        errorMessage =
            'Error: $e'; // Tetapkan pesan kesalahan jika terjadi kesalahan
      });
    }
  }

  Future<void> _showIdInputDialog() async {
    String? inputId = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Masukkan ID'),
          content: TextField(
            onChanged: (value) {
              id = value;
            },
            decoration: InputDecoration(hintText: 'Masukkan ID'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(id);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    if (inputId != null && inputId.isNotEmpty) {
      id = inputId;
      await fetchData();
    }
  }

  @override
  void initState() {
    super.initState();
    _showIdInputDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanned Data'),
      ),
      body: errorMessage.isNotEmpty // Periksa apakah terdapat pesan kesalahan
          ? Center(
              child: Text(errorMessage), // Tampilkan pesan kesalahan jika ada
            )
          : scannedData.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: scannedData.length,
                  itemBuilder: (context, index) {
                    final item = scannedData[index];
                    return ListTile(
                      title: Text('Code: ${item.code}'),
                      subtitle: Text('Created Date: ${item.created_date}'),
                    );
                  },
                ),
    );
  }
}
