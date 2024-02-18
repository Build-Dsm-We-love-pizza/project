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
        backgroundColor: Color(0xffFFD0EC),
        onPressed: () {
          Navigator.pushReplacement(
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
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Record> records = snapshot.data as List<Record>;
              return Column(
                children: [
                  const Text('Daily Logs',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.start),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Color(0xffFFD0EC),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'AI Suggestions',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                            Text(pet.suggestion ?? "No suggestion"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ListView.builder(
                    itemCount: records.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) {
                      print(records.length);
                      Record record = records[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Activity Score: " +
                                      record.activityScore.toString()),
                                  Text("Food: " +
                                      record.food.toString().split(".")[1]),
                                  Text(
                                      "Weight: ${record.weight?.toString() ?? "-"}"),
                                  Text(
                                    'Date: ${DateFormat('dd/MM/yyyy').format(record.dateTime)}',
                                  ),
                                ]),
                          ),
                        ),
                      );
                      // return ListTile(
                      //   title: Text(
                      //     'Weight: ${record.weight.toString()}',
                      //   ),
                      // subtitle: Text(
                      //   'Date: ${DateFormat('dd/MM/yyyy').format(record.dateTime)}',
                      //   ),
                      // );
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
