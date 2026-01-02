import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class NearbyHospitalsScreen extends StatefulWidget {
  const NearbyHospitalsScreen({super.key});

  @override
  State<NearbyHospitalsScreen> createState() => _NearbyHospitalsScreenState();
}

class _NearbyHospitalsScreenState extends State<NearbyHospitalsScreen> {
  final TextEditingController _searchController = TextEditingController();

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
        title: '',
        showArrow: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                /// Title and Sort
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Nearby Hospitals',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Row(
                        children: const [
                          Text(
                            'Sort',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'A-Z',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

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
                      Container(
                        width: 1,
                        height: 24,
                        color: const Color(0xFFE5E7EB),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.tune,
                        color: Color(0xFF6B7280),
                        size: 22,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          /// Hospital List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _hospitalCard(
                  image: 'assets/images/patient.png',
                  name: 'Emmanuel General Hospital',
                  address: '16 Hospital Road, Eket Akwal-bom State',
                  isOpen: false,
                  openTime: 'Opens 8:00 AM',
                  rating: 4.2,
                ),
                const SizedBox(height: 16),
                _hospitalCard(
                  image: 'assets/images/patient.png',
                  name: 'Emmanuel General Hospital',
                  address: '16 Hospital Road, Eket Akwal-bom State',
                  isOpen: true,
                  openTime: 'Closes 8:00 PM',
                  rating: 4.2,
                ),
                const SizedBox(height: 16),
                _hospitalCard(
                  image: 'assets/images/patient.png',
                  name: 'Emmanuel General Hospital',
                  address: '16 Hospital Road, Eket Akwal-bom State',
                  isOpen: true,
                  openTime: 'Closes 8:00 PM',
                  rating: 4.2,
                ),
                const SizedBox(height: 16),
                _hospitalCard(
                  image: 'assets/images/patient.png',
                  name: 'Emmanuel General Hospital',
                  address: '16 Hospital Road, Eket Akwal-bom State',
                  isOpen: true,
                  openTime: 'Closes 8:00 PM',
                  rating: 4.2,
                ),
                const SizedBox(height: 16),
                _hospitalCard(
                  image: 'assets/images/patient.png',
                  name: 'Emmanuel General Hospital',
                  address: '16 Hospital Road, Eket Akwal-bom State',
                  isOpen: true,
                  openTime: 'Closes 8:00 PM',
                  rating: 4.2,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _hospitalCard({
    required String image,
    required String name,
    required String address,
    required bool isOpen,
    required String openTime,
    required double rating,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigate to booking screen
        context.goNextScreen(AppRoutes.bloodRequestBooking);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            /// Hospital Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                image,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            /// Hospital Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        isOpen ? 'Open' : 'Closed',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isOpen ? AppColors.green : AppColors.red,
                        ),
                      ),
                      Text(
                        ' - $openTime',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Text(
                        '⭐',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
