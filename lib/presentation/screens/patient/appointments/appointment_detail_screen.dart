import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/cancel_button.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class PatientAppointmentDetailScreen extends StatefulWidget {
  final String status;

  const PatientAppointmentDetailScreen({
    super.key,
    this.status = 'confirmed',
  });

  @override
  State<PatientAppointmentDetailScreen> createState() =>
      _PatientAppointmentDetailScreenState();
}

class _PatientAppointmentDetailScreenState
    extends State<PatientAppointmentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(title: 'Appointment Details'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Status Badge
                if (widget.status == 'completed') ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.green.withOpacity(0.1),
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
                  const SizedBox(height: 20),
                ] else if (widget.status == 'missed') ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.red.withOpacity(0.1),
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
                  const SizedBox(height: 20),
                ],

                /// Specialist Info Card
                Container(
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
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage: AssetImage('assets/images/patient.png'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Chibundu Nwakaego Jackson',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Cardiologist',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: const [
                                Icon(Icons.star,
                                    color: Color(0xFFFBBF24), size: 16),
                                SizedBox(width: 4),
                                Text(
                                  '4.5',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  ' (127 reviews)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                /// Appointment Info
                const Text(
                  'Appointment Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _infoRow(Icons.calendar_today, 'Date', 'May 3rd, 2024'),
                      const SizedBox(height: 16),
                      _infoRow(Icons.access_time, 'Time', '14:00 AM'),
                      const SizedBox(height: 16),
                      _infoRow(Icons.videocam, 'Consultation Type', 'Video Call'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                /// Symptoms (if completed with symptoms)
                if (widget.status == 'completed_with_symptoms' ||
                    widget.status == 'confirmed_with_symptoms') ...[
                  const Text(
                    'Symptoms Described',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'I have been experiencing chest pain and shortness of breath for the past two days. The pain is sharp and occurs mainly when I exercise or climb stairs.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                /// Attached Photos (if with symptoms)
                if (widget.status == 'completed_with_symptoms' ||
                    widget.status == 'confirmed_with_symptoms') ...[
                  const Text(
                    'Attached Photos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.image,
                              size: 40, color: Color(0xFF9CA3AF)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.image,
                              size: 40, color: Color(0xFF9CA3AF)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],

                /// Notes (if completed)
                if (widget.status == 'completed' ||
                    widget.status == 'completed_with_symptoms') ...[
                  const Text(
                    'Consultation Notes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Patient shows signs of stress-induced chest pain. Recommended lifestyle changes and follow-up in 2 weeks. Prescribed medication for symptom management.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                /// Prescription (if completed)
                if (widget.status == 'completed' ||
                    widget.status == 'completed_with_symptoms') ...[
                  const Text(
                    'Prescription',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _prescriptionItem('Aspirin 75mg', 'Once daily - 30 days'),
                        const Divider(height: 24),
                        _prescriptionItem(
                            'Metoprolol 50mg', 'Twice daily - 30 days'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                /// Action Buttons
                if (widget.status == 'confirmed' ||
                    widget.status == 'confirmed_with_symptoms') ...[
                  CustomButton(
                    onPressed: () {
                      SnackBarUtils.showInfo(context, "Join consultation");
                    },
                    text: 'Join Consultation',
                  ),
                  const SizedBox(height: 12),
                  CancelButton(
                    onPressed: () {
                      _showCancelDialog();
                    },
                    text: 'Cancel Appointment',
                  ),
                ] else if (widget.status == 'completed' ||
                    widget.status == 'completed_with_symptoms') ...[
                  CustomButton(
                    onPressed: () {
                      SnackBarUtils.showInfo(context, "Download prescription");
                    },
                    text: 'Download Prescription',
                  ),
                  const SizedBox(height: 12),
                  CancelButton(
                    onPressed: () {
                      SnackBarUtils.showInfo(context, "Book another appointment");
                    },
                    text: 'Book Another Appointment',
                  ),
                ] else if (widget.status == 'missed') ...[
                  CustomButton(
                    onPressed: () {
                      SnackBarUtils.showInfo(context, "Reschedule appointment");
                    },
                    text: 'Reschedule Appointment',
                  ),
                ],

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF6B7280)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _prescriptionItem(String medication, String dosage) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.medication,
              size: 20, color: Color(0xFF6B7280)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                medication,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                dosage,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Cancel Appointment',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Are you sure you want to cancel this appointment?',
          style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'No, Keep It',
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              SnackBarUtils.showInfo(context, "Appointment cancelled");
            },
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
