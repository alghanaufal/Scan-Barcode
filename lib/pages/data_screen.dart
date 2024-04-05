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
      appBar: AppBar(
        title: Text("Data Terbaca (${scanResults.length})"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Divider(
              height: 1.0,
              color: Colors.transparent,
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: selectWhareScanned(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: scanResults.length,
              itemBuilder: (context, index) {
                final item = scanResults[index];
                return Card(
                  elevation: 4.0,
                  margin: EdgeInsets.all(6.0),
                  child: ListTile(
                    title: createURLString(item.code),
                    subtitle: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF00603D),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        item.format,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    trailing: IconButton(
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
                      icon: Icon(Icons.delete),
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
