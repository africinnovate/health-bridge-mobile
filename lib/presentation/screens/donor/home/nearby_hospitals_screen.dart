import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/data/models/hospital/hospital_model.dart';
import 'package:HealthBridge/presentation/providers/hospital_provider.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NearbyHospitalsScreen extends StatefulWidget {
  const NearbyHospitalsScreen({super.key});

  @override
  State<NearbyHospitalsScreen> createState() => _NearbyHospitalsScreenState();
}

class _NearbyHospitalsScreenState extends State<NearbyHospitalsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHospitals();
    });
  }

  Future<void> _loadHospitals() async {
    final hospitalProvider = context.read<HospitalProvider>();
    context.showLoadingDialog();
    await hospitalProvider.getNearbyHospitals();
    context.hideLoadingDialog();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(
        title: 'Nearby Hospitals',
        showArrow: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadHospitals,
        color: AppColors.red,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  /// Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: Color(0xFF9CA3AF),
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value.toLowerCase();
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: 'Search Hospitals',
                              hintStyle: TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            /// Hospital List
            Expanded(
              child: Consumer<HospitalProvider>(
                builder: (context, hospitalProvider, _) {
                  var hospitals = hospitalProvider.nearbyHospitals;

                  // Filter hospitals based on search query
                  if (_searchQuery.isNotEmpty) {
                    hospitals = hospitals
                        .where((hospital) =>
                            hospital.name
                                .toLowerCase()
                                .contains(_searchQuery) ||
                            hospital.address
                                .toLowerCase()
                                .contains(_searchQuery) ||
                            hospital.city.toLowerCase().contains(_searchQuery))
                        .toList();
                  }

                  if (hospitals.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_hospital_outlined,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty
                                ? 'No hospitals found'
                                : 'No hospitals match your search',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: hospitals.length,
                    itemBuilder: (context, index) {
                      final hospital = hospitals[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildHospitalCard(hospital),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHospitalCard(HospitalModel hospital) {
    final acceptingDonors = hospital.acceptingDonors;
    final hasBloodBank = hospital.hasBloodBank;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header with Hospital Name
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hospital.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            hospital.address,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (acceptingDonors)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Accepting',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          /// Divider
          Container(height: 1, color: Colors.grey[200]),

          /// Info Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Location
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          [hospital.city, hospital.country]
                              .where((e) => e.isNotEmpty)
                              .join(', '),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Contact
                if (hospital.emergencyPhone != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            hospital.emergencyPhone!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                /// Blood Bank Status
                Row(
                  children: [
                    Icon(Icons.water_drop, size: 16, color: AppColors.red),
                    const SizedBox(width: 8),
                    Text(
                      hasBloodBank ? 'Has Blood Bank' : 'No Blood Bank',
                      style: TextStyle(
                        fontSize: 12,
                        color: hasBloodBank ? AppColors.red : Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                /// Blood Types
                if (hospital.bloodInventory.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: hospital.bloodInventory
                          .map((inventory) =>
                              _buildBloodTypeChip(inventory.bloodType))
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBloodTypeChip(String bloodType) {
    final formatted = _formatBloodType(bloodType);
    final color = _getBloodTypeColor(formatted);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        formatted,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  String _formatBloodType(String bloodType) {
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
        return bloodType;
    }
  }

  Color _getBloodTypeColor(String formatted) {
    switch (formatted) {
      case 'A+':
      case 'AB+':
        return const Color(0xFF2563EB);
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
}
