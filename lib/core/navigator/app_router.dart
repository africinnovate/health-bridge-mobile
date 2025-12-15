import 'package:HealthBridge/presentation/screens/auth/create_account_screen.dart';
import 'package:HealthBridge/presentation/screens/auth/preference_screen.dart';
import 'package:go_router/go_router.dart';

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
      // GoRoute(
      //   path: "${AppRoutes.loginSignupPath}/:reason",
      //   builder: (context, state) {
      //     String source = state.pathParameters['reason'] ?? "";
      //     return LoginSignupScreen(initialReason: source);
      //   },
      // ),
      // GoRoute(
      //   path: AppRoutes.homeScreenPath,
      //   builder: (context, state) => HomeScreen(),
      // ),
      // GoRoute(
      //   path: AppRoutes.eduRankPickerPath,
      //   builder: (context, state) {
      //     final viewModel = state.extra as MyProfileProvider;
      //     return EduRankPickerScreen(viewModel: viewModel);
      //   },
      // ),
      // GoRoute(
      //   path: AppRoutes.myProfilePath,
      //   // name: myProfilePath,
      //   builder: (context, state) {
      //     // String username = state.extra as String? ?? "";
      //     return MyProfileScreen();
      //   },
      // ),
    ],
  );
}
