import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/helpers/fire_auth.dart';

class CreatePetScreen extends StatefulWidget {
  const CreatePetScreen({Key? key}) : super(key: key);

  @override
  State<CreatePetScreen> createState() => _CreatePetScreenState();
}

class _CreatePetScreenState extends State<CreatePetScreen> {
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  Future<void> _addPet() async {
    final String breed = _breedController.text.trim();
    final String name = _nameController.text.trim();

    if (name.isEmpty) {
      // Show error if any field is empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please add name.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Make HTTP POST request
    final url =
        Uri.parse('https://3q6kk9pq-3001.use.devtunnels.ms/secure/create-pet');
    final response = await http.post(url, headers: {
      'Authorization': 'Bearer ' + await FireAuth.getIdToken(),
    }, body: {
      'name': name,
      'breed': breed,
    });

    // Check response status
    if (response.statusCode == 200) {
      // Handle success
      print('Pet added successfully');
    } else {
      // Handle error
      print('Failed to add pet. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Pet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _breedController,
              decoration: InputDecoration(
                labelText: 'Breed',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the breed';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addPet,
              child: const Text('Add Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
