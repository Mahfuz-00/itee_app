import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../Data/Models/profilemodel.dart';
import '../../Data/Data Sources/API Service (Profile)/apiserviceprofile.dart';
import '../../Data/Models/profileModelFull.dart';

part 'auth_state.dart';

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


        //final userProfile = await APIProfileService.fetchUserProfile(currentState.token);
        emit(AuthAuthenticated(
          userProfile: userProfile,
          token: currentState.token,
        ));
        print('User profile fetched in Cubit:');
        print('User Profile: ${userProfile.Id}, ${userProfile.name}, ${userProfile.photo}');
      } catch (e) {
        print('Error fetching profile: $e');
        // Optionally, handle the error, e.g., by emitting an error state
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
    emit(AuthInitial());
    print('User profile and token removed from Cubit');
  }
}
