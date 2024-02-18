import 'package:flutter/material.dart';
import 'package:mobile/helpers/fire_db.dart';
import 'package:mobile/models/pet.dart';
import 'package:mobile/screens/RecordsScreen.dart';

class MyPets extends StatelessWidget {
  const MyPets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Pets',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600)),
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
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    color: Color(0xffFFD0EC),
                    child: ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.pets),
                          SizedBox(width: 10),
                          Text(pets[index].name)
                        ],
                      ),
                      onTap: () {
                        print('tapped');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => RecordScreen(
                                      pet: pets[index],
                                    )));
                      },
                    ),
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
