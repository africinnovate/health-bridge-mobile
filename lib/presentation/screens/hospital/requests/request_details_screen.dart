import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/dialog.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/data/models/blood_request/blood_request_model.dart';
import 'package:HealthBridge/presentation/providers/hospital_provider.dart';
import 'package:HealthBridge/presentation/widgets/cancel_button.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestDetailsScreen extends StatefulWidget {
  final BloodRequestModel? bloodRequest;
  final String status; // "confirmed", "accepted", "completed", "cancelled"

  const RequestDetailsScreen({
    super.key,
    this.bloodRequest,
    this.status = "confirmed",
  });

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  Future<void> _cancelBloodRequest() async {
    if (widget.bloodRequest == null) return;

    context.showLoadingDialog();

    final hospitalProvider = context.read<HospitalProvider>();

    // Build payload according to API spec
    final payload = {
      'request_status': 'cancelled',
      'timeline_status': null,
      'note': null,
      'administered_at': null,
      'donated_at': null,
      'units': widget.bloodRequest!.units,
      'urgency': widget.bloodRequest!.urgency,
    };

    final error = await hospitalProvider.updateBloodRequest(
      widget.bloodRequest!.id,
      payload,
    );

    context.hideLoadingDialog();

    if (error != null) {
      if (mounted) {
        SnackBarUtils.showError(context, error);
      }
      return;
    }

    // Success - pop with result to indicate refresh is needed
    if (mounted) {
      SnackBarUtils.showSuccess(context, "Request cancelled successfully");
      Navigator.pop(context, true); // Return true to indicate refresh is needed
    }
  }

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
                    onConfirm: () async {
                      await _cancelBloodRequest();
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

  String _convertBloodType(String? apiFormat) {
    if (apiFormat == null) return 'N/A';

    final bloodTypeMap = {
      'apositive': 'A+',
      'anegative': 'A-',
      'bpositive': 'B+',
      'bnegative': 'B-',
      'abpositive': 'AB+',
      'abnegative': 'AB-',
      'opositive': 'O+',
      'onegative': 'O-',
    };

    return bloodTypeMap[apiFormat.toLowerCase()] ?? apiFormat;
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.inDays == 0) {
      return 'Today, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}';
    } else if (difference.inDays == 1) {
      return 'Tomorrow, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}';
    } else {
      return '${dateTime.month}/${dateTime.day}/${dateTime.year}, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}';
    }
  }

  Widget _buildInfoSection() {
    if (widget.bloodRequest == null) {
      return const SizedBox.shrink();
    }

    final req = widget.bloodRequest!;
    final bloodType = _convertBloodType(req.bloodType);
    final preferredTime = req.preferredTime != null
        ? _formatDateTime(req.preferredTime!)
        : 'Not specified';
    final urgency = (req.urgency ?? '').isNotEmpty
        ? req.urgency![0].toUpperCase() + req.urgency!.substring(1)
        : 'Standard';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _infoRow('Blood Type:', bloodType),
          const SizedBox(height: 16),
          _infoRow('Units Requested', '${req.units} units'),
          const SizedBox(height: 16),
          _infoRow('Urgency:', urgency),
          const SizedBox(height: 16),
          _infoRow('Reason:', req.requestReason ?? 'Not specified'),
          const SizedBox(height: 16),
          _infoRow('Preferred Time:', preferredTime),
          const SizedBox(height: 16),
          _infoRow('Reference ID:', req.refId),
        ],
      ),
    );
  }

  Widget _buildCancelledInfoSection() {
    if (widget.bloodRequest == null) {
      return const SizedBox.shrink();
    }

    final req = widget.bloodRequest!;
    final bloodType = _convertBloodType(req.bloodType);
    final createdDate =
        '${req.createdAt.month}/${req.createdAt.day}/${req.createdAt.year}, ${req.createdAt.hour}:${req.createdAt.minute.toString().padLeft(2, '0')}';
    final urgency = (req.urgency ?? '').isNotEmpty
        ? req.urgency![0].toUpperCase() + req.urgency!.substring(1)
        : 'Standard';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _infoRow('Blood Type:', bloodType),
          const SizedBox(height: 16),
          _infoRow('Units Requested', '${req.units} units'),
          const SizedBox(height: 16),
          _infoRow('Urgency:', urgency),
          const SizedBox(height: 16),
          _infoRow('Reason:', req.requestReason ?? 'Not specified'),
          const SizedBox(height: 16),
          _infoRow('Requested On:', createdDate),
          const SizedBox(height: 16),
          _infoRow('Reference ID:', req.refId),
        ],
      ),
    );
  }

  Widget _buildCancellationDetails() {
    if (widget.bloodRequest == null) {
      return const SizedBox.shrink();
    }

    final req = widget.bloodRequest!;
    final cancelledDate = req.cancelledAt != null
        ? '${req.cancelledAt!.month}/${req.cancelledAt!.day}/${req.cancelledAt!.year}, ${req.cancelledAt!.hour}:${req.cancelledAt!.minute.toString().padLeft(2, '0')}'
        : 'Not specified';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _infoRow('Cancelled By:', req.cancelledBy ?? 'Hospital Admin'),
          const SizedBox(height: 16),
          _infoRow('Cancelled On:', cancelledDate),
          const SizedBox(height: 16),
          _infoRow(
              'Cancellation Reason:', req.cancelledReason ?? 'Not specified'),
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
    if (widget.bloodRequest == null) {
      return const SizedBox.shrink();
    }

    final req = widget.bloodRequest!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _timelineItem(
            isCompleted: true,
            title: 'Request Created',
            description: 'Hospital submitted this blood request.',
            time: _getTimeAgo(req.createdAt),
          ),
          const SizedBox(height: 0),
          _timelineItem(
            isCompleted: req.timelineStatus != null &&
                (req.timelineStatus == 'visible_to_donors' ||
                    req.timelineStatus == 'donation_appointment_scheduled' ||
                    req.timelineStatus == 'donation_completed' ||
                    req.timelineStatus == 'request_fulfilled'),
            title: 'Visible to Donors',
            description: 'Nearby donors can now respond to this request.',
            time: req.timelineStatus != null &&
                    (req.timelineStatus == 'visible_to_donors' ||
                        req.timelineStatus ==
                            'donation_appointment_scheduled' ||
                        req.timelineStatus == 'donation_completed' ||
                        req.timelineStatus == 'request_fulfilled')
                ? _getTimeAgo(req.createdAt)
                : 'Pending',
          ),
          const SizedBox(height: 0),
          if (req.donatedAt != null) ...[
            _timelineItem(
              isCompleted: true,
              title: 'Donation Completed',
              description:
                  'Blood units have been donated and collected successfully.',
              time: _getTimeAgo(req.donatedAt!),
            ),
            const SizedBox(height: 0),
          ],
          if (req.administeredAt != null) ...[
            _timelineItem(
              isCompleted: true,
              title: 'Blood Administered',
              description: 'Blood units have been administered to the patient.',
              time: _getTimeAgo(req.administeredAt!),
              isLast: true,
            ),
          ] else if (req.requestStatus?.toLowerCase() == 'completed') ...[
            _timelineItem(
              isCompleted: true,
              title: 'Request Fulfilled',
              description:
                  'All required units have been collected and completed.',
              time: 'Completed',
              isLast: true,
            ),
          ] else ...[
            _timelineItem(
              isCompleted: false,
              // number: 3,
              title: 'Awaiting Completion',
              description: 'Waiting for blood donations to be collected.',
              time: 'Pending',
              isLast: true,
            ),
          ],
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
    }
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
                  color:
                      isCompleted ? AppColors.green : const Color(0xFFF3F4F6),
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
                    children:
                        _buildDescriptionSpans(description, highlightText),
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
