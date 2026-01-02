import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class NewBloodRequestScreen extends StatefulWidget {
  const NewBloodRequestScreen({super.key});

  @override
  State<NewBloodRequestScreen> createState() => _NewBloodRequestScreenState();
}

class _NewBloodRequestScreenState extends State<NewBloodRequestScreen> {
  String? selectedBloodType;
  int unitsNeeded = 5;
  String urgencyLevel = 'Instant';
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime? selectedDateTime;

  final bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  void dispose() {
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(
        title: 'New Blood Request',
        showArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Blood Type
            const Text(
              'Blood Type',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildBloodTypeSelector(),
            const SizedBox(height: 24),

            /// Units Needed
            const Text(
              'Units Needed',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildUnitsSelector(),
            const SizedBox(height: 24),

            /// Urgency Level
            const Text(
              'Urgency Level',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildUrgencySelector(),
            const SizedBox(height: 24),

            /// Reason for Request
            const Text(
              'Reason for Request',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _reasonController,
              decoration: InputDecoration(
                hintText: 'e.g emergency surgery, patient blood loss',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9CA3AF),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.red),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 24),

            /// Preferred/Fulfillment Time
            const Text(
              'Preferred/Fulfillment Time',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                final DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  final TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() {
                      selectedDateTime = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );
                    });
                  }
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDateTime == null
                          ? 'mm/dd/yy'
                          : '${selectedDateTime!.month}/${selectedDateTime!.day}/${selectedDateTime!.year}',
                      style: TextStyle(
                        fontSize: 14,
                        color: selectedDateTime == null
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF374151),
                      ),
                    ),
                    const Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: Color(0xFF9CA3AF),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                final TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  setState(() {
                    if (selectedDateTime != null) {
                      selectedDateTime = DateTime(
                        selectedDateTime!.year,
                        selectedDateTime!.month,
                        selectedDateTime!.day,
                        time.hour,
                        time.minute,
                      );
                    } else {
                      final now = DateTime.now();
                      selectedDateTime = DateTime(
                        now.year,
                        now.month,
                        now.day,
                        time.hour,
                        time.minute,
                      );
                    }
                  });
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDateTime == null
                          ? 'When do you need the blood units?'
                          : '${selectedDateTime!.hour}:${selectedDateTime!.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 14,
                        color: selectedDateTime == null
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF374151),
                      ),
                    ),
                    const Icon(
                      Icons.access_time,
                      size: 20,
                      color: Color(0xFF9CA3AF),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            /// Additional Notes
            const Text(
              'Additional Notes (Optional)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Any specific requirements',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9CA3AF),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.red),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 32),

            /// Continue Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomButton(
                onPressed: () {
                  SnackBarUtils.showSuccess(context, "Request submitted");
                },
                text: 'Continue',
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildBloodTypeSelector() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.8,
      ),
      itemCount: bloodTypes.length,
      itemBuilder: (context, index) {
        final bloodType = bloodTypes[index];
        final isSelected = selectedBloodType == bloodType;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedBloodType = bloodType;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.red : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? AppColors.red : const Color(0xFFE5E7EB),
              ),
            ),
            child: Center(
              child: Text(
                bloodType,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF374151),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUnitsSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              if (unitsNeeded > 1) {
                setState(() {
                  unitsNeeded--;
                });
              }
            },
            icon: const Icon(Icons.remove, size: 20),
            color: const Color(0xFF6B7280),
          ),
          Text(
            unitsNeeded.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                unitsNeeded++;
              });
            },
            icon: const Icon(Icons.add, size: 20),
            color: const Color(0xFF6B7280),
          ),
        ],
      ),
    );
  }

  Widget _buildUrgencySelector() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                urgencyLevel = 'Instant';
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: urgencyLevel == 'Instant' ? AppColors.red : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: urgencyLevel == 'Instant'
                      ? AppColors.red
                      : const Color(0xFFE5E7EB),
                ),
              ),
              child: Text(
                'Instant',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: urgencyLevel == 'Instant'
                      ? Colors.white
                      : const Color(0xFF374151),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                urgencyLevel = 'Urgent';
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: urgencyLevel == 'Urgent' ? AppColors.red : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: urgencyLevel == 'Urgent'
                      ? AppColors.red
                      : const Color(0xFFE5E7EB),
                ),
              ),
              child: Text(
                'Urgent',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: urgencyLevel == 'Urgent'
                      ? Colors.white
                      : const Color(0xFF374151),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
