import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/data/models/appointment/appointment_model.dart';
import 'package:HealthBridge/data/models/specialist/patient_profile_for_specialist_model.dart';
import 'package:HealthBridge/presentation/providers/specialist_provider.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PatientProfileOnSpecialScreen extends StatefulWidget {
  final AppointmentModel? appointment;

  const PatientProfileOnSpecialScreen({super.key, this.appointment});

  @override
  State<PatientProfileOnSpecialScreen> createState() =>
      _PatientProfileOnSpecialScreenState();
}

class _PatientProfileOnSpecialScreenState
    extends State<PatientProfileOnSpecialScreen> {
  PatientProfileForSpecialistModel? _patientData;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadPatientProfile());
  }

  Future<void> _loadPatientProfile() async {
    final userId = widget.appointment?.userId;
    if (userId == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final (data, error) = await context
        .read<SpecialistProvider>()
        .getPatientProfileForSpecialist(userId);

    if (mounted) {
      setState(() {
        _patientData = data;
        _error = error;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.appointment == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundGray,
        appBar: const CustomAppBar(title: "Patient Profile"),
        body: const Center(child: Text('No patient data available')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(title: "Patient Profile"),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : RefreshIndicator(
                  onRefresh: _loadPatientProfile,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _ProfileHeader(
                            patientData: _patientData,
                            appointment: widget.appointment!),
                        const SizedBox(height: 16),
                        _BasicInfoCard(
                            patientData: _patientData,
                            appointment: widget.appointment!),
                        const SizedBox(height: 16),
                        _MedicalInfoCard(patientData: _patientData),
                        const SizedBox(height: 16),
                        if (_patientData != null &&
                            _patientData!.appointments.isNotEmpty)
                          _ConsultationHistoryCard(
                              appointments: _patientData!.appointments),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final PatientProfileForSpecialistModel? patientData;
  final AppointmentModel appointment;

  const _ProfileHeader({required this.patientData, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final profile = patientData?.profile;
    final name = profile?.fullName ??
        '${appointment.userFirstName ?? 'Patient'} ${appointment.userLastName ?? ''}'
            .trim();
    final imageUrl = profile?.imageUrl ?? appointment.userImageUrl;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.deepOrange,
            child: ClipOval(
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: 96,
                      height: 96,
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/images/patient.png',
                        fit: BoxFit.cover,
                        width: 96,
                        height: 96,
                      ),
                    )
                  : Image.asset(
                      'assets/images/patient.png',
                      fit: BoxFit.cover,
                      width: 96,
                      height: 96,
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (profile?.age != null)
                _Tag(
                    text: '${profile!.age} years',
                    color: const Color(0xFFE0F2FE),
                    textColor: Colors.blue),
              if (profile?.gender != null)
                _Tag(
                    text: profile!.gender!,
                    color: const Color(0xFFE8F5E9),
                    textColor: AppColors.green),
              if (profile?.bloodType != null)
                _Tag(
                    text: profile!.bloodType!,
                    color: const Color(0xFFFDECEC),
                    textColor: AppColors.red),
            ],
          ),
        ],
      ),
    );
  }
}

class _BasicInfoCard extends StatelessWidget {
  final PatientProfileForSpecialistModel? patientData;
  final AppointmentModel appointment;

  const _BasicInfoCard({required this.patientData, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final profile = patientData?.profile;
    final name = profile?.fullName ??
        '${appointment.userFirstName ?? 'Patient'} ${appointment.userLastName ?? ''}'
            .trim();
    final phone = profile?.phone ?? appointment.userPhone ?? 'Not available';
    final email = profile?.email ?? 'Not available';
    final address = [profile?.address, profile?.city, profile?.state]
        .where((e) => e != null && e.isNotEmpty)
        .join(', ');

    return _SectionCard(
      title: 'Basic Information',
      children: [
        _InfoTile(icon: Icons.person, label: 'Name', value: name),
        if (profile?.age != null)
          _InfoTile(
              icon: Icons.cake, label: 'Age', value: '${profile!.age} years'),
        if (profile?.gender != null)
          _InfoTile(
              icon: Icons.group, label: 'Gender', value: profile!.gender!),
        // _InfoTile(
        //   icon: Icons.call,
        //   label: 'Contact',
        //   value: phone,
        //   valueColor: Colors.blue,
        // ),
        // _InfoTile(icon: Icons.email_outlined, label: 'Email', value: email),
        // if (address.isNotEmpty)
        //   _InfoTile(icon: Icons.location_on_outlined, label: 'Address', value: address),
        // if (profile?.emergencyContactName != null)
        //   _InfoTile(
        //     icon: Icons.emergency_outlined,
        //     label: 'Emergency Contact',
        //     value: '${profile!.emergencyContactName} (${profile.emergencyContactPhone ?? 'N/A'})',
        //   ),
      ],
    );
  }
}

class _MedicalInfoCard extends StatelessWidget {
  final PatientProfileForSpecialistModel? patientData;

  const _MedicalInfoCard({required this.patientData});

  @override
  Widget build(BuildContext context) {
    final profile = patientData?.profile;

    return _SectionCard(
      title: 'Medical Information',
      children: [
        _InfoTile(
          icon: Icons.bloodtype_outlined,
          label: 'Blood Type',
          value: profile?.bloodType ?? 'Not available',
        ),
        _InfoTile(
          icon: Icons.warning_amber_rounded,
          label: 'Allergies',
          value: profile?.allergies ?? 'Not available',
        ),
        _InfoTile(
          icon: Icons.add_box_outlined,
          label: 'Existing Conditions',
          value: profile?.existingConditions ?? 'Not available',
        ),
        _InfoTile(
          icon: Icons.sick_outlined,
          label: 'Chronic Illnesses',
          value: profile?.chronicIllnesses ?? 'Not available',
        ),
        _InfoTile(
          icon: Icons.monitor_heart_outlined,
          label: 'Medications',
          value: profile?.medications ?? 'Not available',
        ),
        if (profile?.medicalNotes != null && profile!.medicalNotes!.isNotEmpty)
          _InfoTile(
            icon: Icons.notes_outlined,
            label: 'Medical Notes',
            value: profile.medicalNotes!,
          ),
        if (profile?.primaryPhysician != null)
          _InfoTile(
            icon: Icons.local_hospital_outlined,
            label: 'Primary Physician',
            value: profile!.primaryPhysician!,
          ),
        if (profile?.hmoNumber != null && profile!.hmoNumber!.isNotEmpty)
          _InfoTile(
            icon: Icons.badge_outlined,
            label: 'HMO Number',
            value: profile.hmoNumber!,
          ),
      ],
    );
  }
}

class _ConsultationHistoryCard extends StatelessWidget {
  final List<PatientAppointmentSummary> appointments;

  const _ConsultationHistoryCard({required this.appointments});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Consultation History',
      children: appointments.take(3).map((apt) {
        String formattedDate = 'N/A';
        try {
          if (apt.scheduledTime != null) {
            formattedDate = DateFormat('MMM d, yyyy')
                .format(DateTime.parse(apt.scheduledTime!));
          }
        } catch (_) {}

        final consultationType =
            apt.specialty ?? apt.specialistName ?? 'Consultation';
        final statusText = '${apt.status ?? 'Unknown'}';

        return _HistoryTile(
          icon: Icons.calendar_today,
          title: consultationType,
          date: '$formattedDate • $statusText',
        );
      }).toList(),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(
                  value,
                  style:
                      TextStyle(fontWeight: FontWeight.w600, color: valueColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;

  const _HistoryTile({
    required this.icon,
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(date,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const _Tag({
    required this.text,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: TextStyle(color: textColor, fontSize: 12)),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
  );
}
