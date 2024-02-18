import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile/helpers/fire_auth.dart';
import 'package:mobile/models/pet.dart';
import 'package:mobile/screens/CreatePet.dart';
import 'package:mobile/screens/ProfileScreen.dart';
import 'package:mobile/screens/appoinmentCreation.dart';
import 'package:mobile/screens/pets.dart';
import 'package:mobile/screens/appointments.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const screens = [
    MyPets(),
    AppointmentsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: _selectedIndex <= 1
            ? _selectedIndex == 0
                ? FloatingActionButton(
                    backgroundColor: const Color(0xffFFD0EC),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const CreatePetScreen()));
                    },
                    child: const Icon(Icons.add),
                  )
                : FloatingActionButton(
                    backgroundColor: const Color(0xffFFD0EC),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => AppointmentCreationScreen()));
                    },
                    child: const Icon(Icons.add),
                  )
            : null,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.pets),
              ),
              label: 'Pets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Appointments',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
        body: SafeArea(child: screens[_selectedIndex]));
  }
}
