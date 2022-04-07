class BlockedDate {
  DateTime date;
  String note;

  BlockedDate({
    required this.date,
    this.note = '',
  });

  factory BlockedDate.fromJson(Map<String, dynamic> json) {
    return BlockedDate(
      date: DateTime.parse(json['date']),
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "note": note,
      };

  @override
  bool operator ==(Object other) {
    return other is BlockedDate &&
        date.day == other.date.day &&
        date.month == other.date.month &&
        date.year == other.date.year;
  }
}
