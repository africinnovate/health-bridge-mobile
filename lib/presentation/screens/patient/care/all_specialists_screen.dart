import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/data/models/specialist/specialist_profile_model.dart';
import 'package:HealthBridge/presentation/providers/specialist_provider.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllSpecialistsScreen extends StatefulWidget {
  final List<SpecialistProfileModel> specialists;

  const AllSpecialistsScreen({super.key, required this.specialists});

  @override
  State<AllSpecialistsScreen> createState() => _AllSpecialistsScreenState();
}

class _AllSpecialistsScreenState extends State<AllSpecialistsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const String _recentlyViewedKey = 'recently_viewed_specialists';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  List<SpecialistProfileModel> get _filtered {
    if (_searchQuery.isEmpty) return widget.specialists;
    final q = _searchQuery.toLowerCase();
    return widget.specialists.where((s) {
      final name = '${s.firstName} ${s.lastName}'.toLowerCase();
      final specialtyName = _getSpecialtyName(s).toLowerCase();
      final city = (s.city ?? '').toLowerCase();
      return name.contains(q) || specialtyName.contains(q) || city.contains(q);
    }).toList();
  }

  Future<void> _onSpecialistTap(SpecialistProfileModel specialist) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> ids = prefs.getStringList(_recentlyViewedKey) ?? [];
    ids.remove(specialist.id);
    ids.insert(0, specialist.id);
    if (ids.length > 5) ids = ids.take(5).toList();
    await prefs.setStringList(_recentlyViewedKey, ids);
    if (mounted) {
      context.goNextScreenWithData(AppRoutes.specialistDetails, extra: specialist);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(title: 'All Specialists', showArrow: true),
      body: Column(
        children: [
          /// Search
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: const InputDecoration(
                  hintText: 'Search specialists, specialties...',
                  hintStyle: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
                  prefixIcon:
                      Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          /// Count
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Text(
                  '${_filtered.length} specialist${_filtered.length == 1 ? '' : 's'} found',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),

          /// Grid
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No specialists found',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final specialist = _filtered[index];
                      return GestureDetector(
                        onTap: () => _onSpecialistTap(specialist),
                        child: _specialistCard(
                          specialist,
                          _getSpecialtyName(specialist),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _specialistCard(SpecialistProfileModel specialist, String specialty) {
    String availabilityText = 'On schedule';
    if (specialist.availability.isNotEmpty) {
      final first = specialist.availability.first;
      availabilityText =
          '${first.dayOfWeek} • ${first.opensAt} - ${first.closesAt}';
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
          Text(
            'Dr. ${specialist.firstName} ${specialist.lastName}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
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
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Available Hours:',
            style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 4),
          Text(
            availabilityText,
            style:
                const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
