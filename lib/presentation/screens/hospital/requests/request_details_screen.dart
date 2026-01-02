import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/dialog.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/cancel_button.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class RequestDetailsScreen extends StatefulWidget {
  final String status; // "confirmed", "accepted", "completed", "cancelled"

  const RequestDetailsScreen({
    super.key,
    this.status = "confirmed",
  });

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(
        title: 'Request Details',
        showArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Status Badge or Icon
            if (widget.status == 'completed') ...[
              Center(
                child: Container(
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
              ),
              const SizedBox(height: 16),
            ],

            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(widget.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _getStatusText(widget.status),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(widget.status),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            /// Request Information
            if (widget.status != 'cancelled') ...[
              _buildInfoSection(),
            ] else ...[
              _buildCancelledInfoSection(),
            ],
            const SizedBox(height: 32),

            /// Updates Timeline or Cancellation Details
            if (widget.status != 'cancelled') ...[
              const Text(
                'Updates Timeline',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _buildTimeline(),
            ] else ...[
              const Text(
                'Cancellation Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _buildCancellationDetails(),
            ],
            const SizedBox(height: 32),

            /// Action Button
            if (widget.status != 'cancelled' && widget.status != 'completed')
              CancelButton(
                text: 'Cancel Request',
                onPressed: () {
                  showConfirmDialog(
                    context,
                    title: "Cancel Request",
                    message:
                        "Are you sure you want to cancel this blood request? This action cannot be undone.",
                    confirmText: "Yes, Cancel Request",
                    cancelText: "Keep Request",
                    onConfirm: () {
                      SnackBarUtils.showSuccess(context, "Request cancelled");
                      context.goBack();
                    },
                  );
                },
              )
            else if (widget.status == 'cancelled')
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                  onPressed: () {
                    context.goNextScreen(AppRoutes.newBloodRequest);
                  },
                  text: 'Create New Request',
                ),
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
      case 'accepted':
      case 'completed':
        return AppColors.green;
      case 'cancelled':
        return AppColors.red;
      default:
        return AppColors.green;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'confirmed':
        return 'Confirmed';
      case 'accepted':
        return 'Accepted';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Confirmed';
    }
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _infoRow('Blood Type:', 'O+'),
          const SizedBox(height: 16),
          _infoRow('Units Requested', '8 units'),
          const SizedBox(height: 16),
          _infoRow('Urgency:', 'Urgent'),
          const SizedBox(height: 16),
          _infoRow('Reason:', 'Emergency surgery'),
          const SizedBox(height: 16),
          _infoRow('Preferred Time:', 'Today, 3:00 PM'),
          const SizedBox(height: 16),
          _infoRow('Reference ID:', 'HB-BR-3421'),
        ],
      ),
    );
  }

  Widget _buildCancelledInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _infoRow('Blood Type:', 'O+'),
          const SizedBox(height: 16),
          _infoRow('Units Requested', '8 units'),
          const SizedBox(height: 16),
          _infoRow('Urgency:', 'Urgent'),
          const SizedBox(height: 16),
          _infoRow('Reason:', 'Emergency surgery'),
          const SizedBox(height: 16),
          _infoRow('Requested On:', '12 Feb 2025, 3:20 PM'),
          const SizedBox(height: 16),
          _infoRow('Reference ID:', 'HB-BR-3421'),
        ],
      ),
    );
  }

  Widget _buildCancellationDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _infoRow('Cancelled By:', 'Hospital Admin'),
          const SizedBox(height: 16),
          _infoRow('Cancelled On:', '12 Feb 2025, 4:45 PM'),
          const SizedBox(height: 16),
          _infoRow('Cancellation Reason:', 'Request no longer needed'),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF9CA3AF),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          if (widget.status == 'confirmed') ...[
            _timelineItem(
              isCompleted: true,
              title: 'Request Created',
              description: 'Hospital submitted this request.',
              time: '2 hours ago',
            ),
            _timelineItem(
              isCompleted: true,
              title: 'Visible to Donors',
              description: 'Nearby donors can now respond.',
              time: '1 hour ago',
            ),
            _timelineItem(
              isCompleted: false,
              number: 3,
              title: 'Request Updated',
              description: 'Units counted toward total required.',
              time: 'Pending',
            ),
          ] else if (widget.status == 'accepted') ...[
            _timelineItem(
              isCompleted: true,
              title: 'Request Created',
              description: 'Hospital submitted this request.',
              time: '2 hours ago',
            ),
            _timelineItem(
              isCompleted: true,
              title: 'Visible to Donors',
              description: 'Nearby donors can now respond.',
              time: '1 hour ago',
            ),
            _timelineItem(
              isCompleted: true,
              title: 'Donation Appointment Scheduled',
              description: 'Donor 1 set a date/time to donate.',
              time: '1 hour ago',
            ),
            _timelineItem(
              isCompleted: true,
              title: 'Donation Appointment Scheduled',
              description: 'Donor 2 set a date/time to donate.',
              time: '1 hour ago',
            ),
            _timelineItem(
              isCompleted: true,
              title: 'Donation Appointment Scheduled',
              description: 'Donor 3 set a date/time to donate.',
              time: '1 hour ago',
            ),
            _timelineItem(
              isCompleted: true,
              title: 'Donation Completed',
              description: 'Donor 1 donated 250ml successfully 600ml left',
              time: '20 mins ago',
              highlightText: '600ml',
            ),
            _timelineItem(
              isCompleted: false,
              number: 7,
              title: 'Request Updated',
              description: 'Units counted toward total required.',
              time: 'Pending',
            ),
          ] else if (widget.status == 'completed') ...[
            _timelineItem(
              isCompleted: true,
              title: 'Request Created',
              description: 'Hospital submitted this request.',
              time: '2 hours ago',
            ),
            _timelineItem(
              isCompleted: true,
              title: 'Visible to Donors',
              description: 'Nearby donors can now respond.',
              time: '1 hour ago',
            ),
            _timelineItem(
              isCompleted: true,
              title: 'Donation Appointment Scheduled',
              description: 'Donor 1 set a date/time to donate.',
              time: '1 hour ago',
            ),
            _timelineItem(
              isCompleted: true,
              title: 'Donation Appointment Scheduled',
              description: 'Donor 2 set a date/time to donate.',
              time: '1 hour ago',
            ),
            _timelineItem(
              isCompleted: true,
              title: 'Donation Appointment Scheduled',
              description: 'Donor 3 set a date/time to donate.',
              time: '1 hour ago',
            ),
            _timelineItem(
              isCompleted: true,
              title: 'Donation Completed (Donor 1)',
              description: 'Donor 1 donated 250ml successfully 600ml left',
              time: '20 mins ago',
              highlightText: '600ml',
            ),
            _timelineItem(
              isCompleted: true,
              title: 'Request Progress Updated',
              description: 'Fulfilled.',
              time: '20 mins ago',
            ),
            _timelineItem(
              isCompleted: true,
              title: 'Request Fulfilled',
              description:
                  'All required units have now been collected from one or multiple donors.',
              time: 'Pending',
              isLast: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _timelineItem({
    bool isCompleted = false,
    int? number,
    required String title,
    required String description,
    required String time,
    String? highlightText,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Icon/Number
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.green
                      : const Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        )
                      : Text(
                          number?.toString() ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 40,
                  color: const Color(0xFFE5E7EB),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                ),
            ],
          ),
          const SizedBox(width: 12),

          /// Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                    children: _buildDescriptionSpans(description, highlightText),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _buildDescriptionSpans(String description, String? highlight) {
    if (highlight == null || !description.contains(highlight)) {
      return [TextSpan(text: description)];
    }

    final parts = description.split(highlight);
    return [
      TextSpan(text: parts[0]),
      TextSpan(
        text: highlight,
        style: const TextStyle(
          color: AppColors.red,
          fontWeight: FontWeight.w600,
        ),
      ),
      if (parts.length > 1) TextSpan(text: parts[1]),
    ];
  }
}
