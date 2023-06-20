import 'package:flutter/foundation.dart';

@immutable
class MedicalCenter {
  final String name;
  final List<dynamic>? phoneNumbers;
  final String location;
  final String latitude;
  final String longitude;

  const MedicalCenter({
    required this.name,
    required this.phoneNumbers,
    required this.location,
    required this.latitude,
    required this.longitude,
  });

  MedicalCenter.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        phoneNumbers = List<dynamic>.from(json['phoneNumbers']  as List).cast() ,
        location = json['location'] as String,
        latitude = json['latitude'] as String,
        longitude = json['longitude'] as String;

  Map<String, dynamic> toJson() => {
        'name': name,
        'phoneNumbers': phoneNumbers,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
      };
}
