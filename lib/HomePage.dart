import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'LoginAndUserKonfig/login_page.dart';
import 'LoginAndUserKonfig/user_management_page.dart';
import 'LoginAndUserKonfig/system_settings_page.dart';
import 'reise_uebersicht_page.dart';
import 'reise_detail_page.dart';
import 'DBModels/trip_model.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  Stream<List<TripModel>> ladeReisen() {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final owned = FirebaseFirestore.instance
        .collection('trips')
        .where('ownerUid', isEqualTo: uid)
        .snapshots();

    final member = FirebaseFirestore.instance
        .collection('trips')
        .where('members', arrayContains: uid)
        .snapshots();

    return owned.asyncMap((ownedSnap) async {
      final ownedTrips = ownedSnap.docs.map((doc) {
        final data = doc.data();
        return TripModel.fromJson(data).copyWith(id: doc.id);
      }).toList();

      final memberSnap = await member.first;
      final memberTrips = memberSnap.docs.map((doc) {
        final data = doc.data();
        return TripModel.fromJson(data).copyWith(id: doc.id);
      }).toList();

      final alle = [...ownedTrips];
      for (var t in memberTrips) {
        if (!alle.any((e) => e.id == t.id)) {
          alle.add(t);
        }
      }

      return alle;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final displayName = user.displayName ?? 'Nutzer';
    final email = user.email ?? '-';
    final photoUrl = user.photoURL;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TravelBuddy'),
          actions: [
            IconButton(icon: const Icon(Icons.logout), onPressed: () => logout(context)),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.schedule), text: 'Anstehend'),
              Tab(icon: Icon(Icons.flight_takeoff), text: 'Aktuell'),
              Tab(icon: Icon(Icons.history), text: 'Vergangen'),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(displayName),
                accountEmail: Text(email),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: photoUrl != null
                      ? NetworkImage(photoUrl)
                      : const AssetImage('assets/icon/IconProfiilpicPlaceholder.png') as ImageProvider,
                ),
              ),
              _drawerItem(context, Icons.travel_explore, 'Meine Reisen', const ReiseUebersichtPage()),
              _drawerItem(context, Icons.manage_accounts, 'Nutzerverwaltung', const UserManagementPage()),
              _drawerItem(context, Icons.settings, 'Systemeinstellungen', const SystemSettingsPage()),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Abmelden'),
                onTap: () {
                  Navigator.pop(context);
                  logout(context);
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: StreamBuilder<List<TripModel>>(
            stream: ladeReisen(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'Noch keine Reisen angelegt.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              final now = DateTime.now();
              final trips = snapshot.data!;
              final upcoming = trips.where((t) => t.startDate != null && t.startDate!.isAfter(now)).toList();
              final ongoing = trips.where((t) =>
                  t.startDate != null &&
                  t.endDate != null &&
                  t.startDate!.isBefore(now) &&
                  t.endDate!.isAfter(now)).toList();
              final past = trips.where((t) => t.endDate != null && t.endDate!.isBefore(now)).toList();

              return TabBarView(
                children: [
                  ReiseTabList(trips: upcoming),
                  ReiseTabList(trips: ongoing),
                  ReiseTabList(trips: past),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  ListTile _drawerItem(BuildContext context, IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
    );
  }
}

/* -------------------------------------- */
/* Reise-Tab-Liste mit schöner Optik      */
/* -------------------------------------- */

class ReiseTabList extends StatelessWidget {
  final List<TripModel> trips;
  const ReiseTabList({super.key, required this.trips});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        final start = trip.startDate;
        final end = trip.endDate;
        final dateRange = (start != null && end != null)
            ? '${MaterialLocalizations.of(context).formatShortDate(start)} – ${MaterialLocalizations.of(context).formatShortDate(end)}'
            : 'Datum unbekannt';

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 2,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: const Icon(Icons.location_on_outlined, size: 32),
            title: Text(
              trip.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text(dateRange),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ReiseDetailPage(trip: trip)),
              );
            },
          ),
        );
      },
    );
  }
}
