import 'package:google_maps_flutter/google_maps_flutter.dart';

class Task {
  String? id;
  String title;
  String? description;
  DateTime? date;
  String userId;
  String? address;
  bool isCompleted; // This should be a non-nullable bool
  LatLng? latLngLocation;

  Task({
    this.id,
    required this.userId,
    required this.title,
    this.description,
    this.date,
    this.isCompleted = false, // Default to false for new tasks
    this.address,
    this.latLngLocation,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'userId': userId,
      'description': description,
      'date': date?.toIso8601String(),
      'isCompleted': isCompleted, // No need to convert to 1 or 0 for Firestore
      'address': address,
      'latLngLocation': latLngLocation != null
          ? {
              'latitude': latLngLocation!.latitude,
              'longitude': latLngLocation!.longitude
            }
          : null,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      description: map['description'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      isCompleted: map['isCompleted'] ?? false,
      address: map['address'],
      latLngLocation: map['latLngLocation'] != null
          ? LatLng(
              map['latLngLocation']['latitude'],
              map['latLngLocation']['longitude'],
            )
          : null,
    );
  }
}
