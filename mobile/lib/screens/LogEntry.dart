import 'package:flutter/material.dart';
import 'package:mobile/helpers/fire_auth.dart';
import 'package:mobile/models/pet.dart';
import 'package:http/http.dart' as http;

class LogEntry extends StatefulWidget {
  final Pet pet;
  const LogEntry({Key? key, required this.pet}) : super(key: key);

  @override
  State<LogEntry> createState() => _LogEntryState();
}

class _LogEntryState extends State<LogEntry> {
  String? _symptoms;
  String? _medications;
  Food? _selectedFood;
  double _activityScore = 1.0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildQuestionAndInput(
                question: 'Symptoms',
                hintText: 'Enter symptoms',
                onSaved: (value) {
                  _symptoms = value;
                },
              ),
              _buildQuestionAndInput(
                question: 'Medications',
                hintText: 'Enter medications',
                onSaved: (value) {
                  _medications = value;
                },
              ),
              _buildQuestionAndDropdown(
                question: 'Food',
                value: _selectedFood,
                onChanged: (Food? value) {
                  setState(() {
                    _selectedFood = value;
                  });
                },
              ),
              _buildQuestionAndSlider(
                question: 'Activity Score',
                value: _activityScore,
                onChanged: (value) {
                  setState(() {
                    _activityScore = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Submit form data
                    print('Symptoms: $_symptoms');
                    print('Medications: $_medications');
                    print('Food: $_selectedFood');
                    print('Activity Score: $_activityScore');
                  }

                  // Make POST request
                  final url = Uri.parse(
                      'https://3q6kk9pq-3001.use.devtunnels.ms/secure/create-record');
                  print(url);
                  final response = await http.post(
                    url,
                    headers: {
                      "Authorization": "Bearer " + await FireAuth.getIdToken()
                    },
                    body: {
                      'pet_id': widget.pet.pet_id,
                      'symptoms': _symptoms,
                      'medications': _medications,
                      'food': _selectedFood.toString(),
                      'activityScore': '$_activityScore',
                    },
                  );

                  // Check response status
                  if (response.statusCode == 200) {
                    // Handle success
                    print('POST request successful');
                  } else {
                    // Handle error
                    print(response.body);
                    print(
                        'POST request failed with status: ${response.statusCode}');
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionAndInput({
    required String question,
    required String hintText,
    void Function(String?)? onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(),
            ),
            onSaved: onSaved,
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return 'Please enter $question';
            //   }
            //   return null;
            // },
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionAndDropdown({
    required String question,
    required Food? value,
    required void Function(Food?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DropdownButtonFormField<Food>(
            value: value,
            onChanged: onChanged,
            items: Food.values.map((Food food) {
              return DropdownMenuItem<Food>(
                value: food,
                child: Text(food.toString().split('.').last),
              );
            }).toList(),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionAndSlider({
    required String question,
    required double value,
    required void Function(double) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Slider(
            value: value,
            onChanged: onChanged,
            min: 1,
            max: 5,
            divisions: 4,
            label: value.toString(),
          ),
        ],
      ),
    );
  }
}
