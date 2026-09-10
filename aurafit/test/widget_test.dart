import 'package:aurafit/core/auth/auth_provider.dart';
import 'package:aurafit/core/onboarding/onboarding_provider.dart';
import 'package:aurafit/core/reminders/reminder_provider.dart';
import 'package:aurafit/core/status/app_status_provider.dart';
import 'package:aurafit/core/theme/theme_provider.dart';
import 'package:aurafit/core/wellness/wellness_provider.dart';
import 'package:aurafit/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('splash then welcome value proposition', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(
            create: (_) => AuthProvider()..ensureInitialized(),
          ),
          ChangeNotifierProvider(
            create: (_) => OnboardingProvider()..ensureInitialized(),
          ),
          ChangeNotifierProvider(
            create: (_) => WellnessProvider()..ensureInitialized(),
          ),
          ChangeNotifierProvider(
            create: (_) => ReminderProvider()..ensureInitialized(),
          ),
          ChangeNotifierProvider(create: (_) => AppStatusProvider()),
        ],
        child: const AuraFitApp(),
      ),
    );

    expect(find.text('AuraFit'), findsWidgets);
    expect(find.text('Train smarter. Feel unstoppable.'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2200));
    await tester.pumpAndSettle();

    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('Continue with Apple'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
  });
}
