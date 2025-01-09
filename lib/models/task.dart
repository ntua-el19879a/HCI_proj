import 'package:google_maps_flutter/google_maps_flutter.dart';

class Task {
  String? id;
  String title;
  String? description;
  DateTime? date;
  String userId;
  String? address; // New property for human-readable address
  bool isCompleted;
  LatLng? latLngLocation;

  Task({
    this.id,
    required this.userId,
    required this.title,
    this.description,
    this.date,
    this.isCompleted = false,
    this.latLngLocation,
    this.address, // Add address to the constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'userId': userId,
      'description': description,
      'date': date?.toIso8601String(),
      'isCompleted': isCompleted,
      'latLngLocation': latLngLocation != null
          ? {'latitude': latLngLocation!.latitude, 'longitude': latLngLocation!.longitude}
          : null,
      'address': address, // Include address in map conversion
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
      latLngLocation: map['latLngLocation'] != null
          ? LatLng(
        map['latLngLocation']['latitude'],
        map['latLngLocation']['longitude'],
      )
          : null,
      address: map['address'], // Retrieve address from the map
    );
  }
}