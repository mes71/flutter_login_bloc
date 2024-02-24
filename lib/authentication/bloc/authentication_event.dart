part of 'authentication_bloc.dart';

sealed class AuthenticationEvent {
  const AuthenticationEvent();
}

final class _AuthenticationStatusChanged extends AuthenticationEvent {
  final AuthenticationStatus status;

  _AuthenticationStatusChanged(this.status);
}

final class AuthenticationLogoutRequested extends AuthenticationEvent {}
