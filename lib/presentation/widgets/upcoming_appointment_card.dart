import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class UpcomingAppointmentCard extends StatelessWidget {
  final String patientName;
  final String appointmentInfo;
  final ImageProvider avatar;
  final IconData appointmentIcon;

  final VoidCallback onTap;
  final VoidCallback onReschedule;
  final VoidCallback onCancel;

  const UpcomingAppointmentCard({
    super.key,
    required this.patientName,
    required this.appointmentInfo,
    required this.avatar,
    this.appointmentIcon = Icons.videocam,
    required this.onTap,
    required this.onReschedule,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(backgroundImage: avatar),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patientName,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(appointmentIcon, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          appointmentInfo,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: filledButton(
                    'Re-Schedule',
                    AppColors.red,
                    onTap: onReschedule,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: outlinedButton(
                    'Cancel',
                    const Color(0xFFFDECEC),
                    AppColors.red,
                    onTap: onCancel,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget filledButton(String text, Color color,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        child: Text(text,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500)),
      ),
    );
  }

  static Widget outlinedButton(String text, Color bg, Color textColor,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: textColor),
        ),
        child: Text(text,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
