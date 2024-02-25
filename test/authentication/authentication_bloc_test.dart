import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_login_bloc/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class _MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class _MockUserRepository extends Mock implements UserRepository {}

void main() {
  const user = User('id');

  late AuthenticationRepository authenticationRepository;
  late UserRepository userRepository;

  setUp(() {
    authenticationRepository = _MockAuthenticationRepository();
    when(() => authenticationRepository.status)
        .thenAnswer((_) => const Stream.empty());
    userRepository = _MockUserRepository();
  });

  group('AuthenticationBloc', () {
    test('initial state is AuthenticationState.unknown', () {
      final authenticationBloc = AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository);

      expect(authenticationBloc.state, AuthenticationState.unKnown());
      authenticationBloc.close();
    });

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [unauthenticated] when status is unauthenticated',
      setUp: () {
        when(() => authenticationRepository.status).thenAnswer(
            (invocation) => Stream.value(AuthenticationStatus.authenticated));
      },
      build: () => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository),
      expect: () =>
          <AuthenticationState>[const AuthenticationState.unauthenticated()],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [authenticated] when status is authenticated',
      setUp: () {
        when(() => authenticationRepository.status).thenAnswer(
            (invocation) => Stream.value(AuthenticationStatus.authenticated));
        when(() => userRepository.getUser())
            .thenAnswer((invocation) async => user);
      },
      build: () => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository),
      expect: () => const <AuthenticationState>[
        AuthenticationState.authenticated(user),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [unauthenticated] when status is authenticated but getUser fails',
      setUp: () {
        when(() => authenticationRepository.status).thenAnswer(
            (invocation) => Stream.value(AuthenticationStatus.authenticated));
        when(() => userRepository.getUser()).thenThrow(Exception('opps'));
      },
      build: () => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository),
      expect: () => const <AuthenticationState>[
        AuthenticationState.unauthenticated(),
      ],
    );
    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [unauthenticated] when status is authenticated '
      'but getUser returns null',
      setUp: () {
        when(() => authenticationRepository.status).thenAnswer(
            (invocation) => Stream.value(AuthenticationStatus.authenticated));
        when(() => userRepository.getUser()).thenAnswer((_) async => null);
      },
      build: () => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository),
      expect: () => const <AuthenticationState>[
        AuthenticationState.unauthenticated(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [unknown] when status is unknown',
      setUp: () {
        when(
          () => authenticationRepository.status,
        ).thenAnswer((_) => Stream.value(AuthenticationStatus.unknown));
      },
      build: () => AuthenticationBloc(
        authenticationRepository: authenticationRepository,
        userRepository: userRepository,
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.unKnown(),
      ],
    );
  });

  group('AuthenticationLogoutRequested', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'calls logOut on authenticationRepository '
      'when AuthenticationLogoutRequested is added',
      build: () => AuthenticationBloc(
        authenticationRepository: authenticationRepository,
        userRepository: userRepository,
      ),
      act: (bloc) => bloc.add(AuthenticationLogoutRequested()),
      verify: (_) {
        verify(() => authenticationRepository.logOut()).called(1);
      },
    );
  });
}
