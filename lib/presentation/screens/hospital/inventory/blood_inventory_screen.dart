import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/data/models/hospital/hospital_model.dart';
import 'package:HealthBridge/presentation/providers/hospital_provider.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BloodInventoryScreen extends StatefulWidget {
  const BloodInventoryScreen({super.key});

  @override
  State<BloodInventoryScreen> createState() => _BloodInventoryScreenState();
}

class _BloodInventoryScreenState extends State<BloodInventoryScreen> {
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
        return AppColors.red;
    }
  }

  String _getStockStatus(int unitsAvailable, int bankCapacity) {
    if (bankCapacity == 0) return 'Safe Levels';
    final percentage = (unitsAvailable / bankCapacity) * 100;
    if (percentage < 20) return 'Critical';
    if (percentage < 40) return 'Low Stock';
    return 'Safe Levels';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HospitalProvider>(
      builder: (context, hospitalProvider, _) {
        final bloodInventory = hospitalProvider.hospitalProfile?.bloodInventory ?? [];

        final totalUnits = bloodInventory.fold(0, (sum, item) => sum + item.unitsAvailable);
        final totalTypes = bloodInventory.length;
        final lowStockCount = bloodInventory.where((item) {
          final status = _getStockStatus(item.unitsAvailable, item.bankCapacity);
          return status == 'Low Stock' || status == 'Critical';
        }).length;

        return Scaffold(
          appBar: CustomAppBar(
            title: "Blood Inventory",
            showArrow: false,
          ),
          backgroundColor: AppColors.backgroundGray,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Summary Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        /// Total Units Available
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Units Available',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            Text(
                              '$totalUnits units',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        /// Blood Types in Stock
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Blood Types in Stock',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            Text(
                              '$totalTypes types',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        /// Warning Banner
                        if (lowStockCount > 0) ...[
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$lowStockCount types below safe levels',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFF59E0B),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// Blood Type Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemCount: bloodInventory.length,
                    itemBuilder: (context, index) {
                      final item = bloodInventory[index];
                      return _buildBloodTypeCard(item);
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBloodTypeCard(BloodInventory item) {
    final bloodType = _formatBloodType(item.bloodType);
    final units = item.unitsAvailable;
    final color = _getBloodTypeColor(item.bloodType);
    final status = _getStockStatus(item.unitsAvailable, item.bankCapacity);

    // Determine status badge color
    Color statusBgColor;
    Color statusTextColor;

    if (status == 'Critical') {
      statusBgColor = const Color(0xFFFEE2E2);
      statusTextColor = AppColors.red;
    } else if (status == 'Low Stock') {
      statusBgColor = const Color(0xFFFEF3C7);
      statusTextColor = const Color(0xFFF59E0B);
    } else {
      // Safe Levels
      statusBgColor = const Color(0xFFDCFCE7);
      statusTextColor = AppColors.green;
    }

    return GestureDetector(
      onTap: () {
        context.goNextScreenWithData(AppRoutes.updateUnits, extra: item.bloodType);
      },
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Blood Type Circle
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  bloodType,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            /// Units
            Text(
              '$units units',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            /// Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: statusBgColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: statusTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
