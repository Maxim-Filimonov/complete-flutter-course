import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_test/stream_test.dart';

import '../../../../mocks.dart';

void main() {
  group('AccountScreenController', () {
    late MockAuthRepository authRepository;
    late AccountScreenController controller;
    setUp(() {
      authRepository = MockAuthRepository();
      controller = AccountScreenController(authRepository: authRepository);
    });
    test('initial state is null', () async {
      verifyNever(authRepository.signOut);
      expect(controller.state, equals(const AsyncData<void>(null)));
    });

    streamTest('signout success', () async {
      when(() => authRepository.signOut()).thenAnswer((_) async {
        return Future.value();
      });
      final testObserver = controller.stream.test();

      controller.signOut();

      await testObserver.assertValues([
        const AsyncLoading<void>(),
        const AsyncData<void>(null),
      ]);
    });

    streamTest('signout failure', () async {
      final exception = Exception('signout failure');
      final testObserver = controller.stream.test();
      when(() => authRepository.signOut()).thenThrow(exception);

      expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading<void>(),
            isA<AsyncError<void>>(),
          ]));
      await controller.signOut();

      await testObserver
          .assertValues([const AsyncLoading<void>(), isA<AsyncError>()]);
      verify(() => authRepository.signOut()).called(1);
    });
  });
}
