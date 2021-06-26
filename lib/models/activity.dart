class ActivityModel {
  final id;
  final int year;
  final int month;
  final int day;
  final String title;
  final String info;
  final String startTime;
  final String endTime;

  ActivityModel({
    this.id,
    required this.year,
    required this.month,
    required this.day,
    required this.title,
    required this.info,
    required this.startTime,
    required this.endTime,
  });

  factory ActivityModel.fromMap(Map<String, dynamic> json) => ActivityModel(
      id: json["id"],
      year: json["year"],
      month: json["month"],
      day: json["day"],
      title: json["title"],
      info: json['info'],
      startTime: (json["startTime"]),
      endTime: json["endTime"]);

  Map<String, dynamic> toMapInsert() => {
        "id": id,
        "year": year,
        "month": month,
        "day": day,
        "title": title,
        "info": info,
        "startTime": startTime,
        "endTime": endTime,
      };
  Map<String, dynamic> toMapUpdate() => {
        "year": year,
        "month": month,
        "day": day,
        "title": title,
        "info": info,
        "startTime": startTime,
        "endTime": endTime,
      };
}
