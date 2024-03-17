import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailPasswordSignInController
    extends StateNotifier<EmailPasswordSignInState> {
  EmailPasswordSignInController({
    required EmailPasswordSignInFormType formType,
    required this.authRepository,
  }) : super(EmailPasswordSignInState(
          formType: formType,
        ));
  final AuthRepository authRepository;

  Future<bool> submit({required String email, required String password}) async {
    state = state.copyWith(value: const AsyncValue.loading());
    final value = await AsyncValue.guard(
        () => _authenticate(email: email, password: password));
    state = state.copyWith(value: value);
    return value.hasError == false;
  }

  Future<void> _authenticate(
      {required String email, required String password}) async {
    switch (state.formType) {
      case EmailPasswordSignInFormType.signIn:
        await authRepository.loginWithEmailAndPassword(
            email: email, password: password);
        break;
      case EmailPasswordSignInFormType.register:
        await authRepository.createUserWithEmailAndPassword(
            email: email, password: password);
        break;
      default:
        throw Exception('Invalid form type');
    }
  }

  Future<void> updateFormType(
      {required EmailPasswordSignInFormType formType, String? email}) async {
    state = state.copyWith(formType: formType);
  }
}

final emailPasswordSignInControllerProvider = StateNotifierProvider.autoDispose
    .family<EmailPasswordSignInController, EmailPasswordSignInState,
        EmailPasswordSignInFormType>(
  (ref, formType) {
    final authRepository = ref.watch(authRepositoryProvider);
    return EmailPasswordSignInController(
      formType: formType,
      authRepository: authRepository,
    );
  },
);
