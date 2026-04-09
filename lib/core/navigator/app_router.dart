import 'package:HealthBridge/data/models/donor/donor_model.dart';
import 'package:HealthBridge/data/models/donor/donor_stats_model.dart';
import 'package:HealthBridge/data/models/donor/donation_history_model.dart';
import 'package:HealthBridge/presentation/screens/auth/create_account_screen.dart';
import 'package:HealthBridge/presentation/screens/auth/forgot_password_screen.dart';
import 'package:HealthBridge/presentation/screens/auth/logic_screen.dart';
import 'package:HealthBridge/presentation/screens/auth/preference_screen.dart';
import 'package:HealthBridge/presentation/screens/auth/reset_password_screen.dart';
import 'package:HealthBridge/presentation/screens/auth/verify_account_screen.dart';
import 'package:HealthBridge/presentation/screens/splash/splash_screen.dart';
import 'package:HealthBridge/presentation/screens/donor/appointment/appointment_detail_screen.dart';
import 'package:HealthBridge/presentation/screens/donor/appointment/appointment_rescheduled_screen.dart';
import 'package:HealthBridge/presentation/screens/donor/donations/donation_details_screen.dart';
import 'package:HealthBridge/presentation/screens/donor/donations/donation_receipt_screen.dart';
import 'package:HealthBridge/presentation/screens/donor/donor_root_screen.dart';
import 'package:HealthBridge/presentation/screens/donor/home/blood_request_booking_screen.dart';
import 'package:HealthBridge/presentation/screens/donor/home/nearby_hospitals_screen.dart';
import 'package:HealthBridge/presentation/screens/donor/notification/donor_notification_screen.dart';
import 'package:HealthBridge/presentation/screens/donor/records/appointments_screen.dart';
import 'package:HealthBridge/presentation/screens/donor/records/donation_history_screen.dart';
import 'package:HealthBridge/presentation/screens/specialist/appointment/appointment_detail_screen.dart'
    as specialist;
import 'package:HealthBridge/presentation/screens/specialist/appointment/appointment_specialist_screen.dart';
import 'package:HealthBridge/presentation/screens/specialist/profile/edit_personal_information_screen.dart';
import 'package:HealthBridge/presentation/screens/specialist/profile/patient_profile_on_specialist_screen.dart';
import 'package:HealthBridge/presentation/screens/specialist/profile/specialist_profile_screen.dart';
import 'package:HealthBridge/presentation/screens/specialist/specialist_root_screen.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/general/document_viewer_screen.dart';
import '../../presentation/screens/general/full_image_view_screen.dart';
import '../../presentation/screens/general/profile/change_password_screen.dart';
import '../../presentation/screens/general/profile/consultation_preference_screen.dart';
import '../../presentation/screens/general/profile/contact_support_screen.dart';
import '../../presentation/screens/general/profile/edit_medical_information_screen.dart';
import '../../presentation/screens/general/profile/edit_profile_screen.dart';
import '../../presentation/screens/general/profile/faqs_screen.dart';
import '../../presentation/screens/general/profile/help_center_screen.dart';
import '../../presentation/screens/general/profile/language_settings_screen.dart';
import '../../presentation/screens/general/profile/notification_settings_screen.dart';
import '../../presentation/screens/general/profile/privacy_settings_screen.dart';
import '../../presentation/screens/hospital/donations/donation_appointment_detail_screen.dart';
import '../../presentation/screens/hospital/donations/record_donation_screen.dart';
import '../../presentation/screens/hospital/donations/reschedule_appointment_screen.dart';
import '../../presentation/screens/hospital/donors/donation_history_screen.dart'
    as hospital;
