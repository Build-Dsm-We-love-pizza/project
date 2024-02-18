// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Pet {
  String name;
  Type type;
  // List<Record> recordsList;
  String user_id;
  String pet_id;

  Pet(
      {required this.name,
      required this.type,
      // required this.recordsList,
      required this.user_id,
      required this.pet_id});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type.toString(),
      'user_id': user_id,
      // 'recordsList': recordsList.map((records) => records.toMap()).toList(),
    };
  }

  factory Pet.fromJson(Map<String, dynamic> doc) {
    return Pet(
        name: doc['name'],
        type: Type.Dog,
        user_id: doc['user_id'],
        pet_id: doc['pet_id']);
  }
}

class Record {
  int? weight;
  int activityScore;
  Food food;
  String? medications;
  String? symptoms;
  DateTime dateTime;

  Record({
    this.weight,
    required this.dateTime,
    required this.activityScore,
    required this.food,
    this.symptoms,
    this.medications,
  });

  Map<String, dynamic> toMap() {
    return {
      'weight': weight,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }

  factory Record.fromJson(Map<String, dynamic> doc) {
    Timestamp ts = doc['dateTime'];
    DateTime date = ts.toDate();

    // Parse 'weight' and 'activityScore' as integers
    int? weight =
        doc['weight'] != null ? int.tryParse(doc['weight'].toString()) : null;
    int? activityScore = doc['activityScore'] != null
        ? int.tryParse(doc['activityScore'].toString())
        : null;

    return Record(
      weight: weight,
      dateTime: date,
      activityScore: activityScore ?? 0, // Provide default value if null
      food: foodFromString(doc['food']),
      symptoms: doc['symptoms'] ?? '', // Provide default value if null
      medications: doc['medications'] ?? '', // Provide default value if null
    );
  }

  static Food foodFromString(String? foodString) {
    switch (foodString) {
      case 'Purina':
        return Food.Purina;
      case 'Royal_Canin':
        return Food.Royal_Canin;
      case 'Blue_Buffalo':
        return Food.Blue_Buffalo;
      case 'Home_Cooked':
        return Food.Home_Cooked;
      default:
        throw ArgumentError('Invalid food string: $foodString');
    }
  }
}

enum Food { Purina, Royal_Canin, Blue_Buffalo, Home_Cooked }

// enum BowelMovement {

// }

enum Type { Dog }
