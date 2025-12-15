import 'dart:convert';

class SecureStorage {
//   static const _storage = FlutterSecureStorage();
//
//   // Keys
//   static const _savedAccountsKey = 'saved_accounts';
//   static const _userProfilesKey = 'user_profiles';
//
//   // ----------------------------------------------------------
//   // 1. SAVE LOGIN ACCOUNT (SwitchAccountM)
//   // ----------------------------------------------------------
//   static Future<void> saveLogin(SwitchAccountM m) async {
//     final existing = await getAllSavedLogins() ?? [];
//
//     // Remove old entry if same UID already exists
//     existing.removeWhere((x) => x.uid == m.uid);
//
//     // Add new/updated account
//     existing.add(m);
//
//     // Save list back to secure storage
//     final jsonList = existing.map((x) => jsonEncode(x.toJson())).toList();
//     await _storage.write(key: _savedAccountsKey, value: jsonEncode(jsonList));
//   }
//
//   // ----------------------------------------------------------
//   // 2. GET ALL SAVED ACCOUNTS
//   // ----------------------------------------------------------
//   static Future<List<SwitchAccountM>?> getAllSavedLogins() async {
//     final raw = await _storage.read(key: _savedAccountsKey);
//     if (raw == null) return null;
//
//     final List<dynamic> list = jsonDecode(raw);
//
//     return list.map((x) {
//       return SwitchAccountM.fromJson(jsonDecode(x));
//     }).toList();
//   }
//
//   // ----------------------------------------------------------
//   // 3. DELETE OR LOGOUT ACCOUNT BY UID
//   // ----------------------------------------------------------
//   static Future<void> deleteOrLogoutAccount(String uid) async {
//     // Remove from login list
//     final accounts = await getAllSavedLogins() ?? [];
//     accounts.removeWhere((x) => x.uid == uid);
//
//     // Save updated account list
//     final jsonList = accounts.map((x) => jsonEncode(x.toJson())).toList();
//     await _storage.write(key: _savedAccountsKey, value: jsonEncode(jsonList));
//
//     // Also remove profile with same uid
//     final profiles = await _getAllProfiles();
//     profiles?.remove(uid);
//
//     if (profiles != null) {
//       await _storage.write(
//         key: _userProfilesKey,
//         value: jsonEncode(profiles),
//       );
//     }
//   }
//
//   // ----------------------------------------------------------
//   // 4. SAVE USER PROFILE (UserProfileM)
//   // ----------------------------------------------------------
//   static Future<void> saveUserProfile(UserProfileM profile) async {
//     final profiles = await _getAllProfiles() ?? {};
//
//     profiles[profile.uid!] = jsonEncode(profile.toJson());
//
//     await _storage.write(
//       key: _userProfilesKey,
//       value: jsonEncode(profiles),
//     );
//   }
//
//   // ----------------------------------------------------------
//   // 5. GET USER PROFILE BY UID
//   // ----------------------------------------------------------
//   static Future<UserProfileM?> getSavedUserProfile(String uid) async {
//     final profiles = await _getAllProfiles();
//     if (profiles == null) return null;
//
//     final raw = profiles[uid];
//     if (raw == null) return null;
//     return UserProfileM.fromJson(jsonDecode(raw));
//   }
//
//   // ----------------------------------------------------------
//   /// INTERNAL: Load all profiles map { uid: jsonString }
//   // ----------------------------------------------------------
//   static Future<Map<String, dynamic>?> _getAllProfiles() async {
//     final raw = await _storage.read(key: _userProfilesKey);
//     if (raw == null) return null;
//     return jsonDecode(raw);
//   }
}
