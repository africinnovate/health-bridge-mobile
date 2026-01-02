import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class UpdateUnitsScreen extends StatefulWidget {
  final String bloodType;

  const UpdateUnitsScreen({super.key, this.bloodType = 'A-'});

  @override
  State<UpdateUnitsScreen> createState() => _UpdateUnitsScreenState();
}

class _UpdateUnitsScreenState extends State<UpdateUnitsScreen> {
  int newUnitCount = 5;

  @override
  Widget build(BuildContext context) {
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
              decoration: const BoxDecoration(
                color: Color(0xFF3B82F6),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.bloodType,
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
            const Text(
              '18 units',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Units updated 4 days ago',
              style: TextStyle(
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
                onPressed: () {
                  _showSuccessDialog();
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
