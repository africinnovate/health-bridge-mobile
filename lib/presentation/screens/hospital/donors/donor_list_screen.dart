import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/presentation/providers/hospital_provider.dart';
import 'package:HealthBridge/data/models/donor/donor_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonorListScreen extends StatefulWidget {
  const DonorListScreen({super.key});

  @override
  State<DonorListScreen> createState() => _DonorListScreenState();
}

class _DonorListScreenState extends State<DonorListScreen> {
  String selectedBloodType = 'All';
  String sortBy = 'A-Z';
  final TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  final List<String> bloodTypes = [
    'All',
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDonors();
    });
    searchController.addListener(() {
      setState(() {}); // Trigger rebuild on search text change
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDonors() async {
    setState(() {
      isLoading = true;
    });

    final hospitalProvider = context.read<HospitalProvider>();
    // Load all donors once - no blood type filter
    await hospitalProvider.getDonorList();

    setState(() {
      isLoading = false;
    });
  }

  List<DonorModel> _getFilteredAndSortedDonors(List<DonorModel> donors) {
    var filtered = donors;

    // Filter by selected blood type
    if (selectedBloodType != 'All') {
      filtered = filtered.where((donor) {
        return donor.formattedBloodType == selectedBloodType;
      }).toList();
    }

    // Filter by search text
    if (searchController.text.isNotEmpty) {
      final searchLower = searchController.text.toLowerCase();
      filtered = filtered.where((donor) {
        final nameMatch = donor.fullName.toLowerCase().contains(searchLower);
        final bloodTypeMatch = donor.formattedBloodType.toLowerCase().contains(searchLower);
        return nameMatch || bloodTypeMatch;
      }).toList();
    }

    // Sort
    if (sortBy == 'A-Z') {
      filtered.sort((a, b) => a.fullName.compareTo(b.fullName));
    } else if (sortBy == 'Z-A') {
      filtered.sort((a, b) => b.fullName.compareTo(a.fullName));
    }
    // 'Recent' would require a lastDonation field in the model

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: Column(
        children: [
          /// Header with back button
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: 16,
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.goBack(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Text(
                    'Donor List',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: _showSortMenu,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Sort',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            sortBy,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.unfold_more,
                            size: 16,
                            color: Color(0xFF6B7280),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  /// Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search donor by name or blood type',
                        hintStyle: TextStyle(
                          color: Color(0xFF9CA3AF).withOpacity(0.7),
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF9CA3AF),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Blood Type Filter Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: bloodTypes.map((bloodType) {
                          final isSelected = selectedBloodType == bloodType;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedBloodType = bloodType;
                              });
                              // No need to reload - filtering is done client-side
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected ? AppColors.red : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.red
                                      : const Color(0xFFE5E7EB),
                                ),
                              ),
                              child: Text(
                                bloodType,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF6B7280),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Donor List
                  Consumer<HospitalProvider>(
                    builder: (context, hospitalProvider, _) {
                      if (isLoading) {
                        return const Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final filteredDonors = _getFilteredAndSortedDonors(
                        hospitalProvider.donors,
                      );

                      if (filteredDonors.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(40),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 64,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No donors found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  searchController.text.isNotEmpty
                                      ? 'Try adjusting your search'
                                      : 'No donors match the selected filters',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[400],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Donor Count
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              '${filteredDonors.length} ${filteredDonors.length == 1 ? 'Donor' : 'Donors'} found',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          /// Donor Cards
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                ...filteredDonors.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final donor = entry.value;
                                  return Column(
                                    children: [
                                      _buildDonorCard(donor),
                                      if (index < filteredDonors.length - 1)
                                        const SizedBox(height: 12),
                                    ],
                                  );
                                }).toList(),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonorCard(DonorModel donor) {
    final isEligible = donor.eligibleToDonate;

    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Row: Avatar and Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Avatar with Initials or Image
              donor.imageUrl != null && donor.imageUrl!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        donor.imageUrl!,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildInitialsAvatar(donor.initials);
                        },
                      ),
                    )
                  : _buildInitialsAvatar(donor.initials),

              /// Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isEligible
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isEligible ? 'Eligible' : 'Ineligible',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isEligible
                        ? const Color(0xFF059669)
                        : const Color(0xFFF59E0B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// Donor Name
          Text(
            donor.fullName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),

          /// Blood Type Badge
          if (donor.bloodType != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  donor.formattedBloodType,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.red,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 6),

          /// Contact and View Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  donor.email ?? donor.phone ?? 'No contact info',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.goNextScreenWithData(
                    AppRoutes.donorProfile,
                    extra: donor,
                  );
                },
                child: const Text(
                  'View',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInitialsAvatar(String initials) {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        color: Color(0xFF2563EB),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showSortMenu() {
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(0, 0, 0, 0),
      items: [
        const PopupMenuItem(
          value: 'A-Z',
          child: Text('A-Z'),
        ),
        const PopupMenuItem(
          value: 'Z-A',
          child: Text('Z-A'),
        ),
        const PopupMenuItem(
          value: 'Recent',
          child: Text('Recent'),
        ),
      ],
    ).then((value) {
      if (value != null) {
        setState(() {
          sortBy = value;
        });
      }
    });
  }
}
