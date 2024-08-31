import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../Data/Models/profilemodel.dart';
import '../../Data/Data Sources/API Service (Profile)/apiserviceprofile.dart';

part 'auth_state.dart';

/// A Cubit class responsible for managing user authentication state.
/// It emits different states based on user actions like login, logout,
/// and profile fetching/updating.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void login(UserProfile userProfile, String token) {
    emit(AuthAuthenticated(userProfile: userProfile, token: token));
    print('User profile and token saved in Cubit:');
    print('User Profile: ${userProfile.Id}, ${userProfile.name}, ${userProfile.photo}');
    print('Token: $token');
  }

  Future<void> fetchProfile() async {
    print('State: $AuthAuthenticated');
    if (state is AuthAuthenticated) {
      final currentState = state as AuthAuthenticated;
      print('State Token :${currentState.token}');
      try {
        print('State: $AuthAuthenticated');
        final apiService = await APIProfileService();
        final profile = await apiService.fetchUserProfile(currentState.token);
        final UserProfile userProfile = UserProfile.fromJson(profile);
        print('Name: ${userProfile.name}');
        print('Photo: ${userProfile.photo}');

        emit(AuthAuthenticated(
          userProfile: userProfile,
          token: currentState.token,
        ));
        print('User profile fetched in Cubit:');
        print('User Profile: ${userProfile.Id}, ${userProfile.name}, ${userProfile.photo}');
      } catch (e) {
        print('Error fetching profile: $e');
      }
    } else {
      print('User profile fetched in Cubit not Found');
    }
  }

  void updateProfile(UserProfile userProfile) {
    if (state is AuthAuthenticated) {
      final currentState = state as AuthAuthenticated;
      emit(AuthAuthenticated(
        userProfile: userProfile,
        token: currentState.token,
      ));
      print('User profile updated in Cubit:');
      print('User Profile: ${userProfile.Id}, ${userProfile.name}, ${userProfile.photo}');
    }
  }

  void logout() {
    if (state is AuthAuthenticated) {
      final currentState = state as AuthAuthenticated;
      print('User profile and token removed from Cubit');
      print('User Profile: '
          'Token: ${currentState.token}, '
          'User ID: ${currentState.userProfile.Id}, '
          'User Name: ${currentState.userProfile.name}, '
          'Photo: ${currentState.userProfile.photo}');
    }
    emit(AuthInitial());

    if (state is AuthInitial) {
      print('User profile and token are now empty.');
    } else {
      print('Failed to reset state.');
    }
  }

  void removeToken() {
    emit(AuthInitial());
  }
}
