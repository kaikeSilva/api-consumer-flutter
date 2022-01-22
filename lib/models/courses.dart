class Course {
  final int? id;
  final String name;
  
  final int? userId;
  final String? timeFormatted;
  final String description;
  final String resourcePlace;
  final int? durationMinutes;

  final int? durationMinutesInt;
  final int? durationHours;

  const Course({
    this.id,
    required this.name,
    this.userId,
    this.timeFormatted,
    required this.description,
    required this.resourcePlace,
    this.durationMinutes,
    this.durationMinutesInt,
    this.durationHours,
  });

  factory Course.fromJason(Map<String,dynamic> item) {
    return Course(
      id: item['id'],
      name: item['name'],
      userId: item['user_id'],
      timeFormatted: item['time_formatted'],
      description: item['description'],
      resourcePlace: item['resource_place'],
      durationMinutes: item['duration_minutes']);
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "duration_hours": durationHours,
      "duration_minutes": durationMinutesInt,
      "description": description,
      "resource_place": resourcePlace,
    };
  }
}