import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/data/models/donor/donor_model.dart';
import 'package:HealthBridge/presentation/providers/hospital_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonorProfileScreen extends StatefulWidget {
  final DonorModel donor;

  const DonorProfileScreen({super.key, required this.donor});

  @override
  State<DonorProfileScreen> createState() => _DonorProfileScreenState();
}

class _DonorProfileScreenState extends State<DonorProfileScreen> {
  late TextEditingController _noteController;
  String? _updatedNote;
  bool? _updatedEligible;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDonorData();
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _loadDonorData() {
    final hospitalProvider = context.read<HospitalProvider>();
    hospitalProvider.loadDonorData(widget.donor.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: Column(
        children: [
          /// Header
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: 16,
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.goBack(),
                    child: Container(
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          'Donor Profile',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),

                  /// Profile Container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        /// Avatar
                        widget.donor.imageUrl != null &&
                                widget.donor.imageUrl!.isNotEmpty
                            ? ClipOval(
                                child: Image.network(
                                  widget.donor.imageUrl!,
                                  width: 160,
                                  height: 160,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildInitialsAvatar(
                                        widget.donor.initials);
                                  },
                                ),
                              )
                            : _buildInitialsAvatar(widget.donor.initials),
                        const SizedBox(height: 16),

                        /// Blood Type Badge
                        if (widget.donor.bloodType != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.donor.formattedBloodType,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.red,
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),

                        /// Donor Name
                        Text(
                          widget.donor.fullName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        /// Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: (_updatedEligible ?? widget.donor.eligibleToDonate)
                                ? const Color(0xFFDCFCE7)
                                : const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            (_updatedEligible ?? widget.donor.eligibleToDonate)
                                ? 'Eligible to Donate'
                                : 'Ineligible to Donate',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: (_updatedEligible ?? widget.donor.eligibleToDonate)
                                  ? const Color(0xFF059669)
                                  : const Color(0xFFF59E0B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  /// Contact Information Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Contact Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Contact Information Container
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        /// Phone Number
                        if (widget.donor.phone != null &&
                            widget.donor.phone!.isNotEmpty)
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6B7280),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Phone Number',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF9CA3AF),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      widget.donor.phone!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        if (widget.donor.phone != null &&
                            widget.donor.phone!.isNotEmpty &&
                            widget.donor.email != null &&
                            widget.donor.email!.isNotEmpty)
                          const SizedBox(height: 20),

                        /// Email Address
                        if (widget.donor.email != null &&
                            widget.donor.email!.isNotEmpty)
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6B7280),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.email,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Email Address',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF9CA3AF),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      widget.donor.email!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                        /// Show message if no contact info
                        if ((widget.donor.phone == null ||
                                widget.donor.phone!.isEmpty) &&
                            (widget.donor.email == null ||
                                widget.donor.email!.isEmpty))
                          const Text(
                            'No contact information available',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  /// Donation History Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Donation History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Stats Cards
                  Consumer<HospitalProvider>(
                    builder: (context, hospitalProvider, _) {
                      if (hospitalProvider.isDonorDataLoading) {
                        return const Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final stats = hospitalProvider.donorStats;
                      final history = hospitalProvider.donorHistory;

                      // Get last donation from history (most recent completed donation)
                      final completedDonations = history
                          .where((h) => h.isCompleted && h.date != null)
                          .toList();

                      completedDonations
                          .sort((a, b) => b.date!.compareTo(a.date!));

                      final lastDonation = completedDonations.isNotEmpty
                          ? completedDonations.first
                          : null;

                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        stats?.totalDonations.toString() ?? '0',
                                        style: const TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.red,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Total Donations',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        stats?.formattedVolume ?? '0.0L',
                                        style: const TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.red,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Total Volume',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          /// Last Donation
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Last Donation',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  lastDonation?.formattedDate ??
                                      'No donations yet',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  /// View Full History Button
                  Consumer<HospitalProvider>(
                    builder: (context, hospitalProvider, _) {
                      return GestureDetector(
                        onTap: () {
                          // Pass donor and history data to the donation history screen
                          context.goNextScreenWithData(
                            AppRoutes.hospitalDonationHistory,
                            extra: {
                              'donor': widget.donor,
                              'history': hospitalProvider.donorHistory,
                              'stats': hospitalProvider.donorStats,
                            },
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCEEFE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'View Full History',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blue,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: AppColors.blue,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  /// Hospital Notes Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Hospital Notes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  /// Notes Container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      (_updatedNote ?? widget.donor.note) != null &&
                              (_updatedNote ?? widget.donor.note)!.isNotEmpty
                          ? (_updatedNote ?? widget.donor.note)!
                          : 'No notes available for this donor.',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Edit Notes and Eligibility Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        _showEditDonorBottomSheet();
                      },
                      child: const Text(
                        'Edit Notes and Eligibility',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blue,
                        ),
                      ),
                    ),
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

  Widget _buildInitialsAvatar(String initials) {
    return Container(
      width: 160,
      height: 160,
      decoration: const BoxDecoration(
        color: Color(0xFF2563EB),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showEditDonorBottomSheet() {
    _noteController.text = widget.donor.note ?? '';
    bool isEligible = widget.donor.eligibleToDonate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (builderContext, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(builderContext).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Edit Donor Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(modalContext),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    /// Eligibility Toggle
                    const Text(
                      'Eligibility Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEligible
                                    ? 'Eligible to Donate'
                                    : 'Ineligible to Donate',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isEligible
                                    ? 'Donor can donate blood'
                                    : 'Donor cannot donate blood',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: isEligible,
                            activeColor: const Color(0xFF059669),
                            onChanged: (value) {
                              setModalState(() {
                                isEligible = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// Notes Field
                    const Text(
                      'Hospital Notes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _noteController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Add notes about this donor...',
                        hintStyle: const TextStyle(
                          color: Color(0xFF9CA3AF),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF3F4F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          FocusScope.of(builderContext).unfocus();

                          final note = _noteController.text.trim();
                          final eligible = isEligible;

                          Navigator.pop(modalContext);

                          _updateDonorDetails(note, eligible);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _updateDonorDetails(String note, bool isEligible) async {
    if (!mounted) return;

    context.showLoadingDialog();

    final payload = {
      'note': note.isNotEmpty ? note : null,
      'eligible_to_donate': isEligible,
    };

    final hospitalProvider = context.read<HospitalProvider>();
    final error = await hospitalProvider.updateDonor(
      widget.donor.userId,
      payload,
    );

    if (!mounted) return;

    if (error == null) {
      // Update successful - reload donor data while loading dialog is still visible
      // This keeps the overlay system stable
      await Future.wait([
        hospitalProvider.getDonorStats(widget.donor.userId),
        hospitalProvider.getDonorHistory(widget.donor.userId),
      ]);

      // Update local display values
      _updatedNote = note.isNotEmpty ? note : null;
      _updatedEligible = isEligible;
    }

    if (!mounted) return;

    context.hideLoadingDialog();

    if (error == null) {
      if (mounted) {
        // Update UI to reflect new values
        setState(() {});
        SnackBarUtils.showSuccess(context, 'Donor updated successfully');
      }
    } else {
      if (mounted) {
        SnackBarUtils.showError(context, error);
      }
    }
  }
}
