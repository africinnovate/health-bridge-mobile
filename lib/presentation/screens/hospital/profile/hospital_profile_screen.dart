import 'dart:io';

import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/providers/hospital_provider.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/dialog.dart';
import '../../../../core/utils/url_utils.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/blood_request_provider.dart';

class HospitalProfileScreen extends StatefulWidget {
  const HospitalProfileScreen({super.key});

  @override
  State<HospitalProfileScreen> createState() => _HospitalProfileScreenState();
}

class _HospitalProfileScreenState extends State<HospitalProfileScreen> {
  File? _pickedImage;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _showPhotoOptions() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.red),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.red),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked =
        await _imagePicker.pickImage(source: source, imageQuality: 80);
    if (picked == null) return;

    setState(() => _pickedImage = File(picked.path));

    final profile = context.read<HospitalProvider>().hospitalProfile;
    if (profile == null) return;

    if (!mounted) return;
    context.showLoadingDialog();

    final (_, error) = await context
        .read<HospitalProvider>()
        .uploadHospitalImage(picked.path, profile.id);

    if (!mounted) return;
    context.hideLoadingDialog();

    if (error != null) {
      SnackBarUtils.showError(context, error);
      setState(() => _pickedImage = null);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<HospitalProvider>();
      if (provider.hospitalProfile == null) {
        provider.getHospitalProfile();
      }
    });
  }

  String _displayBloodType(String api) {
    const map = {
      'apositive': 'A+',
      'anegative': 'A-',
      'bpositive': 'B+',
      'bnegative': 'B-',
      'abpositive': 'AB+',
      'abnegative': 'AB-',
      'opositive': 'O+',
      'onegative': 'O-',
    };
    return map[api] ?? api;
  }

  Color _bloodTypeColor(String displayType) {
    if (displayType.startsWith('AB')) return const Color(0xFF3B82F6);
    if (displayType.startsWith('A')) return AppColors.red;
    if (displayType.startsWith('B')) return AppColors.green;
    return AppColors.aPlusAndABPlus;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HospitalProvider>();
    final profile = provider.hospitalProfile;

    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              /// Title
              const Text(
                'Hospital Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              /// Hospital Image & Name
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: profile?.profileImage != null
                              ? () => context.goNextScreenWithData(
                                    AppRoutes.fullImageView,
                                    extra: {
                                      'imageUrl': profile!.profileImage!,
                                      'title': profile.name,
                                    },
                                  )
                              : null,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              color: AppColors.red,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: _pickedImage != null
                                    ? FileImage(_pickedImage!) as ImageProvider
                                    : profile?.profileImage != null
                                        ? NetworkImage(profile!.profileImage!)
                                        : const AssetImage(
                                            'assets/images/patient.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: GestureDetector(
                            onTap: _showPhotoOptions,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.red,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      profile?.name ?? '—',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      profile?.hospitalType ?? '—',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: profile?.licenseStatus == true
                            ? const Color(0xFFDCFCE7)
                            : const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        profile?.licenseStatus == true ? 'Verified' : 'Pending',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: profile?.licenseStatus == true
                              ? AppColors.green
                              : const Color(0xFFD97706),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              /// Contact & License Information (one section, one edit button)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contact Information',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    _infoRow(
                      Icons.location_on_outlined,
                      'Address',
                      '${profile?.address ?? '—'}, ${profile?.city ?? ''}, ${profile?.country ?? ''}',
                    ),
                    const SizedBox(height: 16),
                    _infoRow(
                      Icons.phone_outlined,
                      'Phone Number',
                      profile?.primaryPhone ?? '—',
                    ),
                    const SizedBox(height: 16),
                    _infoRow(
                      Icons.email_outlined,
                      'Email Address',
                      profile?.email ?? '—',
                    ),
                    if (profile?.emergencyPhone?.isNotEmpty == true) ...[
                      const SizedBox(height: 16),
                      _infoRow(
                        Icons.emergency_outlined,
                        'Emergency Hotline',
                        profile!.emergencyPhone!,
                      ),
                    ],
                    const Divider(height: 32),
                    const Text(
                      'License Information',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    _infoRow(
                      Icons.description_outlined,
                      'Registration Number',
                      profile?.licenseNumber ?? '—',
                    ),
                    const SizedBox(height: 16),
                    _statusRow(
                      Icons.verified_outlined,
                      'License Status',
                      profile?.licenseStatus == true ? 'Active' : 'Pending',
                      profile?.licenseStatus == true,
                    ),
                    if (profile?.accreditationDocUrl?.isNotEmpty == true) ...[
                      const SizedBox(height: 16),
                      _documentRow(
                        Icons.insert_drive_file_outlined,
                        'License Document',
                        'View Document',
                        profile!.accreditationDocUrl!,
                      ),
                    ],
                    const SizedBox(height: 20),
                    _editButton(),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              /// Blood Services
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Blood Services',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    _statusRow(
                      Icons.bloodtype_outlined,
                      'Blood Bank Status',
                      profile?.hasBloodBank == true ? 'Active' : 'Inactive',
                      profile?.hasBloodBank == true,
                    ),
                    if (profile?.hasBloodBank == true &&
                        profile!.bloodInventory.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.verified_outlined,
                            size: 20,
                            color: Color(0xFF6B7280),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Available Blood Types',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: profile.bloodInventory.map((inv) {
                                    final display =
                                        _displayBloodType(inv.bloodType);
                                    return _bloodTypeBadge(
                                        display, _bloodTypeColor(display));
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (profile?.donatingOperatingHours.isNotEmpty == true) ...[
                      const SizedBox(height: 16),
                      _infoRow(
                        Icons.access_time_outlined,
                        'Donation Hours',
                        profile!.donatingOperatingHours,
                      ),
                    ],
                    const SizedBox(height: 20),
                    _editServicesButton(),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              /// Account Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Text(
                        'Account',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    _menuItem(
                      Icons.lock_outline,
                      'Change Password',
                      Icons.chevron_right,
                      () => context.push(AppRoutes.changePassword),
                    ),
                    const Divider(height: 1),
                    _menuItem(
                      Icons.notifications,
                      'Notification',
                      Icons.chevron_right,
                      () => context.push(AppRoutes.notificationsHospital,
                          extra: true),
                      // unused - notificationsSettings
                    ),
                    const Divider(height: 1),
                    _menuItem(
                      Icons.description_outlined,
                      'Terms & Conditions',
                      Icons.chevron_right,
                      () => UrlUtils.openTerms(context),
                    ),
                    const Divider(height: 1),
                    _menuItem(
                      Icons.shield_outlined,
                      'Privacy Policy',
                      Icons.chevron_right,
                      () => UrlUtils.openPrivacyPolicy(context),
                    ),
                    const Divider(height: 1),
                    _menuItem(
                      Icons.delete,
                      'Delete Account',
                      Icons.chevron_right,
                      () => showDeleteAccountDialog(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              /// Logout Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                  onPressed: _showLogoutDialog,
                  text: 'Log Out',
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  /// Show logout confirmation dialog
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Log Out',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              await _performLogout();
            },
            child: const Text(
              'Log Out',
              style:
                  TextStyle(color: AppColors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  /// Perform logout - call API and clear storage
  Future<void> _performLogout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Show loading
    context.showLoadingDialog();

    try {
      // Call logout API (also clears SecureStorage)
      final error = await authProvider.logout();

      if (error != null) {
        if (!mounted) return;
        SnackBarUtils.showError(context, error);
        authProvider.setIsLoadingToFalse();
        return;
      }

      // Clear cached blood request data so it doesn't leak to the next session
      if (mounted) {
        context.read<BloodRequestProvider>().clearRequests();
      }

      // Success - navigate to login screen
      if (!mounted) return;

      // Navigate to login and clear navigation stack
      context.go(AppRoutes.login);
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showError(context, "An error occurred during logout");
      context.hideLoadingDialog();
    }
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF6B7280)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              const SizedBox(height: 4),
              Text(value,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF111827))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusRow(IconData icon, String label, String status, bool active) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF6B7280)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              const SizedBox(height: 4),
              Text(status,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color:
                          active ? AppColors.green : const Color(0xFFD97706))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _documentRow(
      IconData icon, String label, String linkText, String url) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF6B7280)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => context.push(AppRoutes.documentViewer, extra: url),
                child: Text(
                  linkText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bloodTypeBadge(String type, Color color) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Center(
        child: Text(
          type,
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _editButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () =>
            context.push(AppRoutes.setProfileHospital, extra: true),
        style: TextButton.styleFrom(
          backgroundColor: AppColors.backgroundGray,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Edit',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary),
        ),
      ),
    );
  }

  Widget _editServicesButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () =>
            context.push(AppRoutes.bloodServiceHospital, extra: true),
        style: TextButton.styleFrom(
          backgroundColor: AppColors.backgroundGray,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Edit Services',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary),
        ),
      ),
    );
  }

  Widget _menuItem(IconData leadingIcon, String title, IconData trailingIcon,
      VoidCallback onTap) {
    return ListTile(
      leading: Icon(leadingIcon, color: const Color(0xFF6B7280), size: 22),
      title: Text(title,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF111827))),
      trailing: Icon(trailingIcon, color: const Color(0xFF9CA3AF), size: 20),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}
