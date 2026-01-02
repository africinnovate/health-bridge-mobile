import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class BloodInventoryScreen extends StatefulWidget {
  const BloodInventoryScreen({super.key});

  @override
  State<BloodInventoryScreen> createState() => _BloodInventoryScreenState();
}

class _BloodInventoryScreenState extends State<BloodInventoryScreen> {
  final Map<String, Map<String, dynamic>> bloodInventory = {
    'A+': {
      'units': 18,
      'color': AppColors.aPlusAndABPlus,
      'status': 'Safe Levels'
    },
    'A-': {
      'units': 18,
      'color': const Color(0xFF5B6B9D),
      'status': 'Safe Levels'
    },
    'B+': {'units': 18, 'color': AppColors.red, 'status': 'Safe Levels'},
    'B-': {'units': 4, 'color': AppColors.red, 'status': 'Low Stock'},
    'AB+': {
      'units': 18,
      'color': AppColors.aPlusAndABPlus,
      'status': 'Safe Levels'
    },
    'AB-': {
      'units': 18,
      'color': const Color(0xFF5B6B9D),
      'status': 'Safe Levels'
    },
    'O+': {'units': 18, 'color': AppColors.green, 'status': 'Safe Levels'},
    'O-': {'units': 2, 'color': AppColors.green, 'status': 'Critical'},
  };

  @override
  Widget build(BuildContext context) {
    final totalUnits = bloodInventory.values
        .fold(0, (sum, item) => sum + (item['units'] as int));
    final totalTypes = bloodInventory.length;
    final lowStockCount = bloodInventory.values
        .where((item) =>
            item['status'] == 'Low Stock' || item['status'] == 'Critical')
        .length;

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
                  final entry = bloodInventory.entries.elementAt(index);
                  return _buildBloodTypeCard(
                    entry.key,
                    entry.value['units'],
                    entry.value['color'],
                    entry.value['status'],
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

  Widget _buildBloodTypeCard(
      String bloodType, int units, Color color, String status) {
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
        context.goNextScreenWithData(AppRoutes.updateUnits, extra: bloodType);
      },
      child: Container(
        // padding: const EdgeInsets.all(12),
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
