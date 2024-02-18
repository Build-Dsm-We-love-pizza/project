import 'package:flutter/material.dart';
import 'package:mobile/models/pet.dart';

class RecordScreen extends StatelessWidget {
  final Pet pet;
  const RecordScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
      ),
      body: Column(
        children: [
          Text('Daily Logs'),
          ListView.builder(
              shrinkWrap: true,
              itemBuilder: (ctx, index) {
                return ListTile();
              })
        ],
      ),
    );
  }
}
