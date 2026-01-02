import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_constants.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/upcoming_appointment_card.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/dialog.dart';

class SpecialistHomeScreen extends StatefulWidget {
  const SpecialistHomeScreen({super.key});

  @override
  State<SpecialistHomeScreen> createState() => _SpecialistHomeScreenState();

  static Widget _filledButton(String text, Color color,
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

  static Widget _outlinedButton(String text, Color bg, Color textColor,
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

class _SpecialistHomeScreenState extends State<SpecialistHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: Column(
        children: [
          /// FIXED HEADER
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 35),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context.goNextScreenWithData(
                      AppRoutes.specialistProfile,
                      extra: true,
                    );
                  },
                  child: const CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage('assets/images/patient.png'),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Hello, Dr Martins',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // SizedBox(height: 2),
                    Text(
                      'Your schedule at a glance.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Stack(
                  children: [
                    const Icon(Icons.notifications_none, size: 26),
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),

          /// 📜 SCROLLABLE CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _sectionTitle('Next Appointment'),
                  _nextAppointmentCard(),
                  const SizedBox(height: 24),
                  _sectionHeader('Appointment Requests',
                      onPress: () => context.goNextScreenWithData(
                            AppRoutes.specialistRequestScreen,
                            extra: true,
                          )),
                  _requestCard(),
                  _requestCard(),
                  const SizedBox(height: 24),
                  _sectionHeader('Upcoming Appointments',
                      onPress: () => context.goNextScreenWithData(
                          AppRoutes.appointmentTapOnSpecialist,
                          extra: true)),

                  /// use 3 static cards (make on listview later)
                  UpcomingAppointmentCard(
                    patientName: 'James Adebayo',
                    appointmentInfo: 'Video Call • Tomorrow, 2:00 PM',
                    avatar: const AssetImage('assets/images/patient.png'),
                    onTap: () {
                      context.goNextScreenWithData(
                          AppRoutes.specialistAppointDetailScreen,
                          extra: AppConstants.upcomingAppointment);
                    },
                    onReschedule: () {
                      context.goNextScreen(AppRoutes.rescheduleOnSpecialist);
                    },
                    onCancel: () {
                      showConfirmDialog(
                        context,
                        title: 'Cancel Appointment?',
                        message:
                            'Are you sure you want to cancel this appointment? You won’t be able to undo this action.',
                        confirmText: 'Yes, Cancel Appointment',
                        cancelText: 'Keep Appointment',
                        icon: Icons.question_mark,
                        onConfirm: () {
                          SnackBarUtils.showInfo(context, "In progress");
                        },
                      );
                    },
                  ),

                  UpcomingAppointmentCard(
                    patientName: 'James Adebayo',
                    appointmentInfo: 'Video Call • Tomorrow, 2:00 PM',
                    avatar: const AssetImage('assets/images/patient.png'),
                    onTap: () {
                      context.goNextScreenWithData(
                          AppRoutes.specialistAppointDetailScreen,
                          extra: AppConstants.upcomingAppointment);
                    },
                    onReschedule: () {
                      context.goNextScreen(AppRoutes.rescheduleOnSpecialist);
                    },
                    onCancel: () {
                      showConfirmDialog(
                        context,
                        title: 'Cancel Appointment?',
                        message:
                            'Are you sure you want to cancel this appointment? You won’t be able to undo this action.',
                        confirmText: 'Yes, Cancel Appointment',
                        cancelText: 'Keep Appointment',
                        icon: Icons.question_mark,
                        onConfirm: () {
                          SnackBarUtils.showInfo(context, "In progress");
                        },
                      );
                    },
                  ),
                  UpcomingAppointmentCard(
                    patientName: 'James Adebayo',
                    appointmentInfo: 'Video Call • Tomorrow, 2:00 PM',
                    avatar: const AssetImage('assets/images/patient.png'),
                    onTap: () {
                      context.goNextScreenWithData(
                          AppRoutes.specialistAppointDetailScreen,
                          extra: AppConstants.upcomingAppointment);
                    },
                    onReschedule: () {
                      context.goNextScreen(AppRoutes.rescheduleOnSpecialist);
                    },
                    onCancel: () {
                      showConfirmDialog(
                        context,
                        title: 'Cancel Appointment?',
                        message:
                            'Are you sure you want to cancel this appointment? You won’t be able to undo this action.',
                        confirmText: 'Yes, Cancel Appointment',
                        cancelText: 'Keep Appointment',
                        icon: Icons.question_mark,
                        onConfirm: () {
                          SnackBarUtils.showInfo(context, "In progress");
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle('Recent Activity'),
                  _activityItem(
                    icon: Icons.check_circle,
                    color: AppColors.green,
                    title: 'Consultation completed with Adaobi',
                    time: '2 hours ago',
                  ),
                  _activityItem(
                    icon: Icons.warning_amber_rounded,
                    color: Colors.orange,
                    title: 'Missed appointment marked for James',
                    time: '2 hours ago',
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ------------------------------------------------------------
  /// Widgets
  /// ------------------------------------------------------------

  Widget _sectionTitle(String title) {
    return Text(title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600));
  }

  Widget _sectionHeader(String title, {required VoidCallback onPress}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _sectionTitle(title),
        GestureDetector(
          onTap: onPress,
          child: const Text('View All',
              style: TextStyle(fontSize: 13, color: AppColors.red)),
        ),
      ],
    );
  }

  Widget _nextAppointmentCard() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFB00000),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage('assets/images/patient.png'),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Chisom Chukwukwe',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                  SizedBox(height: 2),
                  Text('Video Call', style: TextStyle(color: Colors.white70)),
                ],
              ),
              const Spacer(),
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                    color: Colors.white24, shape: BoxShape.circle),
                child: const Icon(Icons.videocam, color: Colors.white),
              )
            ],
          ),
          const Divider(color: Colors.white24, height: 24),
          Row(
            children: const [
              Expanded(
                child: _Info(label: 'Date', value: 'Monday May 3rd'),
              ),
              Expanded(
                child: _Info(label: 'Time', value: '09:00 AM - 09:30AM'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SpecialistHomeScreen._outlinedButton(
                  'Re-Schedule',
                  Colors.white,
                  AppColors.red,
                  onTap: () => context.goNextScreen(
                    AppRoutes.rescheduleOnSpecialist,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SpecialistHomeScreen._filledButton(
                  'View Profile',
                  Colors.white24,
                  onTap: () {
                    context.goNextScreen(AppRoutes.patientProfileOnSpecialist);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _requestCard() {
    return GestureDetector(
      onTap: () {
        context.goNextScreenWithData(AppRoutes.specialistAppointDetailScreen,
            extra: AppConstants.appointmentRequest);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/patient.png'),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('James Adebayo',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.videocam, size: 14),
                        SizedBox(width: 4),
                        Text('Video Call • Tomorrow, 2:00 PM',
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: SpecialistHomeScreen._filledButton(
                    'Confirm',
                    AppColors.green,
                    onTap: () {
                      showThankYouDialog(context,
                          title: "Appointment confirm",
                          message:
                              "The appointment has been confirmed and the user has been notified",
                          buttonText: "Done", onContinue: () {
                        context.goNextScreenWithData(
                            AppRoutes.specialistAppointDetailScreen,
                            extra: AppConstants.appointmentRequest);
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SpecialistHomeScreen._outlinedButton(
                    'Re-schedule',
                    AppColors.backgroundGray,
                    AppColors.red,
                    onTap: () => context.goNextScreen(
                      AppRoutes.rescheduleOnSpecialist,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget upcomingCard() {
    return GestureDetector(
      onTap: () {
        context.goNextScreenWithData(AppRoutes.specialistAppointDetailScreen,
            extra: AppConstants.upcomingAppointment);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Row(
              children: const [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/patient.png'),
                ),
                SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('James Adebayo',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.videocam, size: 14),
                      SizedBox(width: 4),
                      Text('Video Call • Tomorrow, 2:00 PM',
                          style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ])
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: SpecialistHomeScreen._filledButton(
                    'Re-Schedule',
                    AppColors.red,
                    onTap: () => context.goNextScreen(
                      AppRoutes.rescheduleOnSpecialist,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SpecialistHomeScreen._outlinedButton(
                    'Cancel',
                    const Color(0xFFFDECEC),
                    AppColors.red,
                    onTap: () {
                      showConfirmDialog(
                        context,
                        title: 'Cancel Appointment?',
                        message:
                            'Are you sure you want to cancel this appointment? You won’t be able to undo this action.',
                        confirmText: 'Yes, Cancel Appointment',
                        cancelText: 'Keep Appointment',
                        icon: Icons.question_mark,
                        onConfirm: () {
                          SnackBarUtils.showInfo(context, "In progress");
                        },
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _activityItem(
      {required IconData icon,
      required Color color,
      required String title,
      required String time}) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: color.withOpacity(.15), shape: BoxShape.circle),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(time,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final String label;
  final String value;

  const _Info({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