import '../../presentation/screens/hospital/donors/donor_list_screen.dart';
import '../../presentation/screens/hospital/donors/donor_profile_screen.dart';
import '../../presentation/screens/hospital/hospital_root_screen.dart';
import '../../presentation/screens/hospital/inventory/update_units_screen.dart';
import '../../presentation/screens/hospital/notifications/hospital_notification_screen.dart';
import '../../presentation/screens/hospital/profile/onboard/blood_services_screen.dart';
import '../../presentation/screens/hospital/profile/onboard/hospital_profile_complete_screen.dart';
import '../../presentation/screens/hospital/profile/onboard/hospital_set_profile_screen.dart';
import '../../presentation/screens/hospital/profile/onboard/notification_hospital_screen.dart';
import '../../presentation/screens/hospital/requests/new_blood_request_screen.dart';
import '../../presentation/screens/hospital/requests/request_details_screen.dart';
import '../../presentation/screens/patient/appointments/appointment_detail_screen.dart';
import '../../presentation/screens/patient/appointments/appointment_rescheduled_screen.dart';
import '../../presentation/screens/patient/appointments/pick_date_time_screen.dart';
import '../../presentation/screens/patient/care/all_specialists_screen.dart';
import '../../presentation/screens/patient/care/describe_symptoms_screen.dart';
import '../../presentation/screens/patient/care/filters_screen.dart';
import '../../presentation/screens/patient/care/specialist_details_screen.dart';
import '../../data/models/specialist/specialist_profile_model.dart';
import '../../presentation/screens/patient/notification/patient_notification_screen.dart';
import '../../presentation/screens/patient/patient_root_screen.dart';
import '../../presentation/screens/patient/profile/care_history_screen.dart';
import '../../presentation/screens/patient/profile/consultation_preference_screen.dart';
import '../../presentation/screens/patient/profile/onboard/consent_screen.dart';
import '../../presentation/screens/patient/profile/onboard/patient_set_profile_screen.dart';
import '../../presentation/screens/specialist/appointment/appointment_requests_screen.dart';
import '../../presentation/screens/specialist/profile/onboard/specialist_availability_screen.dart';
import '../../presentation/screens/specialist/profile/onboard/specialist_set_profile_screen.dart';
import '../../presentation/screens/specialist/reschedule_on_specialist_screen.dart';
import '../../data/models/appointment/appointment_model.dart';
import '../constants/app_routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    // initialLocation: AppRoutes.hospitalRootScreen,
    // initialLocation: AppRoutes.preference,
    // initialLocation: AppRoutes.login,
    initialLocation: AppRoutes.splash,
    // initialLocation: AppRoutes.patientRootScreen,
    // initialLocation: AppRoutes.specialistRootScreen,
    // initialLocation: AppRoutes.patientRootScreen,
    // initialLocation: AppRoutes.donorRootScreen,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => SplashScreen(),
      ),

      GoRoute(
        // choose role
        path: AppRoutes.preference,
        builder: (context, state) => PreferenceScreen(),
      ),

      GoRoute(
        path: AppRoutes.createAccount,
        builder: (context, state) => CreateAccountScreen(),
      ),

      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => LoginScreen(),
      ),

      GoRoute(
        path: AppRoutes.verifyOtp,
        builder: (context, state) => VerifyAccountScreen(),
      ),

      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => ForgotPasswordScreen(),
      ),

      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return ResetPasswordScreen(email: email);
        },
      ),

      /// donor
      GoRoute(
        path: AppRoutes.donorRootScreen,
        builder: (context, state) => DonorRootScreen(),
      ),
      GoRoute(
        path: AppRoutes.nearbyHospitals,
        builder: (context, state) => NearbyHospitalsScreen(),
      ),
      GoRoute(
        path: AppRoutes.bloodRequestBooking,
        builder: (context, state) => BloodRequestBookingScreen(
          appointment: state.extra as AppointmentModel?,
        ),
      ),
      GoRoute(
        path: AppRoutes.donorNotification,
        builder: (context, state) => DonorNotificationScreen(),
      ),
      GoRoute(
        path: AppRoutes.donorAppointmentDetail,
        builder: (context, state) {
          final appointment = state.extra as dynamic;
          return DonorAppointmentDetailScreen(appointment: appointment);
        },
      ),
      GoRoute(
        path: AppRoutes.donorAppointmentRescheduled,
        builder: (context, state) => AppointmentRescheduledScreen(),
      ),
      GoRoute(
        path: AppRoutes.donationDetails,
        builder: (context, state) => DonationDetailsScreen(),
      ),
      GoRoute(
        path: AppRoutes.donationReceipt,
        builder: (context, state) => DonationReceiptScreen(
          donation: state.extra as DonationHistoryModel?,
        ),
      ),
      GoRoute(
        path: AppRoutes.editProfileDonor,
        builder: (context, state) => EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.editPersonalInfoDonor,
        builder: (context, state) => EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.editMedicalInfoDonor,
        builder: (context, state) => EditMedicalInformationScreen(),
      ),
      GoRoute(
        path: AppRoutes.consultationPreference,
        builder: (context, state) => ConsultationPreferenceScreen(),
      ),
      GoRoute(
        path: AppRoutes.notificationSettings,
        builder: (context, state) => NotificationSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.languageSettings,
        builder: (context, state) => LanguageSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.privacySettings,
        builder: (context, state) => PrivacySettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.helpCenter,
        builder: (context, state) => HelpCenterScreen(),
      ),
      GoRoute(
        path: AppRoutes.faqs,
        builder: (context, state) => FaqsScreen(),
      ),
      GoRoute(
        path: AppRoutes.contactSupport,
        builder: (context, state) => ContactSupportScreen(),
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        builder: (context, state) => ChangePasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.donationHistory,
        builder: (context, state) => DonationHistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.appointments,
        builder: (context, state) => AppointmentsScreen(),
      ),

      /// patient
      GoRoute(
        path: AppRoutes.patientRootScreen,
        builder: (context, state) => PatientRootScreen(),
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
        path: AppRoutes.patientAppointmentDetail,
        builder: (context, state) {
          final extra = state.extra;
          final String status;
          if (extra is String) {
            status = extra;
          } else {
            status = (extra as dynamic)?.status as String? ?? 'confirmed';
          }
          return PatientAppointmentDetailScreen(status: status);
        },
      ),
      GoRoute(
        path: AppRoutes.patientAppointmentRescheduled,
        builder: (context, state) => PatientAppointmentRescheduledScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientNotification,
        builder: (context, state) => PatientNotificationScreen(),
      ),
      GoRoute(
        path: AppRoutes.specialistDetails,
        builder: (context, state) {
          final specialist = state.extra as SpecialistProfileModel?;
          return SpecialistDetailsScreen(specialist: specialist);
        },
      ),
      GoRoute(
        path: AppRoutes.allSpecialists,
        builder: (context, state) {
          final specialists =
              (state.extra as List?)?.cast<SpecialistProfileModel>() ?? [];
          return AllSpecialistsScreen(specialists: specialists);
        },
      ),
      GoRoute(
        path: AppRoutes.describeSymptoms,
        builder: (context, state) {
          final specialist = state.extra as SpecialistProfileModel?;
          return DescribeSymptomsScreen(specialist: specialist);
        },
      ),
      GoRoute(
        path: AppRoutes.filters,
        builder: (context, state) => FiltersScreen(),
      ),
      GoRoute(
        path: AppRoutes.pickDateTime,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return PickDateTimeScreen(
            specialist: extra?['specialist'] as SpecialistProfileModel?,
            symptoms: extra?['symptoms'] as String?,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.editProfilePatient,
        builder: (context, state) => EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.medicalInfoPatient,
        builder: (context, state) => PatientSetProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.consultationPreferencePatient,
        builder: (context, state) => ConsultationPreferencePatientScreen(),
      ),
      GoRoute(
        path: AppRoutes.careHistory,
        builder: (context, state) => CareHistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.setProfileHospital,
        builder: (context, state) {
          final isEditMode = state.extra as bool? ?? false;
          return HospitalSetupProfileScreen(isEditMode: isEditMode);
        },
      ),
      GoRoute(
        path: AppRoutes.bloodServiceHospital,
        builder: (context, state) {
          final isEditMode = state.extra as bool? ?? false;
          return BloodServicesScreen(isEditMode: isEditMode);
        },
      ),

      GoRoute(
        path: AppRoutes.notificationsHospital,
        builder: (context, state) {
          final isEditMode = state.extra as bool? ?? false;
          return NotificationHospitalScreen(isEditMode: isEditMode);
        },
      ),
      GoRoute(
        path: AppRoutes.hospitalComplete,
        builder: (context, state) => HospitalSetupCompleteScreen(),
      ),
      GoRoute(
        path: AppRoutes.hospitalRootScreen,
        builder: (context, state) => HospitalRootScreen(),
      ),
      GoRoute(
        path: AppRoutes.newBloodRequest,
        builder: (context, state) => NewBloodRequestScreen(),
      ),
      GoRoute(
        path: AppRoutes.requestDetails,
        builder: (context, state) {
          final bloodRequest = state.extra as dynamic;
          final status =
              bloodRequest?.requestStatus?.toLowerCase() ?? 'confirmed';
          return RequestDetailsScreen(
            bloodRequest: bloodRequest,
            status: status,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.donationAppointmentDetail,
        builder: (context, state) {
          final status = state.extra as String? ?? "unconfirmed";
          return DonationAppointmentDetailScreen(status: status);
        },
      ),
      GoRoute(
        path: AppRoutes.rescheduleAppointment,
        builder: (context, state) => RescheduleAppointmentScreen(),
      ),
      GoRoute(
        path: AppRoutes.recordDonation,
        builder: (context, state) => RecordDonationScreen(),
      ),
      GoRoute(
        path: AppRoutes.updateUnits,
        builder: (context, state) {
          final bloodType = state.extra as String? ?? "A-";
          return UpdateUnitsScreen(bloodType: bloodType);
        },
      ),
      GoRoute(
        path: AppRoutes.donorList,
        builder: (context, state) => DonorListScreen(),
      ),
      GoRoute(
        path: AppRoutes.donorProfile,
        builder: (context, state) {
          final donor = state.extra as DonorModel;
          return DonorProfileScreen(donor: donor);
        },
      ),
      GoRoute(
        path: AppRoutes.hospitalDonationHistory,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return hospital.DonationHistoryScreen(
            donor: data['donor'] as DonorModel,
            history: List<DonationHistoryModel>.from(data['history']),
            stats: data['stats'] as DonorStatsModel?,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.hospitalNotification,
        builder: (context, state) => HospitalNotificationScreen(),
      ),
      GoRoute(
        path: AppRoutes.documentViewer,
        builder: (context, state) {
          final url = state.extra as String;
          return DocumentViewerScreen(url: url);
        },
      ),
      GoRoute(
        path: AppRoutes.fullImageView,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return FullImageViewScreen(
            imageUrl: extra['imageUrl'] as String,
            title: extra['title'] as String? ?? '',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.setProfileSpecialist,
        builder: (context, state) {
          final isUpdateMode = state.extra as bool? ?? false;
          return SpecialistSetProfileScreen(isUpdateMode: isUpdateMode);
        },
      ),
      GoRoute(
        path: AppRoutes.availabilitySpecialist,
        builder: (context, state) {
          final isUpdateMode = state.extra as bool? ?? false;
          return SpecialistAvailabilityScreen(isUpdateMode: isUpdateMode);
        },
      ),
      GoRoute(
        path: AppRoutes.specialistRootScreen,
        builder: (context, state) => SpecialistRootScreen(),
      ),
      GoRoute(
        path: AppRoutes.specialistAppointDetailScreen,
        builder: (context, state) {
          final appointment = state.extra as AppointmentModel?;
          return specialist.AppointmentDetailScreen(appointment: appointment);
        },
      ),
      GoRoute(
        path: AppRoutes.specialistRequestScreen,
        builder: (context, state) {
          final showArrow = state.extra as bool;
          return AppointmentRequestsScreen(showBackArrow: showArrow);
        },
      ),
      GoRoute(
        path: AppRoutes.rescheduleOnSpecialist,
        builder: (context, state) {
          final appointment = state.extra as AppointmentModel?;
          return RescheduleOnSpecialistScreen(appointment: appointment);
        },
      ),
      GoRoute(
        path: AppRoutes.appointmentTapOnSpecialist,
        builder: (context, state) {
          final showArrow = state.extra as bool;
          return SpecialistAppointmentsScreen(showArrow: showArrow);
        },
      ),
      GoRoute(
        path: AppRoutes.specialistProfile,
        builder: (context, state) {
          final showArrow = state.extra as bool;
          return SpecialistProfileScreen(showBackArrow: showArrow);
        },
      ),

      GoRoute(
        path: AppRoutes.patientProfileOnSpecialist,
        builder: (context, state) => PatientProfileOnSpecialScreen(),
      ),
      GoRoute(
        path: AppRoutes.editPersonalSpecialist,
        builder: (context, state) => EditPersonalInformationScreen(),
      ),
      // GoRoute(
      //   path: AppRoutes.homeSpecialist,
      //   builder: (context, state) => SpecialistHomeScreen(),
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
