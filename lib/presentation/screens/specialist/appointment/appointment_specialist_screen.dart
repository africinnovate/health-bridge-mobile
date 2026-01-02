import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../widgets/appointment_card.dart';

class SpecialistAppointmentsScreen extends StatefulWidget {
  final bool? showArrow;

  const SpecialistAppointmentsScreen({super.key, this.showArrow});

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
      appBar: CustomAppBar(
          title: "Appointments", showArrow: widget.showArrow ?? false),
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
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

  Widget _tabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(12),
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
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: selected ? AppColors.red : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
