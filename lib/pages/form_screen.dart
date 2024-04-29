import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoCloudEtterForm extends StatefulWidget {
  const GoCloudEtterForm({Key? key}) : super(key: key);

  @override
  _GoCloudEtterFormState createState() => _GoCloudEtterFormState();
}

class _GoCloudEtterFormState extends State<GoCloudEtterForm> {
  TextEditingController _tokenController = TextEditingController();
  TextEditingController _projectController = TextEditingController();
  TextEditingController _collectionController = TextEditingController();
  TextEditingController _appIdController = TextEditingController();
  int? _radioValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'REST API',
                              style: TextStyle(
                                fontSize: 46,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Configuration',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.code_rounded,
                        size: 100,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 16),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          title: Text('GoCloud'),
                          value: 1,
                          groupValue: _radioValue,
                          onChanged: (int? value) {
                            setState(() {
                              _radioValue = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          title: Text('ETTER'),
                          value: 2,
                          groupValue: _radioValue,
                          onChanged: (int? value) {
                            setState(() {
                              _radioValue = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
              _buildLabeledTextField('Token', 'Your Token', _tokenController),
              SizedBox(height: 5),
              _buildLabeledTextField(
                  'Project', 'Project Name', _projectController),
              SizedBox(height: 5),
              _buildLabeledTextField(
                  'Collection', 'Your Collection', _collectionController),
              SizedBox(height: 5),
              _buildLabeledTextField('AppID', 'Your App ID', _appIdController),
              SizedBox(height: 5),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    print('halo');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(30, 76, 160, 1.0),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _projectController.dispose();
    _collectionController.dispose();
    _appIdController.dispose();
    super.dispose();
  }

  Widget _buildLabeledTextField(
      String label, String hintText, TextEditingController? controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '(Required)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveDataLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', _tokenController.text);
    prefs.setString('project', _projectController.text);
    prefs.setString('collection', _collectionController.text);
    prefs.setString('appId', _appIdController.text);
    prefs.setInt('radioValue',
        _radioValue ?? 0); // Default value set to 0 if _radioValue is null
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data saved locally'),
      ),
    );
  }
}
