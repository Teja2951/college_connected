import 'package:college_connectd/auth/controller/auth_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Api{
  final _firebaseMsg = FirebaseMessaging.instance;

  Future<void> initNotification(WidgetRef ref) async{
    await _firebaseMsg.requestPermission();
    final fcmToken = await _firebaseMsg.getToken();
    await ref.read(authControllerProvider.notifier).addToken(fcmToken);
    print('token $fcmToken');
  }
}