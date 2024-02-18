import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  String user_id;
  String pet_id;
  String vet_id;
  DateTime onTime;

  Appointment(
      {required this.vet_id,
      required this.pet_id,
      required this.user_id,
      required this.onTime});

  factory Appointment.fromJson(Map<String, dynamic> doc) {
    Timestamp ts = doc['onTime'];
    DateTime date = ts.toDate();
    print(doc.toString());
    return Appointment(
        pet_id: doc['pet_id'],
        user_id: doc['user_id'],
        vet_id: doc['vet_id'],
        onTime: date);
  }
}
