import 'package:local_auth/local_auth.dart';


abstract class BiometricService {
  Future<bool> authenticateWithBiometrics();
  Future<bool> authenticateWithDeviceCredentials();
  Future<List<BiometricType>> getAvailableBiometrics();
}