import 'package:flutter_test/flutter_test.dart';
import 'package:aurafit/features/auth/auth_validators.dart';

void main() {
  group('AuthValidators', () {
    test('rejects empty and invalid emails', () {
      expect(AuthValidators.email(''), 'Enter your email');
      expect(AuthValidators.email('not-an-email'), 'Enter a valid email address');
      expect(AuthValidators.email('alex@aurafit.app'), isNull);
    });

    test('enforces password rules', () {
      expect(AuthValidators.password(''), 'Enter your password');
      expect(AuthValidators.password('short'), 'Use at least 8 characters');
      expect(AuthValidators.newPassword('password'), 'Include at least one number');
      expect(AuthValidators.confirmPassword('a', 'b'), "Passwords don't match");
      expect(AuthValidators.newPassword('AuraFit123!'), isNull);
    });
  });
}
