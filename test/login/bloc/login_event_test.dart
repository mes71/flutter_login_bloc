import 'package:flutter_login_bloc/login/login.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const username = 'mock-username';
  const password = 'mock-password';
  group('LoginEvent', () {
    group('LoginUsernameChanged', () {
      test('supports value comparisons', () {
        expect(const LoginUsernameChanged(username),
            const LoginUsernameChanged(username));
      });
    });

    group('LoginPasswordChanged', () {
      test('supports value comparisons', () {
        expect(const LoginPasswordChanged(password),
            const LoginPasswordChanged(password));
      });
    });

    group('LoginSubmitted', () {
      test('supports value comparisons', () {
        expect(const LoginSubmitted(), const LoginSubmitted());
      });
    });
  });
}
