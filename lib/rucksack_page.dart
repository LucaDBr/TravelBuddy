import 'package:flutter/material.dart';
import 'DBModels/trip_model.dart';

class RucksackPage extends StatelessWidget {
  final TripModel trip;

  const RucksackPage({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rucksack')),
      body: Center(child: Text('Rucksack für "${trip.title}"')),
    );
  }
}
