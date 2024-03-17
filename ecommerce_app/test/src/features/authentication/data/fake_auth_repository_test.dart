import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FakeAuthRepository', () {
    late AuthRepository authRepository;
    const testEmail = 'test@test.com';
    const testPassword = 'paswwrd023';
    const invalidEmail = 'invalid@example.com';
    final testUser =
        AppUser(uid: testEmail.split('').reversed.join(''), email: testEmail);
    setUp(() {
      authRepository = FakeAuthRepository(delay: Duration.zero);
    });
    test('initial state is logged out', () {
      expect(authRepository.currentUser, isNull);
      expect(authRepository.authStateChanges(), emits(null));
    });
    test('logged in after login', () async {
      await authRepository.loginWithEmailAndPassword(
          email: testEmail, password: testPassword);

      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emits(testUser));
    });

    test('exception for invalid email', () async {
      expect(
          () => authRepository.loginWithEmailAndPassword(
                email: invalidEmail,
                password: testPassword,
              ),
          throwsException);
    });

    test('logged in after create account', () async {
      await authRepository.createUserWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      );

      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emits(testUser));
    });

    test('logged out after logout', () async {
      await authRepository.loginWithEmailAndPassword(
          email: testEmail, password: testPassword);
      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emits(testUser));

      await authRepository.signOut();

      expect(authRepository.currentUser, isNull);
      expect(authRepository.authStateChanges(), emits(null));
    });

    test('logging after dispose throws exception', () {
      authRepository.dispose();
      expect(
          () => authRepository.loginWithEmailAndPassword(
                email: testEmail,
                password: testPassword,
              ),
          throwsStateError);
    });
  });
}
