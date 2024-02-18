import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/helpers/fire_auth.dart';
import 'package:mobile/models/pet.dart';

class FireDB {
  static Future<List<Pet>> GetPets() async {
    List<Pet> pets = [];

    try {
      FirebaseFirestore db = FirebaseFirestore.instance;

      await db
          .collection('pets')
          .where('user_id', isEqualTo: FireAuth.getUid())
          .get()
          .then((querySnapshot) => {
                for (var docSnapshot in querySnapshot.docs)
                  {pets.add(Pet.fromJson(docSnapshot.data()))}
              });
    } catch (e) {
      print('Error fetching pets: $e');
      // You might want to throw the error here or handle it in another way.
    }

    return pets;
  }
}
