import '../repositories/biometric_repository.dart';

class AuthenticateBiometrics {
  final BiometricRepository repository;

  AuthenticateBiometrics(this.repository);

  Future<bool> call() async {
    return await repository.authenticate();
  }
}
