import 'package:flutter/material.dart';
import 'package:mobile/helpers/fire_auth.dart';
import 'package:mobile/helpers/fire_db.dart';
import 'package:mobile/models/pet.dart';
import 'package:mobile/screens/ProfileScreen.dart';
import 'package:mobile/screens/RecordsScreen.dart';

class MyPets extends StatelessWidget {
  const MyPets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Pets'),
      ),
      body: FutureBuilder<List<Pet>>(
        future: FireDB.GetPets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final pets = snapshot.data ?? [];
            return ListView.builder(
              itemCount: pets.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(pets[index].name),
                    onTap: () {
                      print('tapped ');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => RecordScreen(
                                    pet: pets[index],
                                  )));
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
