import 'package:flutter/material.dart';
import 'DBModels/trip_model.dart';
import 'rucksack_page.dart';
import 'budget_page.dart';
import 'tripplanung_page.dart';

class ReiseKonfigPage extends StatelessWidget {
  final TripModel trip;

  const ReiseKonfigPage({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Konfiguration: ${trip.title}')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.backpack),
            title: const Text('Rucksack'),
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => RucksackPage(trip: trip)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Budgetplanung'),
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => BudgetPage(trip: trip)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Tripplanung'),
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => TripplanungPage(trip: trip)));
            },
          ),
        ],
      ),
    );
  }
}
