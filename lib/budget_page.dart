import 'package:flutter/material.dart';
import 'DBModels/trip_model.dart';

class BudgetPage extends StatelessWidget {
  final TripModel trip;

  const BudgetPage({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budgetplanung')),
      body: Center(child: Text('Budget für "${trip.title}"')),
    );
  }
}
