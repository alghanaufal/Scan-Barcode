class ScannedModel {
  final String id;
  final String device_id;
  final String code;
  final String format;
  final String created_date;
  final String created_month;
  final String created_month_name;
  final String created_year;

  ScannedModel(
      {required this.id,
      required this.device_id,
      required this.code,
      required this.format,
      required this.created_date,
      required this.created_month,
      required this.created_month_name,
      required this.created_year});

  factory ScannedModel.fromJson(Map<String, dynamic> data) {
    return ScannedModel(
        id: data['_id'],
        device_id: data['device_id'],
        code: data['code'],
        format: data['format'],
        created_date: data['created_date'],
        created_month: data['created_month'],
        created_month_name: data['created_month_name'],
        created_year: data['created_year']);
  }
}
