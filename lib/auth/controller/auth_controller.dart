import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:college_connectd/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:college_connectd/auth/repository/auth_repository.dart';
import 'package:college_connectd/core/storage/secure_storage.dart';
import 'package:college_connectd/model/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authStateProvider = StateProvider<bool?>((ref) {
  return null;
});


final authControllerProvider = StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  );
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Future<void> refreshUser() async {
    try{
      final user = _ref.read(userProvider);
      final refreshUser = await _authRepository.signInWithDigi(user!.email, user.password);
      _ref.read(userProvider.notifier).state = refreshUser;
      await _authRepository.storeUserToFirestore(refreshUser);
    }catch(e){
      print(e);
    }
  }

  Future<void> signInWithDigiCampus(String email, String password,BuildContext context) async {
    state = true;
    try {
      final user = await _authRepository.signInWithDigi(email, password);
      _ref.read(userProvider.notifier).state = user;
      await _authRepository.storeUserToFirestore(user);
      await SecureStorageService().setLoginStatus(true,user.registrationId!);
      _ref.read(authStateProvider.notifier).update((state) {
        return true;
      });
      state = false;
      const snackBar = SnackBar(
                  /// need to set following properties for best effect of awesome_snackbar_content
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'Welcome Back',
                    message:
                        'njoyyyy',

                    /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                    contentType: ContentType.success,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
//        Fluttertoast.showToast(
//   msg: "Welcome Back!!",
//   toastLength: Toast.LENGTH_SHORT,
//   gravity: ToastGravity.BOTTOM,
//   backgroundColor: Color.fromARGB(255, 0, 146, 32),
//   textColor: const Color.fromARGB(255, 255, 255, 255),
//   fontSize: 16.0,
// );
    } catch(e) {
      const materialBanner = MaterialBanner(
                  /// need to set following properties for best effect of awesome_snackbar_content
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  forceActionsBelow: true,
                  content: AwesomeSnackbarContent(
                    title: 'Enter you Digi Credentials',
                    message:
                        'Please Confirm your credentials with digicampus',

                    /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                    contentType: ContentType.warning,
                    // to configure for material banner
                    inMaterialBanner: true,
                  ),
                  actions: [SizedBox.shrink()],
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentMaterialBanner()
                  ..showMaterialBanner(materialBanner);
//      Fluttertoast.showToast(
//   msg: "Please Confirm your credentials with digicampus $e",
//   toastLength: Toast.LENGTH_SHORT,
//   gravity: ToastGravity.BOTTOM,
//   backgroundColor: Color.fromARGB(255, 255, 0, 0),
//   textColor: const Color.fromARGB(255, 255, 255, 255),
//   fontSize: 16.0,
// );
      state = false;
    }
  }

  Stream<UserModel?> userData(String uid) {
   return _authRepository.getUserData(uid);
  }
}
