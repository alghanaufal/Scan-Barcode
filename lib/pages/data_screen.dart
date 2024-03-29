import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:scanbarcode/model/ScannedModel.dart';

import '../utils/barcode_utils.dart';
import '../config/restapi.dart';
import '../config/config.dart';

class DataScreen extends StatefulWidget {
  final String device_id;

  const DataScreen({
    Key? key,
    required this.device_id,
  }) : super(key: key);

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  DataService ds = DataService();
  List data = [];
  List<ScannedModel> scanResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: selectWhareScanned(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.separated(
              itemCount: scanResults.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final item = scanResults[index];
                return Card(
                  elevation: 2.0,
                  margin: EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 8.0,
                  ),
                  child: ListTile(
                    title: createURLString(item.code),
                    subtitle: createURLString(item.format),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        bool res = await ds.removeId(
                            token, project, 'scanned', appid, item.id);
                        if (res) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("data removed."),
                              duration: Duration(seconds: 1),
                            ),
                          );
                          await selectWhareScanned();
                          setState(() {});
                        }
                      },
                      child: Icon(Icons.delete),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> selectWhareScanned() async {
    data = jsonDecode(await ds.selectWhere(
        token, project, 'scanned', appid, 'device_id', widget.device_id));

    scanResults = data.map((e) => ScannedModel.fromJson(e)).toList();
  }
}
