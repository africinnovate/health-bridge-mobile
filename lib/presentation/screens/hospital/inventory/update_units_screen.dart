import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/data/models/hospital/hospital_model.dart';
import 'package:HealthBridge/presentation/providers/hospital_provider.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateUnitsScreen extends StatefulWidget {
  final String bloodType;

  const UpdateUnitsScreen({super.key, this.bloodType = 'A-'});

  @override
  State<UpdateUnitsScreen> createState() => _UpdateUnitsScreenState();
}

class _UpdateUnitsScreenState extends State<UpdateUnitsScreen> {
  int newUnitCount = 5;

  String _formatBloodType(String bloodType) {
    // Convert API format to display format
    switch (bloodType.toLowerCase()) {
      case 'apositive':
        return 'A+';
      case 'anegative':
        return 'A-';
      case 'bpositive':
        return 'B+';
      case 'bnegative':
        return 'B-';
      case 'opositive':
        return 'O+';
      case 'onegative':
        return 'O-';
      case 'abpositive':
        return 'AB+';
      case 'abnegative':
        return 'AB-';
      default:
        return bloodType; // Return as-is if already formatted
    }
  }

  Color _getBloodTypeColor(String bloodType) {
    final formatted = _formatBloodType(bloodType);
    switch (formatted) {
      case 'A+':
      case 'AB+':
        return AppColors.aPlusAndABPlus;
      case 'A-':
      case 'AB-':
        return const Color(0xFF5B6B9D);
      case 'B+':
      case 'B-':
        return AppColors.red;
      case 'O+':
      case 'O-':
        return AppColors.green;
      default:
        return const Color(0xFF3B82F6);
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HospitalProvider>(
      builder: (context, hospitalProvider, _) {
        final bloodInventory = hospitalProvider.hospitalProfile?.bloodInventory ?? [];
        final inventoryItem = bloodInventory.firstWhere(
          (item) => item.bloodType == widget.bloodType,
          orElse: () => BloodInventory(
            bankCapacity: 0,
            bloodType: widget.bloodType,
            hospitalId: '',
            id: '',
            unitsAvailable: 0,
            updatedAt: DateTime.now(),
          ),
        );

        // Initialize newUnitCount with current units on first build
        if (newUnitCount == 5) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              newUnitCount = inventoryItem.unitsAvailable;
            });
          });
        }

        final color = _getBloodTypeColor(widget.bloodType);
        final formattedBloodType = _formatBloodType(widget.bloodType);
        final lastUpdated = _getTimeAgo(inventoryItem.updatedAt);

        return Scaffold(
          backgroundColor: AppColors.backgroundGray,
          appBar: const CustomAppBar(
            title: 'Update Units',
            showArrow: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),

                /// Blood Type Circle
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      formattedBloodType,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                /// Current Units
                Text(
                  '${inventoryItem.unitsAvailable} units',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Units updated $lastUpdated',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 40),

            /// New Unit Count Label
            const Text(
              'New Unit Count',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            /// Counter
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      if (newUnitCount > 0) {
                        setState(() {
                          newUnitCount--;
                        });
                      }
                    },
                    icon: const Icon(Icons.remove, size: 24),
                    color: const Color(0xFF6B7280),
                  ),
                  Text(
                    newUnitCount.toString(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        newUnitCount++;
                      });
                    },
                    icon: const Icon(Icons.add, size: 24),
                    color: const Color(0xFF6B7280),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Enter the total unit currently available',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 48),

            /// Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomButton(
                onPressed: () async {
                  await _saveChanges(
                    context,
                    inventoryItem.hospitalId,
                    inventoryItem.bloodType,
                    inventoryItem.bankCapacity,
                  );
                },
                text: 'Save Changes',
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveChanges(
    BuildContext context,
    String hospitalId,
    String bloodType,
    int bankCapacity,
  ) async {
    context.showLoadingDialog();

    final hospitalProvider = context.read<HospitalProvider>();
    final error = await hospitalProvider.updateBloodInventory(
      hospitalId,
      bloodType,
      bankCapacity,
      newUnitCount,
    );

    context.hideLoadingDialog();

    if (error != null) {
      if (mounted) {
        SnackBarUtils.showError(context, error);
      }
      return;
    }

    // Show success dialog
    if (mounted) {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: AppColors.green,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Units Updated',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Inventory was reflect the adjustment',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: CustomButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                text: 'Done',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
