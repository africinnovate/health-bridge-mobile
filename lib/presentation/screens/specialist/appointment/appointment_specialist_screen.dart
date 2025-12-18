import 'package:flutter/material.dart';

import '../../../widgets/appointment_card.dart';

class SpecialistAppointmentsScreen extends StatefulWidget {
  const SpecialistAppointmentsScreen({super.key});

  @override
  State<SpecialistAppointmentsScreen> createState() =>
      _SpecialistAppointmentsScreenState();
}

class _SpecialistAppointmentsScreenState
    extends State<SpecialistAppointmentsScreen> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            _tabs(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: 6,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (_, __) {
                  return AppointmentCard(
                    showActions: selectedTab == 0,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// --------------------------------------------------
  Widget _header() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Appointments',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _tabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _tabItem('Up Coming', 0),
          _tabItem('Completed', 1),
          _tabItem('Missed', 2),
        ],
      ),
    );
  }

  Widget _tabItem(String text, int index) {
    final selected = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFB00000) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
