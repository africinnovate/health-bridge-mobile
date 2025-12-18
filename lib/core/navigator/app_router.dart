import 'package:HealthBridge/presentation/screens/auth/create_account_screen.dart';
import 'package:HealthBridge/presentation/screens/auth/preference_screen.dart';
import 'package:HealthBridge/presentation/screens/auth/verify_account_screen.dart';
import 'package:HealthBridge/presentation/screens/specialist/specialist_root_screen.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/hospital/profile_onboard/blood_services_screen.dart';
import '../../presentation/screens/hospital/profile_onboard/hospital_profile_complete_screen.dart';
import '../../presentation/screens/hospital/profile_onboard/hospital_set_profile_screen.dart';
import '../../presentation/screens/hospital/profile_onboard/notification_hospital_screen.dart';
import '../../presentation/screens/patient/profile_onboard/consent_screen.dart';
import '../../presentation/screens/patient/profile_onboard/patient_set_profile_screen.dart';
import '../../presentation/screens/specialist/profile/onboard/specialist_availability_screen.dart';
import '../../presentation/screens/specialist/profile/onboard/specialist_set_profile_screen.dart';
import '../constants/app_routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.preference,
    routes: [
      GoRoute(
        path: AppRoutes.preference,
        builder: (context, state) => PreferenceScreen(),
      ),

      GoRoute(
        path: AppRoutes.createAccount,
        builder: (context, state) => CreateAccountScreen(),
      ),

      GoRoute(
        path: AppRoutes.verifyOtp,
        builder: (context, state) => VerifyAccountScreen(),
      ),
      GoRoute(
        path: AppRoutes.setProfilePatient,
        builder: (context, state) => PatientSetProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientConsent,
        builder: (context, state) => PatientConsentScreen(),
      ),
      GoRoute(
        path: AppRoutes.setProfileHospital,
        builder: (context, state) => HospitalProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.bloodServiceHospital,
        builder: (context, state) => BloodServicesScreen(),
      ),

      GoRoute(
        path: AppRoutes.notificationsHospital,
        builder: (context, state) => NotificationHospitalScreen(),
      ),
      GoRoute(
        path: AppRoutes.hospitalComplete,
        builder: (context, state) => HospitalSetupCompleteScreen(),
      ),
      GoRoute(
        path: AppRoutes.setProfileSpecialist,
        builder: (context, state) => SpecialistSetProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.availabilitySpecialist,
        builder: (context, state) => SpecialistAvailabilityScreen(),
      ),
      GoRoute(
        path: AppRoutes.bloodServiceHospital,
        builder: (context, state) => BloodServicesScreen(),
      ),
      GoRoute(
        path: AppRoutes.specialistRootScreen,
        builder: (context, state) => SpecialistRootScreen(),
      ),

      // GoRoute(
      //   path: AppRoutes.specialistRootScreen,
      //   builder: (context, state) => SpecialistRootScreen(),
      // ),
      // GoRoute(
      //   path: AppRoutes.specialistRootScreen,
      //   builder: (context, state) => SpecialistRootScreen(),
      // ),
      // GoRoute(
      //   path: AppRoutes.specialistRootScreen,
      //   builder: (context, state) => SpecialistRootScreen(),
      // ),
      // GoRoute(
      //   path: AppRoutes.specialistRootScreen,
      //   builder: (context, state) => SpecialistRootScreen(),
      // ),
      // GoRoute(
      //   path: AppRoutes.specialistRootScreen,
      //   builder: (context, state) => SpecialistRootScreen(),
      // ),
      // GoRoute(
      //   path: AppRoutes.specialistRootScreen,
      //   builder: (context, state) => SpecialistRootScreen(),
      // ), GoRoute(
      //   path: AppRoutes.specialistRootScreen,
      //   builder: (context, state) => SpecialistRootScreen(),
      // ),
      //

      // GoRoute(
      //   path: AppRoutes.eduRankPickerPath,
      //   builder: (context, state) {
      //     final viewModel = state.extra as MyProfileProvider;
      //     return EduRankPickerScreen(viewModel: viewModel);
      //   },
      // ),
    ],
  );
}
