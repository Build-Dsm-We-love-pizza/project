import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/helpers/fire_db.dart';
import 'package:mobile/screens/VideoChat.dart';

import '../models/appoinment.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Appointments',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: FireDB.getAppointments(),
                builder: (context, AsyncSnapshot<List<Appointment>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final appointments = snapshot.data;
                    return appointments != null && appointments.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: appointments.length,
                            itemBuilder: (context, index) {
                              final appointment = appointments[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  color: Color(0xffFFD0EC),
                                  child: ListTile(
                                    onTap: () {
                                      // Navigator.of(context)
                                      //     .push(MaterialPageRoute(
                                      //   builder: (context) => VideoChatScreen(),
                                      // ));
                                    },
                                    title: Text(
                                        'Date: ${DateFormat('dd/MM/yyyy').format(appointment.onTime)}'),

                                    // Add more details as needed
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(child: Text('No appointments found'));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
