import 'package:flutter/material.dart';
import 'package:mobile/helpers/fire_db.dart';
import 'package:mobile/models/pet.dart';
import 'package:intl/intl.dart';
import 'package:mobile/screens/LogEntry.dart';

class RecordScreen extends StatelessWidget {
  final Pet pet;
  RecordScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => LogEntry(
                        pet: pet,
                      )));
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: FireDB.getRecords(pet.pet_id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Record> records = snapshot.data as List<Record>;
              return Column(
                children: [
                  const Text('Daily Logs'),
                  ListView.builder(
                    itemCount: records.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) {
                      print(records.length);
                      Record record = records[index];
                      return ListTile(
                        title: Text(
                          'Weight: ${record.weight.toString()}',
                        ),
                        subtitle: Text(
                          'Date: ${DateFormat('dd/MM/yyyy').format(record.dateTime)}',
                        ),
                      );
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
