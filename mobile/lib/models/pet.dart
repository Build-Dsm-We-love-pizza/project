import 'package:cloud_firestore/cloud_firestore.dart';

class Pet {
  String name;
  Type type;
  List<Records> recordsList;
  String user_id;

  Pet(
      {required this.name,
      required this.type,
      required this.recordsList,
      required this.user_id});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type.toString(),
      'user_id': user_id,
      'recordsList': recordsList.map((records) => records.toMap()).toList(),
    };
  }

  factory Pet.fromJson(Map<String, dynamic> doc) {
    return Pet(
        name: doc['name'],
        type: Type.Dog,
        recordsList: [],
        user_id: doc['user_id']);
  }
}

class Records {
  int? weight;

  Records({this.weight}); // Constructor for Records.

  Map<String, dynamic> toMap() {
    return {
      'weight': weight,
    };
  }

  factory Records.fromMap(Map<String, dynamic> map) {
    // If you added fields to Records, retrieve them from the map here.
    return Records(
        // weight: map['weight'],
        // height: map['height'],
        );
  }
}

enum Type { Dog }
