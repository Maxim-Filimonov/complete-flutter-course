import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  AppUser? get currentUser;
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signOut();
  void dispose();
}

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.delay = const Duration(seconds: 1)});

  final Duration delay;
  final _authStore = InMemoryStore<AppUser?>(null);
  @override
  Stream<AppUser?> authStateChanges() {
    return _authStore.stream;
  }

  @override
  AppUser? get currentUser {
    return _authStore.value;
  }

  @override
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (email != 'invalid@example.com') {
      await _createNewUser(email: email, password: password);
    } else {
      throw Exception('Invalid email or password');
    }
  }

  @override
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _createNewUser(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await Future<void>.delayed(delay);
    _authStore.value = null;
  }

  Future<void> _createNewUser({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(delay);
    _authStore.value = AppUser(
      uid: email.split('').reversed.join(''),
      email: email,
    );
  }

  @override
  void dispose() {
    _authStore.dispose();
  }
}

final authRepositoryProvider = Provider.autoDispose<AuthRepository>((ref) {
  var repository = FakeAuthRepository();
  ref.onDispose(() {
    repository.dispose();
  });
  return repository;
});

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});
