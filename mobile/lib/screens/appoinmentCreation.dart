import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/helpers/fire_auth.dart';
import 'package:mobile/helpers/fire_db.dart';
import 'package:mobile/models/pet.dart';

class Vet {
  final String name;
  final String id;
  Vet(this.name, this.id);
}

class AppointmentCreationScreen extends StatefulWidget {
  @override
  _AppointmentCreationScreenState createState() =>
      _AppointmentCreationScreenState();
}

class _AppointmentCreationScreenState extends State<AppointmentCreationScreen> {
  late Vet selectedVet;
  List<Pet> pets = [];
  Pet? selectedPet;

  @override
  void initState() {
    super.initState();
    // Fetch pets from Firebase or any other source
    fetchPets();
    // Assuming there's only one vet hardcoded
    selectedVet = Vet('Dr. Smith', "4LXzTkn2q5YJOb1qPZDXpXXJlTz1");
  }

  void fetchPets() async {
    // You can replace this with your Firebase call to get pets
    pets = await FireDB.GetPets();
  }

  void submitForm() async {
    final url = Uri.parse(
        'https://3q6kk9pq-3001.use.devtunnels.ms/secure/create-appointment');
    final response = await http.post(url, headers: {
      'Authorization': 'Bearer ${await FireAuth.getIdToken()}',
    }, body: {
      'pet_id': selectedPet!.pet_id,
      'vet_id': "4LXzTkn2q5YJOb1qPZDXpXXJlTz1",
      "on": "2024-02-24T02:56:06.000Z"
    });
    print(response.statusCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<Vet>(
              value: selectedVet,
              onChanged: (newValue) {
                setState(() {
                  selectedVet = newValue!;
                });
              },
              items: [selectedVet].map((Vet vet) {
                return DropdownMenuItem<Vet>(
                  value: vet,
                  child: Text(vet.name),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Select a vet',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<Pet>(
              value: null,
              onChanged: (newValue) {
                setState(() {
                  selectedPet = newValue;
                });
              },
              items: pets.map((Pet pet) {
                return DropdownMenuItem<Pet>(
                  value: pet,
                  child: Text(pet.name),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Select your pet',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitForm,
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xff1F2544)),
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(horizontal: 16))),
              child: const Text(
                'Create Appointment',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
