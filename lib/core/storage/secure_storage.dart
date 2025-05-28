import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> setLoginStatus(bool status,String uid) async {
    await _storage.write(key: 'isLoggedIn', value: status.toString());
    await _storage.write(key: 'uid', value: uid);
  }

  Future<bool> getLoginStatus() async {
    final value = await _storage.read(key: 'isLoggedIn');
    return value == 'true';
  }

  Future<String> getuid() async {
    final value = await _storage.read(key: 'uid');
    return value?? '' ;
  }
  Future<void> clearLoginStatus() async {
    await _storage.delete(key: 'isLoggedIn');
    await _storage.delete(key: 'uid');
  }
}
