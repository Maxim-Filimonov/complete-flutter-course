import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_controller.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_test/stream_test.dart';

import '../../../../mocks.dart';

// email_password_sign_in_controller.dart
void main() {
  group('EmailPasswordSignInController', () {
    late MockAuthRepository authRepository;
    const testEmail = 'test@gmail.com';
    const testPassword = '123456';

    // setup
    setUp(() {
      authRepository = MockAuthRepository();
    });

    test('login - success', () async {
      when(() => authRepository.loginWithEmailAndPassword(
              email: testEmail, password: testPassword))
          .thenAnswer((invocation) => Future.value(null));

      // create controller)
      final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.signIn,
          authRepository: authRepository);
      final observer = controller.stream.test();

      controller.submit(email: testEmail, password: testPassword);

      await observer.assertValues([
        predicate<EmailPasswordSignInState>((p0) => p0.isLoading),
        predicate<EmailPasswordSignInState>((p0) => !p0.value.hasError)
      ]);
    });
    test('login - failure', () async {
      var testException = Exception('login failed');
      when(() => authRepository.loginWithEmailAndPassword(
          email: testEmail, password: testPassword)).thenThrow(testException);

      // create controller)
      final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.signIn,
          authRepository: authRepository);
      final observer = controller.stream.test();

      controller.submit(email: testEmail, password: testPassword);

      await observer.assertValues([
        predicate<EmailPasswordSignInState>((p0) => p0.isLoading),
        predicate<EmailPasswordSignInState>(
            (p0) => p0.value.hasError && p0.value.error == testException)
      ]);
    });

    test('registration - success', () async {
      when(() => authRepository.createUserWithEmailAndPassword(
              email: testEmail, password: testPassword))
          .thenAnswer((invocation) => Future.value(null));

      // create controller)
      final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.register,
          authRepository: authRepository);
      final observer = controller.stream.test();

      controller.submit(email: testEmail, password: testPassword);

      await observer.assertValues([
        predicate<EmailPasswordSignInState>((p0) => p0.isLoading),
        predicate<EmailPasswordSignInState>((p0) => !p0.value.hasError)
      ]);
    });

    test('registration - failure', () async {
      var testException = Exception('registration failed');
      when(() => authRepository.createUserWithEmailAndPassword(
          email: testEmail, password: testPassword)).thenThrow(testException);

      // create controller)
      final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.register,
          authRepository: authRepository);
      final observer = controller.stream.test();

      controller.submit(email: testEmail, password: testPassword);

      await observer.assertValues([
        predicate<EmailPasswordSignInState>((p0) => p0.isLoading),
        predicate<EmailPasswordSignInState>(
            (p0) => p0.value.hasError && p0.value.error == testException)
      ]);
    });

    test('update form type', () {
      final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.signIn,
          authRepository: authRepository);

      controller.updateFormType(formType: EmailPasswordSignInFormType.register);

      expect(controller.state.formType, EmailPasswordSignInFormType.register);
    });
  });
}
