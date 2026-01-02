import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_constants.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/medical_info_card.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_routes.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final String? comingFrom;
  const AppointmentDetailScreen({super.key, required this.comingFrom});

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: CustomAppBar(title: "Appointment Details"),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _patientCard(),
                    const SizedBox(height: 16),
                    _appointmentInfo(),
                    const SizedBox(height: 16),
                    _symptomsCard(),
                    const SizedBox(height: 20),

                    /// choose
                    if (widget.comingFrom ==
                        AppConstants.appointmentRequest) ...[
                      _primaryButton('Start Consultation', AppColors.green),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _secondaryButton(
                                'Re-Schedule',
                                () => context.goNextScreen(
                                    AppRoutes.rescheduleOnSpecialist)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _secondaryButton(
                                'View profile',
                                () => context.goNextScreen(
                                    AppRoutes.patientProfileOnSpecialist)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _dangerButton('Cancel Appointment'),
                    ],

                    widget.comingFrom == AppConstants.upcomingAppointment
                        ? MedicalInfoCard()
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// --------------------------------------------------
  /// Patient Card
  /// --------------------------------------------------
  Widget _patientCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 110,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFB00000), Color(0xFFFF5722)],
              ),
            ),
            child: const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/patient.png'),
              backgroundColor: Colors.transparent,
            ),
          ),
          const SizedBox(height: 12),
          _tag('Video Call'),
          const SizedBox(height: 12),
          const Text(
            'Adaobi Nkemdilim',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            '32 • Female',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// --------------------------------------------------
  /// Appointment Info
  /// --------------------------------------------------
  Widget _appointmentInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _InfoRow(
            icon: Icons.calendar_today,
            label: 'Date',
            value: 'Wednesday, 12 March 2025',
          ),
          Divider(),
          _InfoRow(
            icon: Icons.access_time,
            label: 'Time',
            value: '10:30 AM',
          ),
          Divider(),
          _InfoRow(
            icon: Icons.tag,
            label: 'Reference',
            value: 'HB-APT-2746',
          ),
        ],
      ),
    );
  }

  /// --------------------------------------------------
  /// Symptoms
  /// --------------------------------------------------
  Widget _symptomsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Symptoms',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _symptomItem(
              'Primary Symptoms', 'Persistent headache and dizziness.'),
          _symptomItem('Started', '2–3 days ago'),
          _symptomItem('Severity', 'Moderate'),
          _symptomItem('Additional Notes', 'It gets worse in the morning.'),
          const SizedBox(height: 12),
          const Text(
            'Attached Photo',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF4FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: const [
                Icon(Icons.image, color: Colors.blue),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('IMG.124',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      SizedBox(height: 2),
                      Text('2.4 MB • Uploaded Mar 1, 2024',
                          style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                Text('View',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w500)),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// --------------------------------------------------
  /// Buttons
  /// --------------------------------------------------
  Widget _primaryButton(String text, Color color) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _secondaryButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _dangerButton(String text) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFDECEC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(text,
          style: const TextStyle(
              color: AppColors.red, fontWeight: FontWeight.w500)),
    );
  }

  /// --------------------------------------------------
  /// Helpers
  /// --------------------------------------------------
  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F6EC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.videocam, size: 14, color: AppColors.green),
          SizedBox(width: 6),
          Text('Video Call',
              style: TextStyle(
                  color: AppColors.green, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _symptomItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    );
  }
}

/// --------------------------------------------------
/// Reusable info row
/// --------------------------------------------------
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}
