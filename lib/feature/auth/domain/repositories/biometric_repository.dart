abstract class BiometricRepository {
  Future<bool> authenticate();
  Future<bool> isBiometricAvailable();
  Future<bool> authenticateWithDeviceCredentials();
}