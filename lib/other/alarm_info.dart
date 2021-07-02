class AlarmInfo {
  AlarmInfo({
    this.id,
    this.alarmDate,
    this.alarmTime,
  });

  int id;
  String alarmDate;
  String alarmTime;

  factory AlarmInfo.fromJson(Map<String, dynamic> json) => AlarmInfo(
        id: json["id"],
        alarmDate: json["alarmDate"],
        alarmTime: json["alarmTime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "alarmDate": alarmDate,
        "alarmTime": alarmTime,
      };
}
