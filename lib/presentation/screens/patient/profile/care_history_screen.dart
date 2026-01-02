import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class CareHistoryScreen extends StatefulWidget {
  const CareHistoryScreen({super.key});

  @override
  State<CareHistoryScreen> createState() => _CareHistoryScreenState();
}

class _CareHistoryScreenState extends State<CareHistoryScreen> {
  String selectedTab = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(title: 'Care History'),
      body: SafeArea(
        child: Column(
          children: [
            /// Tabs
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(child: _tabButton('All')),
                  const SizedBox(width: 12),
                  Expanded(child: _tabButton('Completed')),
                  const SizedBox(width: 12),
                  Expanded(child: _tabButton('Missed')),
                ],
              ),
            ),

            /// List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  /// Completed Section
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Completed',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _historyCard(
                    type: 'Video Call',
                    icon: Icons.videocam,
                    doctor: 'Chibundu Nwakaego Jackson',
                    specialty: 'Cardiologist',
                    date: 'May 3rd',
                    time: '12:00 AM',
                    status: 'completed',
                  ),
                  const SizedBox(height: 24),

                  /// Missed Section
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Missed Appointment',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _historyCard(
                    type: 'Voice Call',
                    icon: Icons.call,
                    doctor: 'Chibundu Nwakaego Jackson',
                    specialty: 'Cardiologist',
                    date: 'May 3rd',
                    time: '12:00 AM',
                    status: 'missed',
                  ),
                  const SizedBox(height: 12),
                  _historyCard(
                    type: 'In Person',
                    icon: Icons.location_on,
                    doctor: 'Chibundu Nwakaego Jackson',
                    specialty: 'Cardiologist',
                    date: 'May 3rd',
                    time: '12:00 AM',
                    status: 'missed',
                    location: 'Private Clinic',
                    address: '16 Hospital Road Eket Akwal-bom State',
                  ),
                  const SizedBox(height: 12),
                  _historyCard(
                    type: 'In Person',
                    icon: Icons.location_on,
                    doctor: 'Chibundu Nwakaego Jackson',
                    specialty: 'Cardiologist',
                    date: 'May 3rd',
                    time: '12:00 AM',
                    status: 'missed',
                    location: 'Private Clinic',
                    address: '16 Hospital Road Eket Akwal-bom State',
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String title) {
    final isSelected = selectedTab == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.red : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  Widget _historyCard({
    required String type,
    required IconData icon,
    required String doctor,
    required String specialty,
    required String date,
    required String time,
    required String status,
    String? location,
    String? address,
  }) {
    return GestureDetector(
      onTap: () {
        SnackBarUtils.showInfo(context, "View consultation details");
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Type Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: const Color(0xFF6B7280)),
            ),
            const SizedBox(height: 12),
            Text(
              type,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 12),

            /// Doctor Info
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/patient.png'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        specialty,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Location (if available)
            if (location != null && address != null) ...[
              Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 16, color: AppColors.red),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      location,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Text(
                  address,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            /// Date & Time
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Time',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            /// Status or Cancel button
            if (status == 'missed') ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Cancel',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.red,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
