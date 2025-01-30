
import '../../../../core/services/biometric_service.dart';
import '../../domain/repositories/biometric_repository.dart';

class BiometricRepositoryImpl implements BiometricRepository {
  final BiometricService biometricService;

  BiometricRepositoryImpl(this.biometricService);

  @override
  Future<bool> authenticate() async {
    final biometrics = await biometricService.getAvailableBiometrics();
    if (biometrics.isNotEmpty) {
      return biometricService.authenticateWithBiometrics();
    } else {
      return authenticateWithDeviceCredentials();
    }
  }

  @override
  Future<bool> authenticateWithDeviceCredentials() async {
    return biometricService.authenticateWithDeviceCredentials();
  }

  @override
  Future<bool> isBiometricAvailable() async {
    final biometrics = await biometricService.getAvailableBiometrics();
    return biometrics.isNotEmpty;
  }
}
