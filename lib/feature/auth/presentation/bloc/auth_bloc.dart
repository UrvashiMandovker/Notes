import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/biometric_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final BiometricRepository biometricRepository;
  AuthBloc(this.biometricRepository) : super(AuthInitialState()) {
    on<AuthenticateUserEvent>((event, emit) async {
      if (state is! AuthLoadingState) {
        emit(AuthLoadingState());
        final isAuthenticated = await biometricRepository.authenticate();
        if (isAuthenticated) {
          emit(AuthSuccessState());
        } else {
          emit(AuthFailureState());
        }
      }
    });
  }
}