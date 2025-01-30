import 'package:local_auth/local_auth.dart';

import '../../../../core/services/biometric_service.dart';

class BiometricServiceImpl implements BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  Future<List<BiometricType>> getAvailableBiometrics() async {
    return await _localAuth.getAvailableBiometrics();
  }

  @override
  Future<bool> authenticateWithBiometrics() async {
    try {
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
        ),
      );
      return isAuthenticated;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> authenticateWithDeviceCredentials() async {
    try {
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      return isAuthenticated;
    } catch (e) {
      return false;
    }
  }
}
