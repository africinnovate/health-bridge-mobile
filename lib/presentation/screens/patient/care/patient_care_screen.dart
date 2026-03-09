import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/data/models/specialist/specialist_profile_model.dart';
import 'package:HealthBridge/presentation/providers/specialist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientCareScreen extends StatefulWidget {
  final Function(int)? onNavigateToTab;

  const PatientCareScreen({super.key, this.onNavigateToTab});

  @override
  State<PatientCareScreen> createState() => _PatientCareScreenState();
}

class _PatientCareScreenState extends State<PatientCareScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<String> _recentlyViewedIds = [];

  static const String _recentlyViewedKey = 'recently_viewed_specialists';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final provider = context.read<SpecialistProvider>();
    await Future.wait([
      provider.getSpecialists(verified: true),
      provider.getSpecialties(),
    ]);
    await _loadRecentlyViewed();
  }

  Future<void> _loadRecentlyViewed() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_recentlyViewedKey) ?? [];
    if (mounted) {
      setState(() => _recentlyViewedIds = ids);
    }
  }

  Future<void> _onSpecialistTap(SpecialistProfileModel specialist) async {
    // Save to recently viewed (max 5)
    final prefs = await SharedPreferences.getInstance();
    List<String> ids = prefs.getStringList(_recentlyViewedKey) ?? [];
    ids.remove(specialist.id);
    ids.insert(0, specialist.id);
    if (ids.length > 5) ids = ids.take(5).toList();
    await prefs.setStringList(_recentlyViewedKey, ids);
    if (mounted) {
      setState(() => _recentlyViewedIds = ids);
      context.goNextScreenWithData(AppRoutes.specialistDetails, extra: specialist);
    }
  }

  String _getSpecialtyName(SpecialistProfileModel specialist) {
    final provider = context.read<SpecialistProvider>();
    try {
      return provider.specialties
          .firstWhere((s) => s.id == specialist.specialtyId)
          .name;
    } catch (_) {
      return 'Specialist';
    }
  }

  List<SpecialistProfileModel> get _filteredSpecialists {
    final provider = context.read<SpecialistProvider>();
    final all = provider.specialists;
    if (_searchQuery.isEmpty) return all;
    final q = _searchQuery.toLowerCase();
    return all.where((s) {
      final name = '${s.firstName} ${s.lastName}'.toLowerCase();
      final specialtyName = _getSpecialtyName(s).toLowerCase();
      final city = (s.city ?? '').toLowerCase();
      return name.contains(q) || specialtyName.contains(q) || city.contains(q);
    }).toList();
  }

  List<SpecialistProfileModel> get _topSpecialists {
    final all = _filteredSpecialists;
    final sorted = [...all]..sort((a, b) {
        if (a.rate == null && b.rate == null) return 0;
        if (a.rate == null) return 1;
        if (b.rate == null) return -1;
        return b.rate!.compareTo(a.rate!);
      });
    return sorted.take(6).toList();
  }

  List<SpecialistProfileModel> get _recentlyViewedSpecialists {
    final provider = context.read<SpecialistProvider>();
    return _recentlyViewedIds
        .map((id) {
          try {
            return provider.specialists.firstWhere((s) => s.id == id);
          } catch (_) {
            return null;
          }
        })
        .whereType<SpecialistProfileModel>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SpecialistProvider>(
      builder: (context, specialistProvider, _) {
        return Scaffold(
          backgroundColor: AppColors.backgroundGray,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadData,
                  color: AppColors.red,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),

                          /// Search Bar
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: const Color(0xFFE5E7EB)),
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() => _searchQuery = value);
                              },
                              decoration: const InputDecoration(
                                hintText: 'Search specialists, specialties...',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF9CA3AF),
                                ),
                                prefixIcon: Icon(Icons.search,
                                    color: Color(0xFF9CA3AF), size: 20),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          /// Recently Viewed
                          if (_recentlyViewedSpecialists.isNotEmpty) ...[
                            const Text(
                              'Recently Viewed',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildRecentlyViewed(specialistProvider),
                            const SizedBox(height: 32),
                          ],

                          /// Top Specialists
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _searchQuery.isEmpty
                                    ? 'Top Specialists'
                                    : 'Search Results',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (_searchQuery.isEmpty)
                                GestureDetector(
                                  onTap: () {
                                    context.goNextScreenWithData(
                                      AppRoutes.allSpecialists,
                                      extra: specialistProvider.specialists,
                                    );
                                  },
                                  child: const Text(
                                    'See all',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.red,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          if (specialistProvider.isLoading)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(40),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else if (_topSpecialists.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(40),
                                child: Text(
                                  'No specialists found',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                            )
                          else
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.65,
                              ),
                              itemCount: _topSpecialists.length,
                              itemBuilder: (context, index) {
                                final specialist = _topSpecialists[index];
                                return GestureDetector(
                                  onTap: () => _onSpecialistTap(specialist),
                                  child: _specialistCard(
                                    specialist,
                                    _getSpecialtyName(specialist),
                                  ),
                                );
                              },
                            ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 35),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Find a Specialist',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Find the right specialist for your health needs.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentlyViewed(SpecialistProvider provider) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _recentlyViewedSpecialists.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final specialist = _recentlyViewedSpecialists[index];
          return GestureDetector(
            onTap: () => _onSpecialistTap(specialist),
            child: _recentDoctorCard(specialist, _getSpecialtyName(specialist)),
          );
        },
      ),
    );
  }

  Widget _recentDoctorCard(SpecialistProfileModel specialist, String specialty) {
    return Container(
      width: 190,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: specialist.imageUrl != null
                ? NetworkImage(specialist.imageUrl!) as ImageProvider
                : const AssetImage('assets/images/patient.png'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Dr. ${specialist.firstName}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  specialty,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (specialist.rate != null) ...[
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          color: Color(0xFFFBBF24), size: 12),
                      const SizedBox(width: 2),
                      Text(
                        specialist.rate!.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _specialistCard(SpecialistProfileModel specialist, String specialty) {
    // Format availability hours from first entry
    String availabilityText = 'Mon-Fri • On schedule';
    if (specialist.availability.isNotEmpty) {
      final first = specialist.availability.first;
      availabilityText = '${first.dayOfWeek} • ${first.opensAt} - ${first.closesAt}';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW: PHOTO + ARROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: specialist.imageUrl != null
                    ? NetworkImage(specialist.imageUrl!) as ImageProvider
                    : const AssetImage('assets/images/patient.png'),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          /// NAME
          Text(
            'Dr. ${specialist.firstName} ${specialist.lastName}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),

          /// SPECIALTY + RATING
          Row(
            children: [
              Flexible(
                child: Text(
                  specialty,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.green,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (specialist.rate != null) ...[
                const SizedBox(width: 8),
                const Icon(Icons.star, color: Color(0xFFFBBF24), size: 14),
                const SizedBox(width: 2),
                Text(
                  specialist.rate!.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),

          /// AVAILABLE HOURS
          const Text(
            'Available Hours:',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            availabilityText,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
