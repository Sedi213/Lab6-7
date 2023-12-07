import 'package:local_auth/local_auth.dart';

class BiometricsService {
  final LocalAuthentication _localAuthentication;
  const BiometricsService({required LocalAuthentication localAuthentication})
      : _localAuthentication = localAuthentication;

  Future<List<BiometricType>> get getAvailableBiometrics async =>
      await _localAuthentication.getAvailableBiometrics();

  Future<bool> get isFingerPrintEnabled async =>
      (await getAvailableBiometrics).contains(BiometricType.fingerprint);

  Future<bool> authenticateWithFingerPrint() async {
    return await _localAuthentication.authenticate(
      localizedReason: 'For Auth',
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );
  }
}