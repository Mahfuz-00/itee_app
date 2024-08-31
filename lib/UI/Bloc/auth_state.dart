part of 'auth_cubit.dart';

/// Represents the authentication state of the application.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserProfile userProfile;
  final String token;

  const AuthAuthenticated({
    required this.userProfile,
    required this.token,
  });

  @override
  List<Object> get props => [userProfile, token];
}
