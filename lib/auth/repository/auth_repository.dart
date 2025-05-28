import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_connectd/core/Firebase/firebase_providers.dart';
import 'package:college_connectd/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;


final authRepositoryProvider = Provider((ref) => AuthRepository(firestore: ref.read(firebaseFirestoreProvider)));

class AuthRepository {
  final FirebaseFirestore _firestore;

  AuthRepository({
    required FirebaseFirestore firestore,
    }) : _firestore = firestore;

  CollectionReference get _user => _firestore.collection('users');

  Future<UserModel> signInWithDigi(String emailId, String password) async{

    final url = Uri.parse('https://gmrit.digiicampus.com/rest/service/authenticate');

    final Map<String, dynamic> body = {
    "email": emailId,
    "password": password,
    "registrationId": "test_registration_id",
    "phone": null,
    "browser": "Chrome",
    "deviceId": "test_device_id",
    "deviceType": "BROWSER",
    "ip": "0",
    "loginTime": "2025-05-17 14:46:04",
    "operatingSystem": "Windows",
    "rememberMe": false
  };
  
    try{
      final response = await http.post(
        url,
        headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
      );

      final jsonData = jsonDecode(response.body);
      final userJson = jsonData['res']['user'];
      userJson['password'] = body['password'];
      final user = UserModel.fromMap(userJson);
      return user;
    }
    catch(e){
      throw(e);
    }
  }
  Future<void> storeUserToFirestore(UserModel user) async {
  try {
    await _firestore
      .collection('users')
      .doc(user.registrationId)
      .set(user.toMap());
  } catch (e) {
    print("Failed to store user: $e");
  }
}

Stream<UserModel> getUserData(String uid) {
    final us =  _user.doc(uid).snapshots().map((event)=> UserModel.fromMap(event.data() as Map<String,dynamic>));
    return us;
  }

}