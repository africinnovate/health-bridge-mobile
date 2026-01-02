import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class PatientProfileOnSpecialScreen extends StatelessWidget {
  const PatientProfileOnSpecialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: CustomAppBar(title: "Patient Profile"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            _ProfileHeader(),
            SizedBox(height: 16),
            _BasicInfoCard(),
            SizedBox(height: 16),
            _MedicalInfoCard(),
            SizedBox(height: 16),
            _ConsultationHistoryCard(),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.deepOrange,
            child: ClipOval(
              child: Image.network(
                'https://i.pravatar.cc/300',
                fit: BoxFit.cover,
                width: 96,
                height: 96,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Adaobi Nkemdilim',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _Tag(
                  text: '32 years',
                  color: Color(0xFFE0F2FE),
                  textColor: Colors.blue),
              _Tag(
                  text: 'Female',
                  color: Color(0xFFE8F5E9),
                  textColor: AppColors.green),
              _Tag(
                  text: 'O+',
                  color: Color(0xFFFDECEC),
                  textColor: AppColors.red),
            ],
          ),
        ],
      ),
    );
  }
}

class _BasicInfoCard extends StatelessWidget {
  const _BasicInfoCard();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Basic Information',
      children: const [
        _InfoTile(icon: Icons.person, label: 'Name', value: 'Adaobi Nkemdilim'),
        _InfoTile(icon: Icons.cake, label: 'Age', value: '32 years'),
        _InfoTile(icon: Icons.group, label: 'Gender', value: 'Female'),
        _InfoTile(
          icon: Icons.call,
          label: 'Contact',
          value: '+234 803 456 7890',
          valueColor: Colors.blue,
        ),
      ],
    );
  }
}

class _MedicalInfoCard extends StatelessWidget {
  const _MedicalInfoCard();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Medical Information',
      children: const [
        _InfoTile(
          icon: Icons.warning_amber_rounded,
          label: 'Allergies',
          value: 'Penicillin, Shellfish',
        ),
        _InfoTile(
          icon: Icons.add_box_outlined,
          label: 'Existing Conditions',
          value: 'Hypertension',
        ),
        _InfoTile(
          icon: Icons.monitor_heart_outlined,
          label: 'Medications',
          value: 'Lisinopril 10mg (Daily)',
        ),
      ],
    );
  }
}

class _ConsultationHistoryCard extends StatelessWidget {
  const _ConsultationHistoryCard();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Consultation History',
      children: const [
        _HistoryTile(
          icon: Icons.videocam,
          title: 'Video Consultation',
          date: 'March 10, 2025 • Completed',
        ),
        _HistoryTile(
          icon: Icons.call,
          title: 'Voice Call',
          date: 'February 15, 2025 • Completed',
        ),
        _HistoryTile(
          icon: Icons.videocam,
          title: 'Video Consultation',
          date: 'January 20, 2025 • Completed',
        ),
        SizedBox(height: 8),
        Center(child: Text('View All', style: TextStyle(color: Colors.grey))),
      ],
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
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Column(
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
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(date, style: const TextStyle(color: Colors.grey)),
            ],
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

BoxDecoration _cardDecoration() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    );
