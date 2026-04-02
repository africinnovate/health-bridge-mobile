import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/data/models/donor/donation_history_model.dart';
import 'package:HealthBridge/presentation/providers/hospital_provider.dart';
import 'package:HealthBridge/presentation/providers/patient_provider.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonationHistoryScreen extends StatefulWidget {
  const DonationHistoryScreen({super.key});

  @override
  State<DonationHistoryScreen> createState() => _DonationHistoryScreenState();
}

class _DonationHistoryScreenState extends State<DonationHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final patientProvider = context.read<PatientProvider>();
    context.showLoadingDialog();
    await patientProvider.getPatientOrDonorProfile();
    context.hideLoadingDialog();
    final donorId = patientProvider.patientProfileM?.id;
    if (donorId == null) return;

    await context.read<HospitalProvider>().loadDonorData(donorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(
        title: 'Donation History',
        showArrow: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Stats Section
              Consumer<HospitalProvider>(
                builder: (context, hospitalProvider, _) {
                  final stats = hospitalProvider.donorStats;
                  final totalDonations = stats?.totalDonations ?? 0;
                  final volume = stats?.formattedVolume ?? '0.0L';
                  final livesSaved = totalDonations * 3;

                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF5F5),
                      borderRadius: BorderRadius.circular(14),
                      border:
                          Border.all(color: const Color(0xFFFFE4E6), width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _statItem('$totalDonations', 'Total\nDonations',
                            AppColors.red),
                        Container(
                          width: 1,
                          height: 40,
                          color: const Color(0xFFFFE4E6),
                        ),
                        _statItem(volume, 'Volume\nDonated', AppColors.red),
                        Container(
                          width: 1,
                          height: 40,
                          color: const Color(0xFFFFE4E6),
                        ),
                        _statItem('$livesSaved', 'Lives\nSaved', AppColors.red),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              /// Donation Cards
              Consumer<HospitalProvider>(
                builder: (context, hospitalProvider, _) {
                  if (hospitalProvider.isDonorDataLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (hospitalProvider.donorHistory.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'No donation history yet. Start your donation journey!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: hospitalProvider.donorHistory
                        .asMap()
                        .entries
                        .map((entry) {
                      return Column(
                        children: [
                          _buildDonationCard(entry.value),
                          if (entry.key <
                              hospitalProvider.donorHistory.length - 1)
                            const SizedBox(height: 16),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statItem(String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6B7280),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationCard(DonationHistoryModel donation) {
    final statusColor = donation.statusColor == 'green'
        ? AppColors.green
        : donation.statusColor == 'red'
            ? Colors.red
            : Colors.orange;

    final statusLabel = donation.requestStatus.isNotEmpty
        ? donation.requestStatus[0].toUpperCase() +
            donation.requestStatus.substring(1)
        : '';

    return GestureDetector(
      onTap: () {
        context.goNextScreenWithData(AppRoutes.donationDetails,
            extra: donation);
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
            Row(
              children: [
                /// Blood drop icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.water_drop,
                    color: statusColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Blood Donation',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 13,
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Info Grid
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoItem('Date', donation.formattedDate),
                      const SizedBox(height: 12),
                      _infoItem('Units Donated', donation.formattedUnits),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoItem('Reference', donation.refId),
                      const SizedBox(height: 12),
                      _infoItem('Status', statusLabel),
                    ],
                  ),
                ),
              ],
            ),

            /// Impact Banner (only for completed donations)
            if (donation.isCompleted) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.favorite,
                      color: AppColors.green,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Your donation can save up to 3 lives',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            /// View Receipt Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  context.goNextScreenWithData(AppRoutes.donationReceipt,
                      extra: donation);
                },
                child: const Text(
                  'View Receipt',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
